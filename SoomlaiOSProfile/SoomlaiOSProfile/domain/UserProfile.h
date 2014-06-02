//
//  UserProfile.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

@interface UserProfile : NSObject {
    
    @private
    
    // TODO: enumify (everywhere - don't forget class implementation)
    NSString* provider;
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

@property (strong, nonatomic) NSString* provider;
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

- (id)initWithProvider:(NSString *)oProvider
          andProfileId:(NSString *)oProfileId
           andUsername:(NSString *)oUsername
              andEmail:(NSString *)oEmail
          andFirstName:(NSString *)oFirstName
           andLastName:(NSString *)oLastName;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary*)toDictionary;

- (NSString *)getFullName;


@end
