//
//  UserProfileEventHandling.m
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "UserProfileEventHandling.h"
#import "UserProfile.h"

@implementation UserProfileEventHandling

+ (void)postUserProfileUpdated:(UserProfile *)userProfile {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:userProfile forKey:DICT_ELEMENT_USER_PROFILE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UP_USER_PROFILE_UPDATED object:self userInfo:userInfo];
}

@end
