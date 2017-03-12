//
//  ExerciseViewController.m
//  NeverStop
//
//  Created by Jiang on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ExerciseViewController.h"
#import "ExerciseDataView.h"
#import "GlideView.h"
#import "CustomAnimateTransitionPush.h"
#import "MapViewController.h"
#import "CustomAnimateTransitionPop.h"
#import "Location.h"
#import "MapDataManager.h"
#import "ProgressAimView.h"
#import "ExerciseData.h"

@interface ExerciseViewController ()
<
UINavigationControllerDelegate,
MKMapViewDelegate,
ProgressAimViewDelegate
>
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIView *countDownView;
@property (nonatomic, strong) UILabel *countDownLabel;
@property (nonatomic, strong) UIView *dataModulesView;
@property (nonatomic, strong) ExerciseDataView *homeDataView;
@property (nonatomic, strong) ExerciseDataView *leftDataView;
@property (nonatomic, strong) ExerciseDataView *rightDataView;
@property (nonatomic, strong) UIButton *lockButton;
@property (nonatomic, strong) UIView *lockView;
@property (nonatomic, strong) GlideView *glideView;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint glideCenter;
@property (nonatomic, assign) CGFloat dy;
@property (nonatomic, assign) BOOL isOffMark;
@property (nonatomic, assign) BOOL isLock;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, strong) Location *location;

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) Location *lastLocation;
@property (nonatomic, assign) double allDistance;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) NSString *allDistanceStr;
@property (nonatomic, strong) MKPolyline *commonPolyline;

@property (nonatomic, strong) MapDataManager *mapManager;
@property (nonatomic, strong) ExerciseData *exerciseData;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger a;
@property (nonatomic, assign) NSInteger lastTime;
@property (nonatomic, strong) NSArray *keyPathArray;
@property (nonatomic, strong) ProgressAimView *progressAimView;
@property (nonatomic, assign) NSInteger secondPauseLocation;
@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, strong) UserModel *user;

@end

