//
//  UserProfile.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "UserProfileUtils.h"

@interface UserProfile : NSObject {
    
    @private
    
    Provider provider;
    NSString* profileId;
    NSString* username;
    NSString* email;
    NSString* firstName;
    NSString* lastName;
    NSString* avatarLink;
    NSString* location;
    NSString* gender;
    NSString* language;
    NSString* birthday;
}

@property (readonly, nonatomic) enum Provider provider;
@property (strong, nonatomic) NSString* profileId;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* avatarLink;
@property (strong, nonatomic) NSString* location;
@property (strong, nonatomic) NSString* gender;
@property (strong, nonatomic) NSString* language;
@property (strong, nonatomic) NSString* birthday;

- (id)initWithProvider:(enum Provider)oProvider
          andProfileId:(NSString *)oProfileId
           andUsername:(NSString *)oUsername
              andEmail:(NSString *)oEmail
          andFirstName:(NSString *)oFirstName
           andLastName:(NSString *)oLastName;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary*)toDictionary;

- (NSString *)getFullName;


@end
