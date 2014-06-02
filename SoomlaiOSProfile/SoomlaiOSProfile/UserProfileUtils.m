//
//  UserProfileUtils.m
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "UserProfileUtils.h"

@implementation UserProfileUtils

+ (NSString *)providerEnumToString:(enum Provider)provider {
    
    switch(provider) {
        case FACEBOOK:
            return @"facebook";
        case FOURSQUARE:
            return @"foursquare";
        case GOOGLE:
            return @"google";
        case LINKEDIN:
            return @"linkedin";
        case MYSPACE:
            return @"myspace";
        case TWITTER:
            return @"twitter";
        case YAHOO:
            return @"yahoo";
        case SALESFORCE:
            return @"salesforce";
        case YAMMER:
            return @"yammer";
        case RUNKEEPER:
            return @"runkeeper";
        case INSTAGRAM:
            return @"instagram";
        case FLICKR:
            return @"flickr";
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
    return nil;
}

+ (enum Provider)providerStringToEnum:(NSString *)provider {
    enum Provider result;
    
    if ([provider isEqualToString:@"facebook"]) {
        result = FACEBOOK;
    } else if ([provider isEqualToString:@"foursquare"]) {
        result = FOURSQUARE;
    } else if ([provider isEqualToString:@"google"]) {
        result = GOOGLE;
    } else if ([provider isEqualToString:@"linkedin"]) {
        result = LINKEDIN;
    } else if ([provider isEqualToString:@"twitter"]) {
        result = TWITTER;
    } else if ([provider isEqualToString:@"yahoo"]) {
        result = YAHOO;
    } else if ([provider isEqualToString:@"salesforce"]) {
        result = SALESFORCE;
    } else if ([provider isEqualToString:@"yammer"]) {
        result = YAMMER;
    } else if ([provider isEqualToString:@"runkeeper"]) {
        result = RUNKEEPER;
    } else if ([provider isEqualToString:@"instagram"]) {
        result = INSTAGRAM;
    } else if ([provider isEqualToString:@"flickr"]) {
        result = FLICKR;
    } else {
        [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
    return result;
}


@end
