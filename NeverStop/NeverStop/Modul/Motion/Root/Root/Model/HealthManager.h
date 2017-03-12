//
//  HealthManager.h
//  Never Stop
//
//  Created by DYQ on 16/10/19.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface HealthManager : NSObject

@property (nonatomic,strong) HKHealthStore *healthStore;

+(id)shareInstance;

/**
 *  获取当天实时步数
 *
 *  @param handler 回调
 */
- (void)getRealTimeStepCountCompletionHandler:(void(^)(double value, NSError *error))handler;

/**
 *  获取一定时间段步数
 *
 *  @param predicate 时间段
 *  @param handler   回调
 */
- (void)getStepCount:(NSPredicate *)predicate completionHandler:(void(^)(double value, NSError *error))handler;

/**
 *  获取卡路里
 *
 *  @param predicate    时间段
 *  @param quantityType 样本类型
 *  @param handler      回调
 */
- (void)getKilocalorieUnit:(NSPredicate *)predicate quantityType:(HKQuantityType*)quantityType completionHandler:(void(^)(double value, NSError *error))handler;

/**
 *  当天时间段
 *
 *  @return .
 */
+ (NSPredicate *)predicateForSamplesToday;




@end
