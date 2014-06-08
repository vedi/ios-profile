//
//  SocialCallbacks.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/8/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//


// Define block signatures

typedef void (^socialActionSuccess)();
typedef void (^socialActionFail)(NSString* message);
typedef void (^contactsActionSuccess)(NSArray* userProfiles);
typedef void (^contactsActionFail)(NSString* message);
typedef void (^feedsActionSuccess)(NSArray* feeds);
typedef void (^feedsActionFail)(NSString* message);
