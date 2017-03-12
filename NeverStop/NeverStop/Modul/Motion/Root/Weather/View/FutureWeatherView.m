//
//  FutureWeatherView.m
//  NeverStop
//
//  Created by DYQ on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "FutureWeatherView.h"

@interface FutureWeatherView ()

@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) UIImageView *weatherImageView;

@end

@implementation FutureWeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height / 4)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.font = kFONT_SIZE_18;
        [self addSubview:_dateLabel];
        
        self.tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _dateLabel.y + _dateLabel.height, _dateLabel.width, _dateLabel.height)];
        _tempLabel.textAlignment = NSTextAlignmentCenter;
        _tempLabel.textColor = [UIColor whiteColor];
        _dateLabel.font = kFONT_SIZE_18;
        [self addSubview:_tempLabel];
        
        self.weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 30) / 2, _tempLabel.y + _tempLabel.height, 30, 30)];
        [self addSubview:_weatherImageView];
    }
    return self;
}

- (void)setDayForecast:(AMapLocalDayWeatherForecast *)dayForecast {
    if (_dayForecast != dayForecast) {
        _dayForecast = dayForecast;
        NSString *day = dayForecast.week;
        switch ([day intValue]) {
            case 1:
                _dateLabel.text = @"周一";
                break;
            case 2:
                _dateLabel.text = @"周二";
                break;
            case 3:
                _dateLabel.text = @"周三";
                break;
            case 4:
                _dateLabel.text = @"周四";
                break;
            case 5:
                _dateLabel.text = @"周五";
                break;
            case 6:
                _dateLabel.text = @"周六";
                break;
            case 7:
                _dateLabel.text = @"周日";
                break;
            default:
                break;
        }
        _tempLabel.text = [NSString stringWithFormat:@"%@° /  %@°", dayForecast.dayTemp, dayForecast.nightTemp];
        
        NSString *weather = dayForecast.dayWeather;
        
        if ([weather containsString:@"晴"]) {
            _weatherImageView.image = [UIImage imageNamed:@"sunny"];
        } else if ([weather containsString:@"多云"]) {
            _weatherImageView.image = [UIImage imageNamed:@"cloud"];
        } else if ([weather containsString:@"阴"]) {
            _weatherImageView.image = [UIImage imageNamed:@"yin"];
        } else if ([weather containsString:@"雨"]) {
            _weatherImageView.image = [UIImage imageNamed:@"rain"];
        } else if ([weather containsString:@"霾"]) {
            _weatherImageView.image = [UIImage imageNamed:@"mai"];
        } else if ([weather containsString:@"雪"]) {
            _weatherImageView.image = [UIImage imageNamed:@"snow"];
        }

    }
}

@end