@implementation ExerciseViewController
- (void)dealloc {
    self.navigationController.delegate = nil;
    _progressAimView.delegate = nil;
    _mapView.delegate = nil;
    for (int i = 0; i < _keyPathArray.count; i++) {
        [self.exerciseData removeObserver:self forKeyPath:_keyPathArray[i] context:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.delegate = self;
    [self mapBtnAnimation];
    
    [_mapView setUserTrackingMode: MKUserTrackingModeFollow animated:YES];
    
    

}
- (void)initialValue {
    self.isMoving = YES;
    self.a = 0;
    self.lastTime = 0;
    self.keyPathArray = @[@"distance", @"duration", @"speedPerHour", @"averageSpeed", @"maxSpeed", @"calorie", @"count"];
    self.lastLocation = [[Location alloc] init];
    self.exerciseData = [ExerciseData shareData];
    self.secondPauseLocation = 1;
    _exerciseData.distance = 0.00;
    _exerciseData.duration = 0;
    _exerciseData.speedPerHour = 0.00;
    _exerciseData.averageSpeed = 0.00;
    _exerciseData.maxSpeed = 0.00;
    _exerciseData.calorie = 0.0;
    _exerciseData.exerciseType = self.exerciseType;
    _exerciseData.isComplete = NO;
    self.isChange = NO;
    UserManager *userManager = [UserManager shareUserManager];
    [userManager openSQLite];
    self.user = [userManager selectUser];
    NSLog(@"%@", self.user);
    _exerciseData.startTime = [NSDate getSystemTimeStringWithFormat:@"YYYY年MM月dd日 hh:mm"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialValue];
      for (int i = 0; i < _keyPathArray.count; i++) {
        [self.exerciseData addObserver:self forKeyPath:_keyPathArray[i] options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
    }
    
    self.navigationItem.title = @"运动";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"background.jpg"];
    [self.view addSubview:backImageView];
    
    [self createCountDownView];

}



#pragma mark - 创建计时器 开始计时
- (void)createTimer {
    if (_a == 0) {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timeFire) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    _a++;
}
#pragma mark - 暂停计时
- (void)pauseTimer {

        self.a = 0;
        [self.timer setFireDate:[NSDate distantFuture]];
}

-(void)timeFire {

    self.exerciseData.duration += 0.1;
}
#pragma mark - 结束计时
- (void)endTimer{
    

    self.a = 0;
    [self.timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
}



#pragma mark - 创建地图
- (void)creatMapView {
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(-1, -1, 1, 1)];
    [self.view addSubview:_mapView];
    // 开启定位
    _mapView.showsUserLocation = YES;
    
    _mapView.delegate = self;
    

    
    // 设置默认模式
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
   
    
   
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
        //        NSLog(@"lat: %f, long: %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        // 取出当前位置的坐标
        
        Location *location = [[Location alloc] init];
        location.latitude = userLocation.coordinate.latitude;
        location.longitude = userLocation.coordinate.longitude;
    location.currentSpeed = 0;
        if (self.isMoving == YES) {
            location.isStart = YES;
            if (_isChange == YES) {
                Location *lastLoc = [location copy];
                lastLoc.isStart = NO;
                [_exerciseData.allLocationArray replaceObjectAtIndex:_exerciseData.allLocationArray.count - 1 withObject:lastLoc];
                _exerciseData.count = _exerciseData.allLocationArray.count;
            }
            _isChange = NO;
            [_exerciseData.allLocationArray addObject:location];
            _exerciseData.count = _exerciseData.allLocationArray.count;
        } else {
            Location *lastLoc = [_lastLocation copy];
            lastLoc.isStart = NO;
            location.isStart = NO;
            if (_secondPauseLocation <= 2) {
                if (_secondPauseLocation == 1) {
                    [_exerciseData.allLocationArray addObject:lastLoc];
                    _exerciseData.count = _exerciseData.allLocationArray.count;
                    
                } else {
                    [_exerciseData.allLocationArray addObject:location];
                    _exerciseData.count = _exerciseData.allLocationArray.count;
                }
            } else {
                if (_exerciseData.allLocationArray.count > 0) {
                    
                [_exerciseData.allLocationArray replaceObjectAtIndex:_exerciseData.allLocationArray.count - 1 withObject:location];
                _exerciseData.count = _exerciseData.allLocationArray.count;
                }
            }
            _secondPauseLocation++;
            _isChange = YES;
        }
        // 添加到坐标数组中
       
//        [_locationArray addObject:location];
        if (self.isMoving == YES) {

            if (_exerciseData.allLocationArray.count > 1) {
                // 1.将两个经纬度点转成投影点
                if (_lastLocation.isStart != NO) {
                    
                    MKMapPoint point1 = MKMapPointForCoordinate(CLLocationCoordinate2DMake(_lastLocation.latitude,_lastLocation.longitude));
                    MKMapPoint point2 = MKMapPointForCoordinate(CLLocationCoordinate2DMake(location.latitude,location.longitude));
                    // 2.计算距离
                    // NSLog(@"last : %f, %f", _lastLocation.latitude, _lastLocation.longitude);
                    // NSLog(@"now : %f, %f", location.latitude, location.longitude);
                    CLLocationDistance distance = MKMetersBetweenMapPoints(point1,point2);
                    //                NSLog(@"distance : %f", distance);
                    ;
                    CGFloat time = ((_exerciseData.duration - _lastTime) / 60.0) / 60.0;
                    if (time != 0) {
                        
                        //                NSLog(@"%ld", _mapManager.duration - _lastTime);
                        _exerciseData.speedPerHour = (distance / 1000) / time;
                       Location *location = [_exerciseData.allLocationArray lastObject];
                        location.currentSpeed = _exerciseData.speedPerHour;
                        _exerciseData.distance += distance / 1000;
                        //                _exerciseDataKVO.distance += round(distance / 1000 * 100) / 100;
                        _exerciseData.maxSpeed = _exerciseData.maxSpeed > _exerciseData.speedPerHour ? _exerciseData.maxSpeed : _exerciseData.speedPerHour;
                        _exerciseData.averageSpeed = _exerciseData.distance / _exerciseData.duration * 60 * 60;
                        _exerciseData.speedSetting = 1 / _exerciseData.speedPerHour * 3600;
                        _exerciseData.averageSpeedSetting = 1 / _exerciseData.averageSpeed * 60 * 60;
                        if ([_exerciseData.exerciseType isEqualToString:@"walk"]) {
                           _exerciseData.calorie += [_user.weight floatValue] / 60.0 * 65 * _exerciseData.speedPerHour * time;
                        } else if ([_exerciseData.exerciseType isEqualToString:@"run"]) {
                            _exerciseData.calorie += [_user.weight floatValue] * (distance / 1000.0) * 1.036;
                        } else {
                            _exerciseData.calorie += [_user.weight floatValue] / 60.0 * 27.5 * _exerciseData.speedPerHour * time;
                        }
                }
                }
            }
         
        }
        
        self.lastTime = _exerciseData.duration;
        _lastLocation.isStart = location.isStart;
        _lastLocation.latitude = location.latitude;
        _lastLocation.longitude = location.longitude;
    
    
        
   
//    NSLog(@"%@", _mapManager.allLocationArray);
//    NSLog(@"%lu", (unsigned long)_mapManager.allLocationArray.count);
    
    
    
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"duration"] && object == _exerciseData) {
        
        NSString *time = [change valueForKey:@"new"];
        
        NSInteger sec;
        NSInteger minu;
        NSInteger hour;
        sec = [time integerValue] % 60;
        minu = ([time integerValue] / 60) % 60;
        hour = [time integerValue] / 3600;
        
        self.homeDataView.dataLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", hour, minu, sec];
        
//        NSLog(@"%ld", (long)_exerciseData);
        if (self.aimType == 3) {
        
            if (_exerciseData.duration != 0) {
                
                _progressAimView.currentNumber = _exerciseData.duration;
            }
            
        }
        
    } else if ([keyPath isEqualToString:@"distance"] && object == _exerciseData) {
         self.leftDataView.dataLabel.text = [NSString stringWithFormat:@"%.2f", _exerciseData.distance];
        if (self.aimType == 2) {
            _progressAimView.currentNumber = _exerciseData.distance;
        }
    } else if ([keyPath isEqualToString:@"speedPerHour"] && object == _exerciseData) {
        NSLog(@"%f", _exerciseData.speedPerHour);
        if (self.aimType != 4) {
            self.rightDataView.dataLabel.text = [NSString stringWithFormat:@"%.2f", _exerciseData.speedPerHour];
        }
    } else if ([keyPath isEqualToString:@"averageSpeed"] && object == _exerciseData) {
       
    } else if ([keyPath isEqualToString:@"maxSpeed"] && object == _exerciseData) {
       
    } else if ([keyPath isEqualToString:@"calorie"] && object == _exerciseData) {
        if (self.aimType == 4) {
            _progressAimView.currentNumber = _exerciseData.calorie;
            self.rightDataView.dataLabel.text = [NSString stringWithFormat:@"%.1f", _exerciseData.calorie];

        }
       
    } else if ([keyPath isEqualToString:@"speedSetting"] && object == _exerciseData) {
        
    } else if ([keyPath isEqualToString:@"averageSpeedSetting"] && object == _exerciseData) {
        
    }




   
}







