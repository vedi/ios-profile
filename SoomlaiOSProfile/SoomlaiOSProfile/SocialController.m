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

@implementation SocialController

static NSString* TAG = @"SOOMLA SocialController";


- (id)init {
    if (self = [super init]) {
        
        // TODO: Check if providerPkgPrefix can be omitted completely in iOS
        if (![self loadProvidersWithManifestKey:@"com.soomla.social.provider" andProviderPkgPrefix:@"com.soomla.profile.social."]) {
            NSString* msg = @"You don't have a ISocialProvider service attached. \
            Decide which ISocialProvider you want, add it to SoomlaiOSProfile-Info.plist \
            and add its static libraries and headers to the target's search path.";
            LogDebug(TAG, msg);
        }
    }
    
    return self;
}

- (void)updateStatusWithProvider:(enum Provider)provider andStatus:(NSString *)status andReward:(Reward *)reward {
    
    id<ISocialProvider> socialProvider = (id<ISocialProvider>)[self getProvider:provider];
    
    
    // Perform update status process
    [UserProfileEventHandling postSocialActionStarted:UpdateStatus];
    [socialProvider updateStatus:status success:^{
        [UserProfileEventHandling postSocialActionFinished:UpdateStatus];
        
        if (reward) {
            [reward give];
        }
    } fail:^(NSString *message) {
        [UserProfileEventHandling postSocialActionFailed:UpdateStatus withMessage:message];
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
    [UserProfileEventHandling postSocialActionStarted:UpdateStory];
    [socialProvider updateStoryWithMessage:message andName:name andCaption:caption
                            andDescription:description andLink:link andPicture:picture success:^{
        
        [UserProfileEventHandling postSocialActionFinished:UpdateStory];
        if (reward) {
            [reward give];
        }
    } fail:^(NSString *message) {
        [UserProfileEventHandling postSocialActionFailed:UpdateStory withMessage:message];
    }];
}

- (void)uploadImageWithProvider:(enum Provider)provider
                     andMessage:(NSString *)message
                    andFileName:(NSString *)fileName
                      andBitmap:(Bitmap *)bitmap
                 andJpegQuality:(int)jpegQuality
                      andReward:(Reward *)reward {
    
    id<ISocialProvider> socialProvider = (id<ISocialProvider>)[self getProvider:provider];
    
    // Perform upload image process
    [UserProfileEventHandling postSocialActionStarted:UploadImage];
    [socialProvider uploadImageWithMessage:message andFileName:fileName andBitmap:bitmap andJpegQuality:jpegQuality success:^{

        [UserProfileEventHandling postSocialActionFinished:UploadImage];
        if (reward) {
            [reward give];
        }
    } fail:^(NSString *message) {
        [UserProfileEventHandling postSocialActionFailed:UploadImage withMessage:message];
    }];
}

- (void)getContactsWith:(enum Provider)provider andReward:(Reward *)reward {
    
    id<ISocialProvider> socialProvider = (id<ISocialProvider>)[self getProvider:provider];
    
    // Perform get contacts process
    [UserProfileEventHandling postGetContactsStarted:GetContacts];
    [socialProvider getContacts:^(NSArray *contacts) {

        [UserProfileEventHandling postGetContactsFinished:GetContacts withContacts:contacts];
        if (reward) {
            [reward give];
        }
    } fail:^(NSString *message) {
        [UserProfileEventHandling postGetContactsFailed:GetContacts withMessage:message];
    }];
}

//- (void)getFeeds:(enum Provider)provider andReward:(Reward *)reward {
//    
//    id<ISocialProvider> socialProvider = (id<ISocialProvider>)[self getProvider:provider];
//    
//    // Perform get contacts process
//    [UserProfileEventHandling postSocialActionStarted:GetFeeds];
//    [socialProvider getContacts:^(NSArray *userProfiles) {
//        
//        [UserProfileEventHandling postSocialActionFinished:GetFeeds];
//        if (reward) {
//            [reward give];
//        }
//    } fail:^(NSString *message) {
//        [UserProfileEventHandling postSocialActionFailed:GetFeeds withMessage:message];
//    }];
//}



@end
