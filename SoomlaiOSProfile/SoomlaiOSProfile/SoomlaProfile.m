//
//  SoomlaiOSProfile.m
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "SoomlaProfile.h"
#import "Reward.h"
#import "AuthController.h"
#import "SocialController.h"
#import "UserProfileUtils.h"

@implementation SoomlaProfile


- (void)initialize {
    authController = [[AuthController alloc] init];
    socialController = [[SocialController alloc] init];
}

- (void)loginWithProvider:(enum Provider)provider {
    [self loginWithProvider:provider andReward:nil];
}

- (void)loginWithProvider:(enum Provider)provider andReward:(Reward *)reward {
    @try {
        [authController loginWithProvider:provider andReward:reward];
    }
    @catch (NSException *exception) {

        // TODO: implement logic like in java that will raise the exception. Currently not raised
        [socialController loginWithProvider:provider andReward:reward];
    }
}

- (void)logoutWithProvider:(enum Provider)provider {
    @try {
        [authController logoutWithProvider:provider];
    }
    @catch (NSException *exception) {

        // TODO: implement logic like in java that will raise the exception. Currently not raised
        [socialController logoutWithProvider:provider];
    }
}

- (UserProfile *)getStoredUserProfileWithProvider:(enum Provider)provider {
    @try {
        [authController getStoredUserProfileWithProvider:provider];
    }
    @catch (NSException *exception) {
        
        // TODO: implement logic like in java that will raise the exception. Currently not raised
        [socialController getStoredUserProfileWithProvider:provider];
    }
}

- (void)updateStatusWithProvider:(enum Provider)provider andStatus:(NSString *)status andReward:(Reward *)reward {
    [socialController updateStatusWithProvider:provider andStatus:status andReward:reward];
}

- (void)updateStoryWithProvider:(enum Provider)provider
                     andMessage:(NSString *)message
                        andName:(NSString *)name
                     andCaption:(NSString *)caption
                 andDescription:(NSString *)description
                        andLink:(NSString *)link
                     andPicture:(NSString *)picture
                      andReward:(Reward *)reward {
    [socialController updateStoryWithProvider:provider andMessage:message andName:name andCaption:caption
                               andDescription:description andLink:link andPicture:picture andReward:reward];
}

- (void)uploadImageWithProvider:(enum Provider)provider
                     andMessage:(NSString *)message
                    andFileName:(NSString *)fileName
       andAndroidGraphicsBitmap:(AndroidGraphicsBitmap *)bitmap
                 andJpegQuality:(int)jpegQuality
                      andReward:(Reward *)reward {
    [socialController uploadImageWithProvider:provider andMessage:message andFileName:fileName
                                    andBitmap:bitmap andJpegQuality:jpegQuality andReward:reward];
}

- (void)uploadImageWithProvider:(enum Provider)provider
                     andMessage:(NSString *)message
                    andFilePath:(NSString *)filePath
                      andReward:(Reward *)reward {
    [socialController uploadImageWithProvider:provider andMessage:message andFilePath:filePath andReward:reward];
}

- (void)getContactsWithProvider:(enum Provider)provider andReward:(Reward *)reward {
    [socialController getContactsWith:provider andReward:reward];
}

//- (void)getFeedsWithProvider:(enum Provider)provider andReward:(Reward *)reward {
//    [socialController getFeedsWith:provider andReward:reward];
//}



// private

+ (SoomlaProfile*)getInstance {
    static SoomlaProfile* _instance = nil;
    
    @synchronized( self ) {
        if( _instance == nil ) {
            _instance = [[SoomlaProfile alloc ] init];
        }
    }
    
    return _instance;
}

@end
