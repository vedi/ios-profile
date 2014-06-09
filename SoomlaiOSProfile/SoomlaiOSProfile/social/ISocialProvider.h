//
//  ISocialProvider.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "IAuthProvider.h"
#import "SocialCallbacks.h"




@protocol ISocialProvider <IAuthProvider>

- (void)updateStatus:(NSString *)status success:(socialActionSuccess)success fail:(socialActionFail)fail;

- (void)updateStoryWithMessage:(NSString *)message
                       andName:(NSString *)name
                    andCaption:(NSString *)caption
                andDescription:(NSString *)description
                       andLink:(NSString *)link
                    andPicture:(NSString *)picture
                       success:(socialActionSuccess)success
                          fail:(socialActionFail)fail;

- (void)getContacts:(contactsActionSuccess)success fail:(contactsActionFail)fail;

- (void)getFeeds:(feedsActionSuccess)success fail:(feedsActionFail)fail;

- (void)uploadImageWithMessage:(NSString *)message
                   andFilePath:(NSString *)filePath
                       success:(socialActionSuccess)success
                          fail:(socialActionFail)fail;

//- (void)uploadImageWithMessage:(NSString *)message
//                   andFileName:(NSString *)fileName
//                     andBitmap:()bitmap
//                andJpegQuality:(int)jpegQuality
//                       success:(socialActionSuccess)success
//                          fail:(socialActionFail)fail;



@end
