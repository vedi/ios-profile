//
//  SocialController.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/3/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "ProviderLoader.h"
#import "UserProfileUtils.h"

@class Reward;

@interface SocialController : ProviderLoader

- (id)init;

- (void)updateStatusWithProvider:(enum Provider)provider andStatus:(NSString *)status andReward:(Reward *)reward;

@end
