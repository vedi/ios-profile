//
//  ProviderNotFoundException.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/3/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

#import "UserProfileUtils.h"

@interface ProviderNotFoundException : NSException

- (id)initWithProvider:(enum Provider)provider;

@end
