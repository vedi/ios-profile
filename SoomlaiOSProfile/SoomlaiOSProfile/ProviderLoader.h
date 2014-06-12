//
//  ProviderLoader.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "UserProfileUtils.h"
#import "IProvider.h"


// TODO: Document Abstract class
@interface ProviderLoader : NSObject {
    
    @private
    NSMutableDictionary* providers;
}

@property (strong, nonatomic) NSMutableDictionary* providers;


- (id)init;

- (BOOL)loadProvidersWithProtocol:(Protocol *)protocol;

- (void)handleErrorResultWithMessage:(NSString *)message;

- (id<IProvider>)getProvider:(enum Provider)provider;


@end
