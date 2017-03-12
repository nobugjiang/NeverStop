//
//  WeekRecordView.m
//  NeverStop
//
//  Created by DYQ on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "WeekRecordView.h"
#import "StepCountModel.h"

@interface WeekRecordView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) SQLiteDatabaseManager *manager;
@property (nonatomic, strong) NSMutableArray *selectStringArray;
@property (nonatomic, strong) NSString *yearString;
@property (nonatomic, strong) NSString *monthString;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) NSArray *dayArr;

@end

@implementation WeekRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {

        [_manager openSQLite];

        self.maxCount = 0;
        self.selectStringArray = [NSMutableArray array];
        
        self.yearString = [NSDate getSystemTimeStringWithFormat:@"yyyy"];
        self.monthString = [NSDate getSystemTimeStringWithFormat:@"MM"];
        self.manager = [SQLiteDatabaseManager shareManager];
        NSString *dayString = [NSDate getSystemTimeStringWithFormat:@"dd"];
        NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", _yearString, _monthString, dayString];
        NSDate *date = [NSDate dateWithString:dateString format:@"yyyy-MM-dd"];
        
        

        
        for (int i = 0; i < 7; i++) {
            
            UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 8 * (i + 1), 70, 7, 70)];
            rectView.backgroundColor = [UIColor colorWithRed:0.8534 green:0.8534 blue:0.8534 alpha:1.0];
            rectView.layer.cornerRadius = 3;
            rectView.clipsToBounds = YES;
            [self addSubview:rectView];
        
            UIView *changeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 0)];
            changeView.tag = 1300 + i;
            changeView.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
            changeView.layer.cornerRadius = 3;
            changeView.clipsToBounds = YES;
            [rectView addSubview:changeView];

            // 秒数
            NSTimeInterval time = (6 - i) * 24 * 60 * 60;
            // 下周就把"-"去掉
            NSDate *lastWeek = [date dateByAddingTimeInterval:-time];
            NSString *startDate =  [lastWeek stringWithDateFormat:@"yyyy-MM-dd"];
            [_selectStringArray addObject:startDate];

            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(rectView.x - 10, rectView.y + rectView.height + 5, 30, 20)];
            dateLabel.text = [NSString stringWithFormat:@"%@日", [startDate substringWithRange:NSMakeRange(8, 2)]];
            dateLabel.font = kFONT_SIZE_10_BOLD;
            dateLabel.textAlignment = NSTextAlignmentCenter;
            dateLabel.textColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
            [self addSubview:dateLabel];
            
            
//            [_manager openSQLite];
//            StepCountModel *stepCountModel = [_manager selectStepCountWithDate:_selectStringArray[i]];
//            [_countArray addObject:stepCountModel];
//            [_manager closeSQLite];
        }
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(change) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)change {
    
    for (int i = 0; i < 7; i++) {
        

        UIView *changeView = [self viewWithTag:1300 + i];
        
        CGRect frame = changeView.frame;
        changeView.frame = frame;
        
        StepCountModel *stepCountModel = [_manager selectStepCountWithDate:_selectStringArray[i]];

        CGFloat count = [stepCountModel.stepCount integerValue] * 70 / _count;
        self.maxCount = _maxCount > count ? _maxCount : count;
        
        if (frame.size.height> _maxCount) {
            // 清除定时器
            [_timer invalidate];
        }
        frame.size.height = frame.size.height + 1;
        if (frame.size.height > count) {
            frame.size.height = count;
        }
        changeView.frame = CGRectMake(0, 70 - frame.size.height, frame.size.width, frame.size.height);
    }
    
    
}


@end
