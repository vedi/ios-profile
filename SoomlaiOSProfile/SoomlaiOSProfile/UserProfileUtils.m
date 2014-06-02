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
    NSString *result = nil;
    
    switch(provider) {
        case FACEBOOK:
            result = @"facebook";
            break;
        case FOURSQUARE:
            result = @"foursquare";
            break;
        case GOOGLE:
            result = @"google";
            break;
        case LINKEDIN:
            result = @"linkedin";
            break;
        case MYSPACE:
            result = @"myspace";
            break;
        case TWITTER:
            result = @"twitter";
            break;
        case YAHOO:
            result = @"yahoo";
            break;
        case SALESFORCE:
            result = @"salesforce";
            break;
        case YAMMER:
            result = @"yammer";
            break;
        case RUNKEEPER:
            result = @"runkeeper";
            break;
        case INSTAGRAM:
            result = @"instagram";
            break;
        case FLICKR:
            result = @"flickr";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
    return result;
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
