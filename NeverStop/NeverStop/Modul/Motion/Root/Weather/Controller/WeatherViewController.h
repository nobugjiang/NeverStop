//
//  WeatherViewController.h
//  NeverStop
//
//  Created by DYQ on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController

@property (nonatomic, strong) AMapLocalWeatherLive *live;
@property (nonatomic, strong) AMapLocalWeatherForecast *forecast;

@end
