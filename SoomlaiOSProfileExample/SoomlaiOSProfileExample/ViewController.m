//
//  ViewController.m
//  SoomlaiOSProfileExample
//
//  Created by Gur Dotan on 6/10/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "ViewController.h"
#import "AppDelegate.h"
#import "SoomlaProfile.h"
#import "UserProfileEventHandling.h"
#import "EventHandling.h"
#import "StoreUtils.h"


@implementation ViewController

static NSString* TAG = @"SOOMLA ViewController";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStarted:) name:EVENT_UP_LOGIN_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinished:) name:EVENT_UP_LOGIN_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:EVENT_UP_LOGIN_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCancelled:) name:EVENT_UP_LOGIN_CANCELLED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutFinished:) name:EVENT_UP_LOGOUT_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currencyBalanceChanged:) name:EVENT_CURRENCY_BALANCE_CHANGED object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonTouched:(id)sender {
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        [[SoomlaProfile getInstance] logoutWithProvider:FACEBOOK];
    } else {
        
        // Retrieve the app delegate
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;

        [[SoomlaProfile getInstance] loginWithProvider:FACEBOOK andReward:appDelegate.loginReward];
    }
}

- (IBAction)shareStatusButtontouched:(id)sender {

    // Retrieve the app delegate
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;

    [[SoomlaProfile getInstance] updateStatusWithProvider:FACEBOOK andStatus:nil andReward:appDelegate.updateStatusReward];
}

- (IBAction)updateStoryButtonTouched:(id)sender {

    // Retrieve the app delegate
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    [[SoomlaProfile getInstance] updateStoryWithProvider:FACEBOOK andMessage:nil andName:nil andCaption:nil andDescription:nil andLink:nil andPicture:nil andReward:appDelegate.updateStatusReward];
}

- (void)loginStarted:(NSNotification*)notification {
    NSString* provider = [UserProfileUtils providerEnumToString:[notification.userInfo[DICT_ELEMENT_PROVIDER] intValue]];
    LogDebug(TAG, ([NSString stringWithFormat:@"Login started with provider: %@", provider]));
}

- (void)loginFinished:(NSNotification*)notification {
    // TODO: extract user profile object from notification
    // NSDictionary* userInfo = notification.userInfo;
    
    LogDebug(TAG, @"Login Success: you are now logged in to Facebook");
    [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    [self.updateStatusButton setHidden:NO];
    [self.updateStoryButton setHidden:NO];
}

- (void)loginFailed:(NSNotification*)notification {
    LogError(TAG, ([NSString stringWithFormat:@"Login Failed: %@", notification.userInfo[DICT_ELEMENT_MESSAGE]]));
    [self.updateStatusButton setHidden:YES];
    [self.updateStoryButton setHidden:YES];
}

- (void)loginCancelled:(NSNotification*)notification {
    LogDebug(TAG, @"Login Cancelled: you cancelled the login process");
    [self.updateStatusButton setHidden:YES];
    [self.updateStoryButton setHidden:YES];
}

- (void)logoutFinished:(NSNotification*)notification {
    [self.loginButton setTitle:@"Login with Facebook to earn 100 coins" forState:UIControlStateNormal];
    [self.updateStatusButton setHidden:YES];
    [self.updateStoryButton setHidden:YES];
}

- (void)currencyBalanceChanged:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    self.currencyLabel.text = [NSString stringWithFormat:@"Coins: %d", [[userInfo objectForKey:@"balance"] intValue]];
}


@end
