//
//  WeatherViewController.m
//  NeverStop
//
//  Created by DYQ on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "WeatherViewController.h"
#import "TodayWeatherView.h"
#import "FutureWeatherView.h"


@interface WeatherViewController ()
<
AMapSearchDelegate
>

@property (nonatomic, strong) AMapSearchAPI *mapSearchAPI;



@end

@implementation WeatherViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self createWeatherView];
    
}

- (void)createWeatherView {
    // 背景图
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = [UIImage imageNamed:@"bg_rain_night.jpg"];
    [self.view addSubview:backgroundImageView];
    
    TodayWeatherView *todayView = [[TodayWeatherView alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT / 3 - 30, SCREEN_WIDTH, SCREEN_HEIGHT / 4)];
    todayView.live = _live;
    [self.view addSubview:todayView];
    
    NSString *hour = [NSDate getSystemTimeStringWithFormat:@"HH"];
    if ([hour integerValue] >= 18) {
        for (int i = 0; i < 3; i++) {
            FutureWeatherView *futureView = [[FutureWeatherView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH / 3, todayView.y + todayView.height + 100, SCREEN_WIDTH / 3, 100)];
            futureView.dayForecast = _forecast.casts[i + 1];
            [self.view addSubview:futureView];
        }

    } else {
        for (int i = 0; i < 4; i++) {
            FutureWeatherView *futureView = [[FutureWeatherView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH / 4, todayView.y + todayView.height + 100, SCREEN_WIDTH / 4, 100)];
            futureView.dayForecast = _forecast.casts[i];
            if (i == 0) {
                futureView.dateLabel.text = @"今天";
            }
            [self.view addSubview:futureView];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
