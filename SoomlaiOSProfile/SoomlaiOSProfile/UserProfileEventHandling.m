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

+ (void)postLoginStarted:(enum Provider)provider {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@(provider) forKey:DICT_ELEMENT_PROVIDER];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UP_LOGIN_STARTED object:self userInfo:userInfo];
}

+ (void)postLoginFinished:(UserProfile *)userProfile {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:userProfile forKey:DICT_ELEMENT_USER_PROFILE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UP_LOGIN_FINISHED object:self userInfo:userInfo];
}

+ (void)postLoginCancelled {
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UP_LOGIN_CANCELLED object:self userInfo:nil];
}

+ (void)postLoginFailed:(NSString *)message {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:DICT_ELEMENT_MESSAGE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UP_LOGIN_FINISHED object:self userInfo:userInfo];
}

+ (void)postLogoutStarted:(enum Provider)provider {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@(provider) forKey:DICT_ELEMENT_PROVIDER];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UP_LOGOUT_STARTED object:self userInfo:userInfo];
}

+ (void)postLogoutFinished:(UserProfile *)userProfile {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:userProfile forKey:DICT_ELEMENT_USER_PROFILE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UP_LOGOUT_FINISHED object:self userInfo:userInfo];
}

+ (void)postLogoutFailed:(NSString *)message {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:DICT_ELEMENT_MESSAGE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UP_LOGOUT_FINISHED object:self userInfo:userInfo];
}

+ (void)postSocialActionStarted:(enum SocialActionType)socialActionType {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@(socialActionType) forKey:DICT_ELEMENT_SOCIAL_ACTION_TYPE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UP_SOCIAL_ACTION_STARTED object:self userInfo:userInfo];
}

+ (void)postSocialActionFinished:(enum SocialActionType)socialActionType {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@(socialActionType) forKey:DICT_ELEMENT_SOCIAL_ACTION_TYPE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UP_SOCIAL_ACTION_FINISHED object:self userInfo:userInfo];
}

+ (void)postSocialActionFailed:(enum SocialActionType)socialActionType withMessage:(NSString *)message {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @(socialActionType), DICT_ELEMENT_SOCIAL_ACTION_TYPE,
                              message, DICT_ELEMENT_MESSAGE
                              , nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UP_SOCIAL_ACTION_FAILED object:self userInfo:userInfo];
}

@end
