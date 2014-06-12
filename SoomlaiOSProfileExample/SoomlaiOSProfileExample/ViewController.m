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

    [[SoomlaProfile getInstance] updateStatusWithProvider:FACEBOOK andStatus:@"Test status" andReward:appDelegate.updateStatusReward];
}

- (void)loginStarted:(NSNotification*)notification {
    NSString* provider = [UserProfileUtils providerEnumToString:[notification.userInfo[DICT_ELEMENT_PROVIDER] intValue]];
    LogDebug(TAG, ([NSString stringWithFormat:@"Login started with provider: %@", provider]));
}

- (void)loginFinished:(NSNotification*)notification {
    // TODO: extract user profile object from notification
    // NSDictionary* userInfo = notification.userInfo;
    
    [self showMessage:@"You are now logged in to Facebook" withTitle:@"Login Success"];
    [self.updateStatusButton setHidden:NO];
}

- (void)loginFailed:(NSNotification*)notification {
    [self showMessage:notification.userInfo[DICT_ELEMENT_MESSAGE] withTitle:@"Login Failed"];
    [self.updateStatusButton setHidden:YES];
}

- (void)loginCancelled:(NSNotification*)notification {
    [self showMessage:@"You cancelled the login process" withTitle:@"Login Cancelled"];
    [self.updateStatusButton setHidden:YES];
}


// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    LogDebug(TAG, ([NSString stringWithFormat:@"%@: %@", title, text]));
}

- (void)currencyBalanceChanged:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    self.currencyLabel.text = [NSString stringWithFormat:@"Coins: %d", [[userInfo objectForKey:@"balance"] intValue]];
}


@end
