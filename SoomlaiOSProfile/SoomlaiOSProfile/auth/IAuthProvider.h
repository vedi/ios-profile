//
//  IAuthProvider.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "UserProfileUtils.h"

@class UserProfile;

// Define block signatures

// TODO: Check if provider parameter is needed into this block.  It's not needed in the social blocks
typedef void (^loginSuccess)(enum Provider provider);
typedef void (^loginFail)(NSString* message);
typedef void (^loginCancel)();
typedef void (^userProfileSuccess)(UserProfile* userProfile);
typedef void (^userProfileFail)(NSString* message);
typedef void (^logoutSuccess)();
typedef void (^logoutFail)(NSString* message);


@protocol IAuthProvider <NSObject>

- (void)login:(loginSuccess)success fail:(loginFail)fail cancel:(loginCancel)cancel;

- (void)getUserProfile:(userProfileSuccess)success fail:(userProfileFail)fail;

- (void)logout:(logoutSuccess)success fail:(logoutFail)fail;

@end
