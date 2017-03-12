//
//  ExerciseData.h
//  NeverStop
//
//  Created by Jiang on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExerciseData : NSObject
+ (instancetype)shareData;
@property (nonatomic, strong) NSMutableArray *allLocationArray;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat speedPerHour;
@property (nonatomic, assign) CGFloat speedSetting;
@property (nonatomic, assign) CGFloat averageSpeedSetting;
@property (nonatomic, assign) CGFloat averageSpeed;
@property (nonatomic, assign) CGFloat maxSpeed;
@property (nonatomic, assign) CGFloat calorie;
@property (nonatomic, strong) NSString *exerciseType;
@property (nonatomic, strong) NSString *aim;
@property (nonatomic, assign) NSInteger aimType;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, assign) BOOL isComplete;
@end
