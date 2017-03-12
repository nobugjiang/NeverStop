//
//  StepModel.h
//  NeverStop
//
//  Created by DYQ on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepModel : NSObject

@property(nonatomic,strong) NSDate *date;

@property(nonatomic,assign) int record_no;

@property(nonatomic, strong) NSString *record_time;

@property(nonatomic,assign) int step;

//g是一个震动幅度的系数,通过一定的判断条件来判断是否计做一步
@property(nonatomic,assign) double g;

@end
