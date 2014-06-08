//
//  ProviderLoader.m
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "ProviderLoader.h"
#import "ProviderNotFoundException.h"
#import "UserProfileEventHandling.h"
#import "EventHandling.h"
#import "StoreUtils.h"


@implementation ProviderLoader

@synthesize providers;

static NSString* TAG = @"SOOMLA ProviderLoader";


- (id)init {
    self = [super init];
    if ([self class] == [ProviderLoader class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    return self;
}

- (BOOL)loadProvidersWithManifestKey:(NSString *)manifestKey andProviderPkgPrefix:(NSString *)providerPkgPrefix {
    
    // Fetch a list of provider classes
    NSArray* providerClasses = [self tryFetchProvidersWithManifestKey:manifestKey andProviderPkgPrefix:providerPkgPrefix];
    if (!providerClasses || [providerClasses count] == 0) {
        return NO;
    }
    
    self.providers = [NSMutableDictionary dictionary];
    
    // Instantiate each provider class with reflection
    for (Class klass in providerClasses) {
        @try {
            id provider = [[klass alloc] init];
            self.providers[@([provider getProvider])] = provider;
        }
        @catch (NSException *exception) {
            LogError(TAG, @"Couldn't instantiate provider class. Something's totally wrong here.");
        }
    }
    
    return YES;
}

- (void)handleErrorResultWithMessage:(NSString *)message {
    [EventHandling postUnexpectedError:ERR_GENERAL forObject:self];
    LogError(TAG, ([NSString stringWithFormat:@"ERROR: %@", message]));
             
    // TODO: Ask Refael:
    // Java implementation of this event is different than ObjC
    // BusProvider.getInstance().post(new UnexpectedStoreErrorEvent(message));
}

- (id<IProvider>)getProvider:(enum Provider)provider {
    id<IProvider> p = [self.providers objectForKey:@(provider)];
    if (!p) {
        @throw [[ProviderNotFoundException alloc] initWithProvider:provider];
    }
    
    return p;
}




- (NSArray *)tryFetchProvidersWithManifestKey:(NSString *)manifestKey
                         andProviderPkgPrefix:(NSString *)providerPkgPrefix {
    
    // Get settings from .plist file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Supporting Files/SoomlaiOSProfile-Info" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    if (!settings) {
        LogDebug(TAG, ([NSString stringWithFormat:@"Failed to load provider from SoomlaiOSProfile-Info.plist. manifest key: %@", manifestKey]));
        return nil;
    }
    
    NSArray* providerClassNames = settings[manifestKey];
    if (![providerClassNames count]) {
        LogDebug(TAG, ([NSString stringWithFormat:@"Failed to load provider from SoomlaiOSProfile-Info.plist. manifest key: %@", manifestKey]));
        return nil;
    }
    
    NSMutableArray* providersArr = [NSMutableArray array];
    for (NSString* providerItem in providerClassNames) {
        
        // TODO: Check if the providerPkgPrefix can be omitted completely in iOS
        // This is the original line of code:
        // Class aClass = NSClassFromString([providerPkgPrefix stringByAppendingString:token]);
        
        Class aClass = NSClassFromString(providerItem);
        [providersArr addObject:aClass];
    }
    
    return providersArr;
}

@end
