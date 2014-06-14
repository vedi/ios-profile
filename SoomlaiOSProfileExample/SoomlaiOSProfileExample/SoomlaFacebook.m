//
//  SoomlaFacebook.m
//  SoomlaiOSProfileExample
//
//  Created by Gur Dotan on 6/10/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "SoomlaFacebook.h"
#import "UserProfile.h"
#import "UserProfileUtils.h"
#import "StoreUtils.h"

@implementation SoomlaFacebook

@synthesize loginSuccess, loginFail, loginCancel,
            logoutSuccess, logoutFail,
            userProfileSuccess, userProfileFail,
            socialActionSuccess, socialActionFail,
            feedsActionSuccess, feedsActionFail;

static NSString* TAG = @"SOOMLA SoomlaFacebook";

- (enum Provider)getProvider {
    return FACEBOOK;
}

- (void)login:(loginSuccess)success fail:(loginFail)fail cancel:(loginCancel)cancel {
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_birthday"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             self.loginSuccess = success;
             self.loginFail = fail;
             self.loginCancel = cancel;
             [self sessionStateChanged:session state:state error:error];
         }];
    }

}


/*
 Asks for the user's public profile and birthday.
 First checks for the existence of the `public_profile` and `user_birthday` permissions
 If the permissions are not present, requests them
 If/once the permissions are present, makes the user info request
 */
- (void)getUserProfile:(userProfileSuccess)success fail:(userProfileFail)fail {
    LogDebug(TAG, @"Getting user profile");
    self.userProfileSuccess = success;
    self.userProfileFail = fail;
    
    // We will request the user's public picture and the user's birthday
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"public_profile", @"user_birthday"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // These are the current permissions the user has
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  
                                  // We will store here the missing permissions that we will have to request
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted, we can request the user information
                                               [self makeRequestForUserData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                               LogError(TAG, error.description);
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  LogError(TAG, error.description);
                              }
                          }];
}


- (void)logout:(logoutSuccess)success fail:(logoutFail)fail {

    self.logoutSuccess = success;
    self.logoutFail = fail;
    
    // Clear this token
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)updateStatus:(NSString *)status success:(socialActionSuccess)success fail:(socialActionFail)fail {
    LogDebug(TAG, @"Updating status");
    
    self.socialActionSuccess = success;
    self.socialActionFail = fail;
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {

        // Present the share dialog
        // In order to post a link, change the first param to `params.link`
        [FBDialogs presentShareDialogWithLink:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              LogError(TAG, ([NSString stringWithFormat:@"Status update error: %@", error.description]));
                                              self.socialActionFail(error.description);
                                              [self clearSocialActionBlocks];
                                          } else {
                                              
                                              // Success
                                              LogDebug(TAG, ([NSString stringWithFormat:@"Status update success: %@", results]));
                                              self.socialActionSuccess();
                                              [self clearSocialActionBlocks];
                                          }
                                      }];

    } else {
        
        // Present the feed dialog
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Sharing Tutorial", @"name",
                                       @"Build great social apps and get more installs.", @"caption",
                                       @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        // In order to post a link, change the second parameter to `params`
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:nil
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          LogError(TAG, ([NSString stringWithFormat:@"Status update error: %@", error.description]));
                                                          self.socialActionFail(error.description);
                                                          [self clearSocialActionBlocks];
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              LogDebug(TAG, @"Status update cancelled");
                                                              self.socialActionFail(@"User cancelled.");
                                                              [self clearSocialActionBlocks];
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  LogDebug(TAG, @"Status update cancelled");
                                                                  self.socialActionFail(@"User cancelled.");
                                                                  [self clearSocialActionBlocks];
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  LogDebug(TAG, ([NSString stringWithFormat:@"Status update success: %@", result]));
                                                                  self.socialActionSuccess();
                                                                  [self clearSocialActionBlocks];
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}



- (void)updateStoryWithMessage:(NSString *)message
                       andName:(NSString *)name
                    andCaption:(NSString *)caption
                andDescription:(NSString *)description
                       andLink:(NSString *)link
                    andPicture:(NSString *)picture
                       success:(socialActionSuccess)success
                          fail:(socialActionFail)fail {
    @throw [NSException exceptionWithName:@"NotImplementedException" reason:@"Error, method not implemented yet." userInfo:nil];
}

