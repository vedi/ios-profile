//
//  SoomlaiOSProfile.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "UserProfileUtils.h"

@class Reward;
@class UserProfile;
@class AuthController;
@class SocialController;

@interface SoomlaProfile : NSObject {
    
    @private
    AuthController* authController;
    SocialController* socialController;
}


- (id)init;

- (void)loginWithProvider:(enum Provider)provider;

- (void)loginWithProvider:(enum Provider)provider andReward:(Reward *)reward;

- (void)logoutWithProvider:(enum Provider)provider;

- (UserProfile *)getStoredUserProfileWithProvider:(enum Provider)provider;

- (void)updateStatusWithProvider:(enum Provider)provider andStatus:(NSString *)status andReward:(Reward *)reward;

- (void)updateStoryWithProvider:(enum Provider)provider
                     andMessage:(NSString *)message
                        andName:(NSString *)name
                     andCaption:(NSString *)caption
                 andDescription:(NSString *)description
                        andLink:(NSString *)link
                     andPicture:(NSString *)picture
                      andReward:(Reward *)reward;

//- (void)uploadImageWithProvider:(enum Provider)provider
//                     andMessage:(NSString *)message
//                    andFileName:(NSString *)fileName
//       andAndroidGraphicsBitmap:(AndroidGraphicsBitmap *)bitmap
//                 andJpegQuality:(int)jpegQuality
//                      andReward:(Reward *)reward;

- (void)uploadImageWithProvider:(enum Provider)provider
                   andMessage:(NSString *)message
                   andFilePath:(NSString *)filePath
                      andReward:(Reward *)reward;

- (void)getContactsWithProvider:(enum Provider)provider andReward:(Reward *)reward;

//- (void)getFeedsWithProvider:(enum Provider)provider andReward:(Reward *)reward;

+ (SoomlaProfile *)getInstance;

@end