#pragma mark - 右上地图button旋转动画
- (void)mapBtnAnimation{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    rotationAnimation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.mapButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
#pragma mark - 创建倒计时视图
- (void)createCountDownView {
    self.countDownView = [[UIView alloc] initWithFrame:self.view.bounds];
    _countDownView.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    [self.view addSubview:_countDownView];
    self.countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2 - 200, 200, 200)];
    _countDownLabel.backgroundColor = [UIColor clearColor];
    _countDownLabel.layer.cornerRadius = _countDownLabel.width / 2;
    _countDownLabel.clipsToBounds = YES;
    _countDownLabel.textAlignment = NSTextAlignmentCenter;
    _countDownLabel.textColor = [UIColor whiteColor];
    _countDownLabel.font = [UIFont boldSystemFontOfSize:150];
    [_countDownView addSubview:_countDownLabel];
    [self startTime];
    
}
#pragma mark - 运动数据模块
- (void)createExerciseDataModules {
    self.dataModulesView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 5, SCREEN_WIDTH, 210)];
//    _dataModulesView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_dataModulesView];
    
    self.homeDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(0, 0, self.dataModulesView.width, 130)];
    _homeDataView.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _homeDataView.titleLabel.text = @"时长";
    _homeDataView.dataLabel.font = [UIFont systemFontOfSize:80];
    _homeDataView.dataLabel.text = @"00:00:00";
