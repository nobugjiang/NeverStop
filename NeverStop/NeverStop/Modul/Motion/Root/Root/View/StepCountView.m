//
//  StepCountView.m
//  NeverStop
//
//  Created by DYQ on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "StepCountView.h"
#import "StepManager.h"
#import "StepCountModel.h"
#import "TargetViewController.h"
#import "DYQProgressView.h"

@interface StepCountView () {
    NSTimer *timer;
}


@property (nonatomic, strong) UIView *roundView;
@property (nonatomic, assign) long systemStep;
@property (nonatomic, strong) SQLiteDatabaseManager *sqlManager;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, assign) long step;
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, strong) DYQProgressView *stepProgressView;

@end


@implementation StepCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sqlManager = [SQLiteDatabaseManager shareManager];
        self.dateString = [NSDate getSystemTimeStringWithFormat:@"yyyy-MM-dd"];
        self.percent = 0;
        
        // 用CMPedometer记录步数
        self.pedometer = [[CMPedometer alloc] init];
        // 开始计步
        [_pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            self.step = [pedometerData.numberOfSteps integerValue];
        }];
        
        self.roundView = [[UIView alloc]initWithFrame:CGRectMake(90, 10, SCREEN_WIDTH - 180, SCREEN_WIDTH - 180)];
        _roundView.layer.cornerRadius = _roundView.width / 2;
        _roundView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:0.4].CGColor;
        _roundView.layer.borderWidth = 1.0f;
        [self addSubview:_roundView];
        
        // 进度条
        self.stepProgressView = [[DYQProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 155, SCREEN_WIDTH - 155)];
        _stepProgressView.center = _roundView.center;
        [self addSubview:_stepProgressView];
        [_stepProgressView setProgressStrokeColor:[UIColor whiteColor]];
        [_stepProgressView setBackgroundStrokeColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3]];
        
        
        self.todayLabel = [[UILabel alloc] initWithFrame:CGRectMake((_roundView.width - 80) / 2, 30, 80, 30)];
        _todayLabel.text = @"今日步数";
        _todayLabel.textAlignment = NSTextAlignmentCenter;
        _todayLabel.font = kFONT_SIZE_18;
        _todayLabel.textColor = [UIColor whiteColor];
        [_roundView addSubview:_todayLabel];
        
        self.stepCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_roundView.height - 80) / 2, _roundView.width, 80)];
        _stepCountLabel.textColor = [UIColor whiteColor];
        _stepCountLabel.textAlignment = NSTextAlignmentCenter;
        _stepCountLabel.font = [UIFont fontWithName:@"GeezaPro-Bold" size:60];
        [_roundView addSubview:_stepCountLabel];
        
        self.targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _stepCountLabel.y + _stepCountLabel.height + 5, _roundView.width, 35)];
        _targetLabel.textAlignment = NSTextAlignmentCenter;
        _targetLabel.textColor = [UIColor whiteColor];
        _targetLabel.font = kFONT_SIZE_18;
        [_roundView addSubview:_targetLabel];
        
        [[HealthManager shareInstance] getStepCount:[HealthManager predicateForSamplesToday] completionHandler:^(double value, NSError *error) {
            if (error) {
                NSLog(@"error");
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_sqlManager openSQLite];
                    NSString *stepCountFromSQL = [_sqlManager selectStepCountWithDate:_dateString].stepCount;

                    if (value > [stepCountFromSQL integerValue]) {
                        self.systemStep = value;
                    } else {
                        self.systemStep = [stepCountFromSQL integerValue];
                    }

                    [_sqlManager updateStepCount:[NSString stringWithFormat:@"%ld", _systemStep] date:_dateString];

                    _stepCountLabel.text = [NSString stringWithFormat:@"%ld",_step + _systemStep];

                    self.percent = _systemStep / [_targetLabel.text floatValue];
                    [_stepProgressView setProgress:_percent Animated:YES];
                    
                });
            }
        }];
        
        //        [[StepManager shareManager] startWithStep];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(getStepNumber) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        
    }
    return self;
}


- (void)getStepNumber{
    //    long step = [StepManager shareManager].step;
    _stepCountLabel.text = [NSString stringWithFormat:@"%ld",_step + _systemStep];

//    [_sqlManager updateStepCount:_stepCountLabel.text date:_dateString];

}

- (void)setTarget:(NSString *)target {
    if (_target != target) {
        _target = target;
        _targetLabel.text = target;
        self.percent = _systemStep / [_targetLabel.text floatValue];
        [_stepProgressView setProgress:_percent Animated:YES];

    }
}
@end
