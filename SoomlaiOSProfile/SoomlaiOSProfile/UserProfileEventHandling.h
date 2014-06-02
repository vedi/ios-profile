//
//  UserProfileEventHandling.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//


@class UserProfile;

// Events
#define EVENT_UP_USER_PROFILE_UPDATED           @"up_user_profile_updated"

// UserInfo Elements
#define DICT_ELEMENT_USER_PROFILE               @"userProfile"


@interface UserProfileEventHandling : NSObject

+ (void)postUserProfileUpdated:(UserProfile *)userProfile;

@end
