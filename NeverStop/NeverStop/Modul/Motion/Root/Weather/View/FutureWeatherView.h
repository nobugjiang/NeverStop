//
//  FutureWeatherView.h
//  NeverStop
//
//  Created by DYQ on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FutureWeatherView : UIView

@property (nonatomic, strong) AMapLocalDayWeatherForecast *dayForecast;
@property (nonatomic, strong) UILabel *dateLabel;

@end
