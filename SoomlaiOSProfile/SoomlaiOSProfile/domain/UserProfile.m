//
//  UserProfile.m
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "UserProfile.h"
#import "PJSONConsts.h"

@implementation UserProfile

@synthesize provider, profileId, email, username, firstName, lastName, avatarLink, location, gender, language, birthday;


- (id)initWithProvider:(enum Provider)oProvider
          andProfileId:(NSString *)oProfileId
           andUsername:(NSString *)oUsername
              andEmail:(NSString *)oEmail
          andFirstName:(NSString *)oFirstName
           andLastName:(NSString *)oLastName {

    if (self = [super init]) {
        provider = oProvider;
        self.profileId = oProfileId;
        self.username = oUsername;
        self.email = oEmail;
        self.firstName = oFirstName;
        self.lastName = oLastName;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        provider = [UserProfileUtils providerStringToEnum:[dict objectForKey:UP_PROVIDER]];
        self.profileId = [dict objectForKey:UP_PROFILEID];
        self.username = [dict objectForKey:UP_USERNAME];
        self.email = [dict objectForKey:UP_EMAIL];
        self.firstName = [dict objectForKey:UP_FIRSTNAME];
        self.lastName = [dict objectForKey:UP_LASTNAME];
        self.avatarLink = [dict objectForKey:UP_AVATAR];
        self.location = [dict objectForKey:UP_LOCATION];
        self.gender = [dict objectForKey:UP_GENDER];
        self.language = [dict objectForKey:UP_LANGUAGE];
        self.birthday = [dict objectForKey:UP_BIRTHDAY];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            [UserProfileUtils providerEnumToString:self.provider], UP_PROVIDER,
            self.profileId, UP_PROFILEID,
            self.username, UP_USERNAME,
            self.email, UP_EMAIL,
            self.email, UP_FIRSTNAME,
            self.email, UP_LANGUAGE,
            self.email, UP_AVATAR,
            self.email, UP_LOCATION,
            self.email, UP_GENDER,
            self.email, UP_LANGUAGE,
            self.email, UP_BIRTHDAY,
            nil];
}

- (NSString *)getFullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
