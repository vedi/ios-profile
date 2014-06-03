//
//  ProviderLoader.m
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "ProviderLoader.h"
#import "IProvider.h"
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

- (id)getProvider:(enum Provider)provider {
    Provider p = [[self.providers objectForKey:@(provider)] intValue];
    if (!p) {
        @throw [[ProviderNotFoundException alloc] initWithProvider:provider];
    }
    
    return @(p);
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
    
    NSString* providersStr = settings[manifestKey];
    if (!providersStr || [providersStr length] == 0) {
        LogDebug(TAG, ([NSString stringWithFormat:@"Failed to load provider from SoomlaiOSProfile-Info.plist. manifest key: %@", manifestKey]));
        return nil;
    }
    
    NSArray* providerTokens = [providersStr componentsSeparatedByString:@","];
    NSMutableArray* providersArr = [NSMutableArray array];
    if ([providerTokens count] > 0) {
        for (NSString* token in providerTokens) {
            Class aClass = NSClassFromString([providerPkgPrefix stringByAppendingString:token]);
            [providersArr addObject:aClass];
        }
    }
    
    return providersArr;
}

@end
