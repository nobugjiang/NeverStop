//
//  StepManager.h
//  NeverStop
//
//  Created by DYQ on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepManager : NSObject

@property (nonatomic, assign) NSInteger step;

+ (StepManager *)shareManager;

// 开始计步
- (void)startWithStep;

// 得到计步所消耗的卡路里
//+ (NSInteger)getStepCalorie;

// 得到所走的路程(单位:米)
//+ (CGFloat)getStepDistance;

// 得到运动所用的时间
//+ (NSInteger)getStepTime;


@end
