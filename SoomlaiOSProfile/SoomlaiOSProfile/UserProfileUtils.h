//
//  UserProfileUtils.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//


typedef NS_ENUM(NSInteger, Provider) {
    FACEBOOK,
    FOURSQUARE,
    GOOGLE,
    LINKEDIN,
    MYSPACE,
    TWITTER,
    YAHOO,
    SALESFORCE,
    YAMMER,
    RUNKEEPER,
    INSTAGRAM,
    FLICKR
};


@interface UserProfileUtils : NSObject

+ (NSString *)providerEnumToString:(enum Provider)provider;

+ (enum Provider)providerStringToEnum:(NSString *)provider;

@end
