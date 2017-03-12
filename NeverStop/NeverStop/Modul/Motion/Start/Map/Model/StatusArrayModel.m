//
//  StatusArrayModel.m
//  NeverStop
//
//  Created by Jiang on 16/11/2.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "StatusArrayModel.h"

@implementation StatusArrayModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone {
    StatusArrayModel *copy = [[[self class] allocWithZone:zone] init];
    
    // 拷贝名字给副本对象
    copy.isStart = self.isStart;
    copy.array = [self.array copy];
    return copy;
}

@end