- (void)getContacts:(contactsActionSuccess)success fail:(contactsActionFail)fail {
    NSLog(@"============================ getContacts ============================");
}

- (void)getFeeds:(feedsActionSuccess)success fail:(feedsActionFail)fail {
    NSLog(@"============================ getFeeds ============================");
    self.feedsActionSuccess = success;
    self.feedsActionFail = fail;
    
    /* make the API call */
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result,NSError *error) {
                              if (error) {
                                  
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  LogError(TAG, ([NSString stringWithFormat:@"Get feeds error: %@", error.description]));
                                  self.feedsActionFail(error.description);
                                  [self clearFeedActionBlocks];
                              } else {
                                  
                                  // Success
                                  LogDebug(TAG, ([NSString stringWithFormat:@"Get feeds success: %@", result]));
                                  self.feedsActionSuccess(result);
                                  [self clearFeedActionBlocks];
                              }
                          }];

}

- (void)uploadImageWithMessage:(NSString *)message
                   andFilePath:(NSString *)filePath
                       success:(socialActionSuccess)success
                          fail:(socialActionFail)fail {
    @throw [NSException exceptionWithName:@"NotImplementedException" reason:@"Error, method not implemented yet." userInfo:nil];
}



//
// Private Methods
//


// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error {
    
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        LogDebug(TAG, @"Session opened");
        
        // Callback
        self.loginSuccess(FACEBOOK);
        [self clearLoginBlocks];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        
        if (state == FBSessionStateClosedLoginFailed) {
            self.loginCancel();
            [self clearLoginBlocks];
        }
        
        if (state == FBSessionStateClosed) {
            self.logoutSuccess();
            [self clearLoginBlocks];
        }
        
        // If the session is closed
        LogDebug(TAG, @"Session closed");
    }
    
    // Handle errors
    if (error){
        LogError(TAG, @"Error");
        NSString *alertText;
        NSString *alertTitle;
        
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            
            // Callback
            self.loginFail([NSString stringWithFormat:@"%@: %@", alertTitle, alertText]);
            [self clearLoginBlocks];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                LogError(TAG, @"User cancelled login");
                
                // Callback
                self.loginCancel();
                [self clearLoginBlocks];
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                
                // Callback
                self.loginFail([NSString stringWithFormat:@"%@: %@", alertTitle, alertText]);
                [self clearLoginBlocks];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                
                // Callback
                self.loginFail([NSString stringWithFormat:@"%@: %@", alertTitle, alertText]);
                [self clearLoginBlocks];
            }
        }
        
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

/**
 A helper method for requesting user data from Facebook.
 */
- (void) makeRequestForUserData {
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            LogDebug(TAG, ([NSString stringWithFormat:@"user info: %@", result]));
            
            UserProfile* userProfile = [[UserProfile alloc] initWithProvider:FACEBOOK
                                                                andProfileId:result[@"id"]
                                                                 andUsername:result[@"email"]
                                                                    andEmail:result[@"email"]
                                                                andFirstName:result[@"first_name"]
                                                                 andLastName:result[@"last_name"]];
            
            userProfile.gender = result[@"gender"];
            userProfile.birthday = result[@"birthday"];
            userProfile.location = result[@"location"][@"name"];
            userProfile.avatarLink = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", result[@"id"]];
            
            self.userProfileSuccess(userProfile);
            [self clearUserProfileBlocks];
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            LogError(TAG, error.description);
            self.userProfileFail(error.description);
            [self clearUserProfileBlocks];
        }
    }];
}


/**
 A function for parsing URL parameters returned by the Feed Dialog.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

/*
 Helper methods for clearing callback blocks
 */

- (void)clearLoginBlocks {
    self.loginSuccess = nil;
    self.loginFail = nil;
    self.loginCancel = nil;
}

- (void)clearSocialActionBlocks {
    self.socialActionSuccess = nil;
    self.socialActionFail = nil;
}

- (void)clearUserProfileBlocks {
    self.userProfileSuccess = nil;
    self.userProfileFail = nil;
}

- (void)clearFeedActionBlocks {
    self.feedsActionSuccess = nil;
    self.feedsActionFail = nil;
}


@end
