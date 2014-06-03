//
//  SocialController.m
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/3/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "SocialController.h"
#import "ISocialProvider.h"
#import "UserProfileEventHandling.h"
#import "SocialActionUtils.h"
#import "Reward.h"
#import "StoreUtils.h"

@implementation SocialController

static NSString* TAG = @"SOOMLA SocialController";


- (id)init {
    if (self = [super init]) {
        
        // TODO: Check if providerPkgPrefix can be omitted completely in iOS
        if (![self loadProvidersWithManifestKey:@"social.provider" andProviderPkgPrefix:@"com.soomla.profile.social."]) {
            NSString* msg = @"You don't have a ISocialProvider service attached. \
            Decide which ISocialProvider you want, add it to SoomlaiOSProfile-Info.plist \
            and add its static libraries and headers to the target's search path.";
            LogDebug(TAG, msg);
        }
    }
    
    return self;
}

- (void)updateStatusWithProvider:(enum Provider)provider andStatus:(NSString *)status andReward:(Reward *)reward {
    
    id<ISocialProvider> socialProvider = (id<ISocialProvider>)[self getProvider:provider];
    
    
    // Perform update status process
    [socialProvider updateStatus:status success:^{
        [UserProfileEventHandling postSocialActionFinished:UpdateStatus];
        
        if (reward) {
            [reward give];
        }
    } fail:^(NSString *message) {
        [UserProfileEventHandling postSocialActionFailed:UpdateStatus withMessage:message];
    }];
}


@end
