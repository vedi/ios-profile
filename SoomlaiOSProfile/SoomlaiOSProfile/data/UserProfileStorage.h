//
//  UserProfileStorage.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "UserProfileUtils.h"

@class UserProfile;


@interface UserProfileStorage : NSObject

+ (void)setUserProfile:(UserProfile *)userProfile;

+ (void)setUserProfile:(UserProfile *)userProfile andNotify:(BOOL)notify;

+ (void)removeUserProfile:(UserProfile *)userProfile;

+ (UserProfile *)getUserProfile:(enum Provider)provider;

@end
