//
//  ISocialProvider.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "IAuthProvider.h"


// Define block signatures

typedef void (^socialActionSuccess)();
typedef void (^socialActionFail)(NSString* message);
typedef void (^contactsActionSuccess)(NSArray* userProfiles);
typedef void (^contactsActionFail)(NSString* message);



@protocol ISocialProvider <IAuthProvider>

- (void)updateStatus:(NSString *)status success:(socialActionSuccess)success fail:(socialActionFail)fail;

//- (void)updateStoryWithMessage:(NSString *)message
//                       andName:(NSString *)name
//                    andCaption:(NSString *)caption
//                andDescription:(NSString *)description
//                       andLink:(NSString *)link
//                    andPicture:(NSString *)picture
//                       success:(socialActionSuccess)success
//                          fail:(socialActionFail)fail;
//
//- (void)getContacts:(contactsActionSuccess)success fail:(contactsActionFail)fail;

@end
