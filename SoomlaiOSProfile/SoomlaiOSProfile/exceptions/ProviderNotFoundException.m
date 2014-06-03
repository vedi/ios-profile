//
//  ProviderNotFoundException.m
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/3/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "ProviderNotFoundException.h"

@implementation ProviderNotFoundException

- (id)initWithProvider:(enum Provider)provider {
    NSString* reason = [NSString stringWithFormat:@"Provider not found when search with '%@'", [UserProfileUtils providerEnumToString:provider]];
    NSDictionary* userInfo = @{@"provider" : @(provider)};

    self = [super initWithName:@"VirtualItemNotFoundException" reason:reason userInfo:userInfo];
    if (self){
        
    }
    
    return self;
}

@end
