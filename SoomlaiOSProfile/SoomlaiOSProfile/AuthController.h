//
//  AuthController.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/3/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "ProviderLoader.h"
#import "UserProfileUtils.h"

@class Reward;
@class UserProfile;

@interface AuthController : ProviderLoader

- (id)init;

- (void)loginWithProvider:(enum Provider)provider andReward:(Reward *)reward;

- (void)logoutWithProvider:(enum Provider)provider;

- (UserProfile *)getUserProfileLocallyWithProvider:(enum Provider)provider;

@end
