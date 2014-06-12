//
//  SocialController.m
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/3/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "SocialController.h"
#import "ISocialProvider.h"
#import "UserProfileEventHandling.h"
#import "SocialActionUtils.h"
#import "Reward.h"
#import "StoreUtils.h"
#import "ISocialProvider.h"

@implementation SocialController

static NSString* TAG = @"SOOMLA SocialController";


- (id)init {
    if (self = [super initWithoutLoadingProviders]) {
        
        // TODO: Check if providerPkgPrefix can be omitted completely in iOS
        if (![self loadProvidersWithProtocol:@protocol(ISocialProvider)]) {
            NSString* msg = @"You don't have a ISocialProvider service attached. \
            Decide which ISocialProvider you want, and add its static libraries \
            and headers to the target's search path.";
            LogDebug(TAG, msg);
        }
    }
    
    return self;
}

- (void)updateStatusWithProvider:(enum Provider)provider andStatus:(NSString *)status andReward:(Reward *)reward {
    
    id<ISocialProvider> socialProvider = (id<ISocialProvider>)[self getProvider:provider];
    
    
    // Perform update status process
    [UserProfileEventHandling postSocialActionStarted:UPDATE_STATUS];
    [socialProvider updateStatus:status success:^{
        [UserProfileEventHandling postSocialActionFinished:UPDATE_STATUS];
        
        if (reward) {
            [reward give];
        }
    } fail:^(NSString *message) {
        [UserProfileEventHandling postSocialActionFailed:UPDATE_STATUS withMessage:message];
    }];
}

- (void)updateStoryWithProvider:(enum Provider)provider
                     andMessage:(NSString *)message
                        andName:(NSString *)name
                     andCaption:(NSString *)caption
                 andDescription:(NSString *)description
                        andLink:(NSString *)link
                     andPicture:(NSString *)picture
                      andReward:(Reward *)reward {

    id<ISocialProvider> socialProvider = (id<ISocialProvider>)[self getProvider:provider];
    
    // Perform update story process
    [UserProfileEventHandling postSocialActionStarted:UPDATE_STORY];
    [socialProvider updateStoryWithMessage:message andName:name andCaption:caption
                            andDescription:description andLink:link andPicture:picture success:^{
        
        [UserProfileEventHandling postSocialActionFinished:UPDATE_STORY];
        if (reward) {
            [reward give];
        }
    } fail:^(NSString *message) {
        [UserProfileEventHandling postSocialActionFailed:UPDATE_STORY withMessage:message];
    }];
}

- (void)uploadImageWithProvider:(enum Provider)provider
                     andMessage:(NSString *)message
                    andFilePath:(NSString *)filePath
                      andReward:(Reward *)reward {
    
    id<ISocialProvider> socialProvider = (id<ISocialProvider>)[self getProvider:provider];
    
    // Perform upload image process
    [UserProfileEventHandling postSocialActionStarted:UPLOAD_IMAGE];
    [socialProvider uploadImageWithMessage:message andFilePath:filePath success:^{
        
        [UserProfileEventHandling postSocialActionFinished:UPLOAD_IMAGE];
        if (reward) {
            [reward give];
        }
    } fail:^(NSString *message) {
        [UserProfileEventHandling postSocialActionFailed:UPLOAD_IMAGE withMessage:message];
    }];
}


//- (void)uploadImageWithProvider:(enum Provider)provider
//                     andMessage:(NSString *)message
//                    andFileName:(NSString *)fileName
//                      andBitmap:(Bitmap *)bitmap
//                 andJpegQuality:(int)jpegQuality
//                      andReward:(Reward *)reward {
//    
//    id<ISocialProvider> socialProvider = (id<ISocialProvider>)[self getProvider:provider];
//    
//    // Perform upload image process
//    [UserProfileEventHandling postSocialActionStarted:UPLOAD_IMAGE];
//    [socialProvider uploadImageWithMessage:message andFileName:fileName andBitmap:bitmap andJpegQuality:jpegQuality success:^{
//
//        [UserProfileEventHandling postSocialActionFinished:UPLOAD_IMAGE];
//        if (reward) {
//            [reward give];
//        }
//    } fail:^(NSString *message) {
//        [UserProfileEventHandling postSocialActionFailed:UPLOAD_IMAGE withMessage:message];
//    }];
//}

- (void)getContactsWith:(enum Provider)provider andReward:(Reward *)reward {
    
    id<ISocialProvider> socialProvider = (id<ISocialProvider>)[self getProvider:provider];
    
    // Perform get contacts process
    [UserProfileEventHandling postGetContactsStarted:GET_CONTACTS];
    [socialProvider getContacts:^(NSArray *contacts) {

        [UserProfileEventHandling postGetContactsFinished:GET_CONTACTS withContacts:contacts];
        if (reward) {
            [reward give];
        }
    } fail:^(NSString *message) {
        [UserProfileEventHandling postGetContactsFailed:GET_CONTACTS withMessage:message];
    }];
}

//- (void)getFeeds:(enum Provider)provider andReward:(Reward *)reward {
//    
//    id<ISocialProvider> socialProvider = (id<ISocialProvider>)[self getProvider:provider];
//    
//    // Perform get contacts process
//    [UserProfileEventHandling postSocialActionStarted:GET_FEEDS];
//    [socialProvider getContacts:^(NSArray *userProfiles) {
//        
//        [UserProfileEventHandling postSocialActionFinished:GET_FEEDS];
//        if (reward) {
//            [reward give];
//        }
//    } fail:^(NSString *message) {
//        [UserProfileEventHandling postSocialActionFailed:GET_FEEDS withMessage:message];
//    }];
//}



@end
