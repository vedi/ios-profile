/*
 Copyright (C) 2012-2015 Soomla Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <JSONConsts.h>
#import "Leaderboard.h"
#import "PJSONConsts.h"


@implementation Leaderboard {

}

-(instancetype)initWithProvider:(Provider)oProvider {
    if (self = [super init]) {
        _provider = oProvider;
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _ID = dict[UP_IDENTIFIER];
        _provider = [UserProfileUtils providerStringToEnum:dict[UP_PROVIDER]];
        _iconUrl = dict[UP_ICON_URL];
        _name = dict[UP_NAME];
    }
    return self;
}

-(NSDictionary *)toDictionary {
    return @{
            UP_IDENTIFIER: self.ID,
            UP_PROVIDER : [UserProfileUtils providerEnumToString:self.provider],
            UP_NAME: self.name ? self.name : @"",
            UP_ICON_URL: self.iconUrl ? self.iconUrl : @"",
    };
}

@end