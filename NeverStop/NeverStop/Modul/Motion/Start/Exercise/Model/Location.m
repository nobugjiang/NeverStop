//
//  Location.m
//  NeverStop
//
//  Created by Jiang on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "Location.h"

@implementation Location
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone {
    Location *copy = [[[self class] allocWithZone:zone] init];
    
    // 拷贝名字给副本对象
    copy.isStart = self.isStart;
    copy.latitude = self.latitude;
    copy.longitude = self.longitude;
    return copy;
}
@end
