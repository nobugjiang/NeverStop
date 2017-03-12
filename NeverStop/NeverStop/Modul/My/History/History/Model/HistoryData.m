//
//  HistoryData.m
//  NeverStop
//
//  Created by Jiang on 16/11/5.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "HistoryData.h"

@implementation HistoryData
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone {
    HistoryData *copy = [[[self class] allocWithZone:zone] init];
    
    // 拷贝名字给副本对象
    copy.dateSection = self.dateSection;
    copy.array = [self.array copy];
    return copy;
}
@end