//    _homeDataView.backgroundColor = [UIColor greenColor];
    [self.dataModulesView addSubview:_homeDataView];
    
    
    self.leftDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(0, _dataModulesView.height - 60, SCREEN_WIDTH / 2, 60)];
    _leftDataView.titleLabel.font = kFONT_SIZE_18_BOLD;
    _leftDataView.titleLabel.text = @"距离 (公里)";
    _leftDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
    _leftDataView.dataLabel.text = @"0.00";
    [self.dataModulesView addSubview:_leftDataView];
    
    
    self.rightDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(_dataModulesView.width / 2, _dataModulesView.height - 60, _dataModulesView.width / 2, _leftDataView.height)];
    _rightDataView.titleLabel.font = kFONT_SIZE_18_BOLD;
    if (self.aimType == 4) {
        _rightDataView.titleLabel.text = @"卡路里 (大卡)";
        _rightDataView.dataLabel.text = @"0.0";
    } else {
        _rightDataView.titleLabel.text = @"时速 (公里时)";
        _rightDataView.dataLabel.text = @"0.00";
    }
    _rightDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
    [self.dataModulesView addSubview:_rightDataView];
   
    
}
#pragma mark - 创建锁屏
- (void)createLockButton {
    self.lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _lockButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 16, SCREEN_HEIGHT - 44, 32, 32);
    [_lockButton setBackgroundImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;

    [_lockButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf createLockView];
        weakSelf.isLock = YES;
        [weakSelf.view bringSubviewToFront:weakSelf.progressAimView];
        [weakSelf.view bringSubviewToFront:weakSelf.lockButton];
        [weakSelf.view bringSubviewToFront:weakSelf.dataModulesView];
    }];
    [self.view addSubview:_lockButton];
}
#pragma mark - 创建锁屏视图
- (void)createLockView {
    self.glideView = [[GlideView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 200, 80, 100)];
    self.glideCenter = CGPointMake(_glideView.centerX, _glideView.centerY);

    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
    effe.frame = self.view.bounds;
    // 把要添加的视图加到毛玻璃上
    [self.view sendSubviewToBack:effe];
    [self.view addSubview:effe];
    [UIView animateWithDuration:0.7 animations:^{
        [_lockButton setBackgroundImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
        _lockButton.userInteractionEnabled = NO;
        _dataModulesView.userInteractionEnabled = NO;
        _lockButton.center = CGPointMake(_lockButton.centerX, _glideView.y - 20);
    } completion:^(BOOL finished) {
        
        [effe sendSubviewToBack:_glideView];
        [effe addSubview:_glideView];
        _glideView.userInteractionEnabled = NO;

    }];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     if (self.isLock == YES) {
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self.view];
    self.startPoint = point;
    [self.view bringSubviewToFront:_lockView];
    _isOffMark = NO;
     }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
     if (self.isLock == YES) {
  
    //计算位移 = 当前位置 - 起始位置
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    self.dy = point.y - self.startPoint.y;
    //计算移动后的view中心点
    CGPoint newcenter = CGPointMake(self.glideCenter.x, _glideCenter.y + _dy);
    
    
    
//    float halfx = CGRectGetMidX(_glideView.bounds);
//    //x坐标左边界
//    newcenter.x = MAX(halfx, newcenter.x);
//    //x坐标右边界
//    newcenter.x = MIN(_glideView.superview.bounds.size.width - halfx, newcenter.x);
//
//    float halfy = CGRectGetMidY(_glideView.bounds);
//    newcenter.y = MAX(halfy, newcenter.y);
//    newcenter.y = MIN(_glideView.superview.bounds.size.height - halfy, newcenter.y);

    if (_isOffMark == NO) {
        
        _glideView.center = newcenter;
        _lockButton.center = CGPointMake(_glideView.center.x, _glideView.center.y - 70);

        if (_dy < -30) {
            [UIView animateWithDuration:0.5 animations:^{
                _glideView.center = self.glideCenter;
                _lockButton.center = CGPointMake(_lockButton.centerX, _glideView.y - 20);
                _isOffMark = YES;
            }];
        }
    }
     }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (self.isLock == YES) {

    
     if (self.dy > 80) {
        [UIView animateWithDuration:0.5 animations:^{
            _glideView.center = CGPointMake(_glideCenter.x, SCREEN_HEIGHT + _glideView.height);
            _lockButton.center = CGPointMake(_lockButton.centerX, SCREEN_HEIGHT - 44 + 16);
            _lockButton.userInteractionEnabled = YES;
            _dataModulesView.userInteractionEnabled = YES;
        } completion:^(BOOL finished) {
            [_lockButton setBackgroundImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
            self.isLock = NO;
            [_glideView.superview removeFromSuperview];
            
        }];
     } else {
         [UIView animateWithDuration:0.5 animations:^{
             _glideView.center = _glideCenter;
             _lockButton.center = CGPointMake(_lockButton.centerX, _glideView.y - 20);
     
         }];
     }

    }
}
- (void)createProgressAimView {
    self.progressAimView = [[ProgressAimView alloc] initWithFrame:CGRectMake(15, 64 + 5, SCREEN_WIDTH - 30, 30) aim:self.aim aimType:self.aimType];
     _progressAimView.delegate = self;
    [self.view addSubview:_progressAimView];
    if (self.aimType == 0) {
        _progressAimView.alpha = 0;
    }

}
#pragma mark - 倒计时
- (void)startTime {
    __block int timeout = 3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer1,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer1, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer1);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.countDownView removeFromSuperview];
                
                [self creatMapView];
                [self createProgressAimView];
