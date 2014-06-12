//
//  AppDelegate.h
//  SoomlaiOSProfileExample
//
//  Created by Gur Dotan on 6/10/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "ViewController.h"

@class VirtualItemReward;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    @private
    VirtualItemReward* loginReward;
    VirtualItemReward* updateStatusReward;
}

@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) VirtualItemReward* loginReward;
@property (strong, nonatomic) VirtualItemReward* updateStatusReward;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)userLoggedIn;
- (void)userLoggedOut;

@end
