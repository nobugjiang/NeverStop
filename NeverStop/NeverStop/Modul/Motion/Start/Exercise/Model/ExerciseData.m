//
//  ExerciseData.m
//  NeverStop
//
//  Created by Jiang on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ExerciseData.h"

@implementation ExerciseData
+ (instancetype)shareData {
    static ExerciseData *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[ExerciseData alloc] init];
    });
    return data;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allLocationArray = [NSMutableArray array];

    }
    return self;
}
@end