#pragma mark - 结束按钮
                self.endButton = [UIButton buttonWithType:UIButtonTypeCustom];
                _endButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 240, 80, 80);
                UIImage *endImage = [UIImage imageNamed:@"btn_end"];
                [_endButton setBackgroundImage:endImage forState:UIControlStateNormal];
//                _endButton.backgroundColor = [UIColor whiteColor];
                _endButton.layer.cornerRadius = 40;
                _endButton.clipsToBounds = YES;
                _endButton.alpha = 0;
                [self.view addSubview:_endButton];
                __weak typeof(self) weakSelf = self;
                [_endButton addTarget:self action:@selector(endButtonAction:) forControlEvents:UIControlEventTouchUpInside];
#pragma mark - 开始暂停按钮
                self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
                _pauseButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 240, 80, 80);
                UIImage *pauseImage = [UIImage imageNamed:@"btn_pause"];
                [_pauseButton setBackgroundImage:pauseImage forState:UIControlStateNormal];
                
//                _pauseButton.backgroundColor = [UIColor whiteColor];
                _pauseButton.layer.cornerRadius = 40;
                _pauseButton.clipsToBounds = YES;
                
                [self.view addSubview:_pauseButton];
                
                [_pauseButton addTarget:self action:@selector(pauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
#pragma mark - 地图按钮
    self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mapButton setBackgroundImage:[UIImage imageNamed:@"map1"] forState:UIControlStateNormal];
    _mapButton.frame = CGRectMake(SCREEN_WIDTH - 50, 32, 30, 30);
    [_mapButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        MapViewController *mapVC = [[MapViewController alloc] init];
        [weakSelf.navigationController pushViewController:mapVC animated:YES];
    
    }];
                [self mapBtnAnimation];
                [self.view addSubview:_mapButton];
                [self createExerciseDataModules];
                [self createLockButton];
                [self createTimer];

            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                _countDownLabel.text = strTime;
                
                [UIView animateWithDuration:0.5 animations:^{
//                    _countDownLabel.font = [UIFont boldSystemFontOfSize:180];
                    _countDownLabel.backgroundColor = [UIColor colorWithRed:0.9919 green:0.9832 blue:1.0 alpha:0.02];

                    _countDownLabel.transform = CGAffineTransformMakeScale(1.35, 1.35);
                    _countDownLabel.textColor = [UIColor whiteColor];


                } completion:^(BOOL finished) {
                    _countDownLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
                    [UIView animateWithDuration:0.5 animations:^{
                        _countDownLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                        _countDownLabel.font = [UIFont boldSystemFontOfSize:150];
                        _countDownLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
                        

                    }];
                    
                }];
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationDuration:1];
//                [UIView commitAnimations];
//
            });
            timeout--;
        }
        
    });
    dispatch_resume(_timer1);

}
#pragma mark - 进度条协议
- (void)aimIsCompleted {
    _exerciseData.isComplete = YES;
}
- (void)endButtonAction:(UIButton *)button {
    if (_exerciseData.distance >= 1.0f) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否结束本次运动?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"结束" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self endTimer];
            _exerciseData.aim = self.aim;
            _exerciseData.aimType = self.aimType;
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            NSLog(@"current task");
            dispatch_async(globalQueue, ^{
                self.mapManager = [MapDataManager shareDataManager];
                [_mapManager openDB];
                [_mapManager createTable];
                [_mapManager insertExerciseData:_exerciseData];
                NSArray *array = [_mapManager selectAll];
                NSLog(@"%@", array);
                //    [_mapManager deleteExerciseData];
                [_exerciseData.allLocationArray removeAllObjects];
            });
            [self.navigationController popViewControllerAnimated:YES];
       
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:destructiveAction];
        
        [self presentViewController:alert animated:YES completion:nil];
      
        
        
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"本次运动距离过短, 无法保存。\n是否结束本次运动?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"结束运动" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self endTimer];
            [_exerciseData.allLocationArray removeAllObjects];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           

        }];
        [alert addAction:cancelAction];
        [alert addAction:destructiveAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)pauseButtonAction:(UIButton *)button {
    
    [UIView animateWithDuration:0.5 animations:^{
        if (!self.pauseButton.selected) {
            // 暂停计时
            _endButton.alpha = 1;

            [self pauseTimer];
            self.pauseButton.centerX = SCREEN_WIDTH / 2 - 70;
            self.endButton.centerX = SCREEN_WIDTH / 2 + 70;
            self.pauseButton.selected = !self.pauseButton.selected;
            [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"btn_start"] forState:UIControlStateNormal];
            
            self.isMoving = NO;
        } else {
            // 开始计时
            _endButton.alpha = 0;

            [self createTimer];
            _secondPauseLocation = 1;
            self.pauseButton.centerX = SCREEN_WIDTH / 2;
            self.endButton.centerX = SCREEN_WIDTH / 2;
            self.pauseButton.selected = !self.pauseButton.selected;
            [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
            self.isMoving = YES;
        }
    }];

}
#pragma mark - 用来自定义转场动画
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    if(operation==UINavigationControllerOperationPush)
    {
        CustomAnimateTransitionPush *animateTransitionPush=[CustomAnimateTransitionPush new];
        animateTransitionPush.contentMode = JiangContentModeToMap;
        animateTransitionPush.button = self.mapButton;
        return animateTransitionPush;
    }
    else
    {
//        CustomAnimateTransitionPop *pingInvert = [CustomAnimateTransitionPop new];
//        pingInvert.contentMode = JiangContentModeBackToStart;
//        pingInvert.button = self.endButton;
//        return pingInvert;
        return nil;
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
