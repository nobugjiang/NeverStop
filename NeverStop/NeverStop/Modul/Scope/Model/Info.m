//
//  Info.m
//  NeverStop
//
//  Created by dllo on 16/10/29.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "Info.h"

@implementation Info
//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{
//             @"content" : @"description"
//             };
//}


+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"content" : @"description",
             };
}

- (void)setUser_count:(NSNumber *)user_count {
    _user_count = user_count;
    if ([user_count isEqualToNumber:@(-1)] ) {
        _user_count = @(1000);
    }
}


@end
