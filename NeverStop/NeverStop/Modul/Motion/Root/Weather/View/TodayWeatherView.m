//
//  TodayWeatherView.m
//  NeverStop
//
//  Created by DYQ on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "TodayWeatherView.h"

@interface TodayWeatherView ()

@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) UILabel *weatherLabel;
@property (nonatomic, strong) UILabel *humidityLabel;
@property (nonatomic, strong) UILabel *windLabel;
@property (nonatomic, strong) UIImageView *weatherImageView;


@end

@implementation TodayWeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
       
    self = [super initWithFrame:frame];
    if (self) {
                
        self.tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 65, 50)];
        _tempLabel.textColor = [UIColor whiteColor];
        _tempLabel.textAlignment = NSTextAlignmentLeft;
        _tempLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:40];
        [self addSubview:_tempLabel];
        
        UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_tempLabel.x + _tempLabel.width + 10, _tempLabel.y, 20, 20)];
        cImageView.image = [UIImage imageNamed:@"C.png"];
        [self addSubview:cImageView];
        
        self.weatherLabel = [[UILabel alloc]initWithFrame:CGRectMake(_tempLabel.x, _tempLabel.y + _tempLabel.height + 10, 100, 50)];
        
        _weatherLabel.textAlignment = NSTextAlignmentLeft;
        _weatherLabel.textColor = [UIColor whiteColor];
        _weatherLabel.font = kFONT_SIZE_18_BOLD;
        [self addSubview:_weatherLabel];
        
        
        self.weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cImageView.x + cImageView.width + 25, cImageView.y + 10, 40, 40)];
        [self addSubview:_weatherImageView];
        
        UILabel *nowLabel = [[UILabel alloc] initWithFrame:CGRectMake(_weatherImageView.x, _weatherImageView.y + _weatherImageView.height, _weatherImageView.width, 30)];
        nowLabel.text = @"现在";
        nowLabel.textColor = [UIColor whiteColor];
        nowLabel.textAlignment = NSTextAlignmentCenter;
        nowLabel.font = kFONT_SIZE_13;
        [self addSubview:nowLabel];
        
        
        UIImageView *humidityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_tempLabel.x, _weatherLabel.y + _weatherLabel.height + 10, 30, 30)];
        humidityImageView.image = [UIImage imageNamed:@"humidity.png"];
        [self addSubview:humidityImageView];
        
        self.humidityLabel = [[UILabel alloc] initWithFrame:CGRectMake(humidityImageView.x + humidityImageView.width + 7, humidityImageView.y, 40, 30)];
        _humidityLabel.textColor = [UIColor whiteColor];
        _humidityLabel.textAlignment = NSTextAlignmentCenter;
        _humidityLabel.font = kFONT_SIZE_15_BOLD;
        [self addSubview:_humidityLabel];
        
        
        UIImageView *windIMageView = [[UIImageView alloc] initWithFrame:CGRectMake(_weatherImageView.x, _humidityLabel.y + 3, 25, 25)];
        windIMageView.image = [UIImage imageNamed:@"wind.png"];
        [self addSubview:windIMageView];
        
        self.windLabel = [[UILabel alloc] initWithFrame:CGRectMake(windIMageView.x + windIMageView.width + 7, windIMageView.y, 100, 30)];
        _windLabel.textColor = [UIColor whiteColor];
        _windLabel.textAlignment = NSTextAlignmentCenter;
        _windLabel.font = kFONT_SIZE_15_BOLD;
        [self addSubview:_windLabel];
        
    }
    return self;
}

- (void)setLive:(AMapLocalWeatherLive *)live {
    if (_live != live) {
        _live = live;
        _tempLabel.text = live.temperature;
        _weatherLabel.text = live.weather;
        _weatherLabel.numberOfLines = 0;
        [_weatherLabel sizeToFit];
        if ([_weatherLabel.text containsString:@"晴"]) {
            _weatherImageView.image = [UIImage imageNamed:@"sunny"];
        } else if ([_weatherLabel.text containsString:@"多云"]) {
            _weatherImageView.image = [UIImage imageNamed:@"cloud"];
        } else if ([_weatherLabel.text containsString:@"阴"]) {
            _weatherImageView.image = [UIImage imageNamed:@"yin"];
        } else if ([_weatherLabel.text containsString:@"雨"]) {
            _weatherImageView.image = [UIImage imageNamed:@"rain"];
        } else if ([_weatherLabel.text containsString:@"霾"]) {
            _weatherImageView.image = [UIImage imageNamed:@"mai"];
        } else if ([_weatherLabel.text containsString:@"雪"]) {
            _weatherImageView.image = [UIImage imageNamed:@"snow"];
        }
        _humidityLabel.text = [NSString stringWithFormat:@"%@%%", live.humidity];
        _windLabel.text = [NSString stringWithFormat:@"%@风 %@级", live.windDirection, live.windPower];

       
    }
}

@end
