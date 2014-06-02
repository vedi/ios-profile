//
//  UserProfileStorage.m
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "UserProfileStorage.h"
#import "UserProfile.h"
#import "UserProfileEventHandling.h"
#import "StorageManager.h"
#import "KeyValueStorage.h"
#import "StoreUtils.h"

@implementation UserProfileStorage

static NSString* DB_KEY_PREFIX  = @"soomla.profile";
static NSString* TAG            = @"SOOMLA UserProfileStorage";


+ (void)setUserProfile:(UserProfile *)userProfile {
    [self setUserProfile:userProfile andNotify:YES];
}

+ (void)setUserProfile:(UserProfile *)userProfile andNotify:(BOOL)notify {

    NSString* value = [StoreUtils dictToJsonString:[userProfile toDictionary]];
    NSString* key = [self keyUserProfile:userProfile.provider];
    [[[StorageManager getInstance] keyValueStorage] setValue:value forKey:key];
    if (notify) {
        [UserProfileEventHandling postUserProfileUpdated:userProfile];
    }
}

+ (void)removeUserProfile:(UserProfile *)userProfile {
    NSString* key = [self keyUserProfile:userProfile.provider];
    [[[StorageManager getInstance] keyValueStorage] deleteValueForKey:key];
}

+ (UserProfile *)getUserProfile:(enum Provider)provider {
    
    NSString* key = [self keyUserProfile:provider];
    NSString* userProfileJSON = [[[StorageManager getInstance] keyValueStorage] getValueForKey:key];
    
    if (!userProfileJSON || [userProfileJSON length] == 0) {
        return nil;
    }
    
    NSDictionary* userProfileDict = [StoreUtils jsonStringToDict:userProfileJSON];
    return [[UserProfile alloc] initWithDictionary:userProfileDict];
}

+ (NSString *)keyUserProfile:(enum Provider)provider {
    return [NSString stringWithFormat:@"%@userprofile.%@", DB_KEY_PREFIX, [UserProfileUtils providerEnumToString:provider]];
}

@end
