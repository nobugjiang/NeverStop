//
//  MapViewController.m
//  NeverStop
//
//  Created by Jiang on 16/10/26.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MapViewController.h"
#import "CustomAnimateTransitionPop.h"
//#import "MapDataManager.h"
#import "Location.h"
#import "ExerciseDataView.h"
#import "VerticalButton.h"
#import "ExerciseData.h"
#import "StatusArrayModel.h"
#import "GradientPolylineOverlay.h"
#import "GradientPolylineRenderer.h"
@interface MapViewController ()
<
UINavigationControllerDelegate,
MKMapViewDelegate
>
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) MKMapView *mapView;
//@property (nonatomic, strong) MapDataManager *mapManager;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Location *userLocation;
@property (nonatomic, strong) MKPolyline *commonPolyline;
@property (nonatomic, strong) ExerciseDataView *leftDataView;
@property (nonatomic, strong) ExerciseDataView *rightDataView;
@property (nonatomic, strong) NSArray *keyPathArray;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIVisualEffectView *menuEffectView;
@property (nonatomic, strong) ExerciseData *exerciseData;
@property (nonatomic, strong) Location *lastLocation;
@property (nonatomic, strong) NSMutableArray *statusArray;

@property (nonatomic, strong) NSMutableArray *overlayArray;
@property (nonatomic, strong) GradientPolylineOverlay *polyline;

@end

@implementation MapViewController
- (void)dealloc {
    self.navigationController.delegate = nil;
    for (int i = 0; i < _keyPathArray.count; i++) {
        [self.exerciseData removeObserver:self forKeyPath:_keyPathArray[i] context:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated {

       self.navigationController.delegate = self;
}
- (void)loadView {
    [super loadView];
    self.exerciseData = [ExerciseData shareData];
   

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.location = [[Location alloc] init];
    self.overlayArray = [NSMutableArray array];
    [self createMapView];
    self.keyPathArray = @[@"distance", @"duration", @"speedPerHour", @"averageSpeed", @"maxSpeed", @"calorie", @"count"];
    for (int i = 0; i < _keyPathArray.count; i++) {
        [self.exerciseData addObserver:self forKeyPath:_keyPathArray[i] options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
    }

    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame =  CGRectMake(SCREEN_WIDTH - 50, 32, 30, 30);
    _backButton.layer.cornerRadius = 15;
    _backButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"map_btn_close"] forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [_backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];
    [self.view addSubview:_backButton];
    
   
    
    
    
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 100);
    // 把要添加的视图加到毛玻璃上
    [self.view addSubview:effectView];
    self.leftDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(0, effectView.height - 80, effectView.width / 2, 60)];
    _leftDataView.titleLabel.font = kFONT_SIZE_18_BOLD;
    _leftDataView.titleLabel.text = @"距离 (公里)";
    _leftDataView.dataLabel.textColor = [UIColor blackColor];
    _leftDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
    _leftDataView.dataLabel.text = [NSString stringWithFormat:@"%.2f", _exerciseData.distance];
    [effectView addSubview:_leftDataView];
    
    
    self.rightDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(_leftDataView.x + _leftDataView.width, effectView.height - 80, effectView.width / 2, _leftDataView.height)];
    _rightDataView.titleLabel.font = kFONT_SIZE_18_BOLD;
    _rightDataView.titleLabel.text = @"时速 (公里时)";
    _rightDataView.dataLabel.textColor = [UIColor blackColor];
    _rightDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
    _rightDataView.dataLabel.text = [NSString stringWithFormat:@"%.2f", _exerciseData.averageSpeed];
    [effectView addSubview:_rightDataView];
//
//    
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuButton.frame = CGRectMake(20, effectView.y - 50, 30, 30);
    _menuButton.layer.cornerRadius = 15;
    [_menuButton setBackgroundImage:[UIImage imageNamed:@"map_btn_menu_normal"] forState:UIControlStateNormal];
    [_menuButton setBackgroundImage:[UIImage imageNamed:@"map_btn_menu_select"] forState:UIControlStateSelected];
    _menuButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    [_menuButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        weakSelf.menuButton.selected = !weakSelf.menuButton.selected;
        if (weakSelf.menuButton.selected) {
            [weakSelf mapType];
        } else {
            [weakSelf.menuEffectView removeFromSuperview];
        }
    }];
    [self.view addSubview:_menuButton];

    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(SCREEN_WIDTH - 50, effectView.y - 50, 30, 30);
    _locationButton.layer.cornerRadius = 15;
    [_locationButton setBackgroundImage:[UIImage imageNamed:@"map_btn_location"] forState:UIControlStateNormal];
    _locationButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    [_locationButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        Location *currentLocation = [weakSelf.exerciseData.allLocationArray lastObject];
        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude);
        [weakSelf.mapView setCenterCoordinate:centerCoordinate animated:YES];
        [weakSelf.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
        
    }];
    [self.view addSubview:_locationButton];
    
    

    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_menuEffectView removeFromSuperview];
    if (_menuButton.selected == YES) {
        _menuButton.selected = NO;
    }
//    [_menuEffectView removeFromSuperview];
}
#pragma mark - 改变地图类型
- (void)mapType {
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.menuEffectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    _menuEffectView.frame = CGRectMake(_menuButton.x, _menuButton.y - 140, 220, 120);
    _menuEffectView.layer.cornerRadius = 6;
    _menuEffectView.clipsToBounds = YES;
    [self.view addSubview:_menuEffectView];
    
    VerticalButton *planeButton = [VerticalButton buttonWithType:UIButtonTypeCustom];
    
    [planeButton setImage:[UIImage imageNamed:@"map_type_plane"] forState:UIControlStateNormal];
//
    [planeButton setImage:[UIImage imageNamed:@"map_type_plane"] forState:UIControlStateSelected];
    [planeButton setTitle:@"平面地图" forState:UIControlStateNormal];
    [planeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [planeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    planeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    planeButton.backgroundColor = [UIColor whiteColor];
    planeButton.layer.borderWidth = 0.5;
    planeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [planeButton setTitle:@"平面地图" forState:UIControlStateSelected];
    if (self.mapView.mapType == MKMapTypeStandard) {
        planeButton.selected = YES;
        planeButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74 / 255.f alpha:1.0];
        planeButton.layer.borderColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74 / 255.f alpha:1.0].CGColor;
    }
    planeButton.layer.cornerRadius = 6;
    planeButton.clipsToBounds = YES;
    planeButton.frame = CGRectMake(15, 15, 90, 90);
    [_menuEffectView addSubview:planeButton];
  
    VerticalButton *satelliteButton = [VerticalButton buttonWithType:UIButtonTypeCustom];
    
    [satelliteButton setImage:[UIImage imageNamed:@"map_type_satellite"] forState:UIControlStateNormal];
    //
    [satelliteButton setImage:[UIImage imageNamed:@"map_type_satellite"] forState:UIControlStateSelected];
    [satelliteButton setTitle:@"卫星地图" forState:UIControlStateNormal];
    [satelliteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [satelliteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    satelliteButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    satelliteButton.backgroundColor = [UIColor whiteColor];
    satelliteButton.layer.borderWidth = 0.5;
    satelliteButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [satelliteButton setTitle:@"卫星地图" forState:UIControlStateSelected];
    if (self.mapView.mapType == MKMapTypeSatellite) {
        satelliteButton.selected = YES;
        satelliteButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74 / 255.f alpha:1.0];
        satelliteButton.layer.borderColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74 / 255.f alpha:1.0].CGColor;
    }
    satelliteButton.layer.cornerRadius = 6;
    satelliteButton.clipsToBounds = YES;
    satelliteButton.frame = CGRectMake(planeButton.x + planeButton.width + 10, 15, 90, 90);
    [_menuEffectView addSubview:satelliteButton];
    
    __weak typeof(self) weakSelf = self;
    [planeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (!planeButton.selected) {
            planeButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74 / 255.f alpha:1.0];
            planeButton.layer.borderColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74 / 255.f alpha:1.0].CGColor;
          
            planeButton.selected = !planeButton.selected;
            if (satelliteButton.selected) {
                satelliteButton.selected = !satelliteButton.selected;
                satelliteButton.backgroundColor = [UIColor whiteColor];
                
                //                _femaleButton.imageView.backgroundColor = [UIColor whiteColor];
            }
        }

        weakSelf.mapView.mapType = MKMapTypeStandard;
        
    }];
    [satelliteButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{

        if (!satelliteButton.selected) {
            satelliteButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74 / 255.f alpha:1.0];
            satelliteButton.layer.borderColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74 / 255.f alpha:1.0].CGColor;
          
            satelliteButton.selected = !satelliteButton.selected;
            if (planeButton.selected) {
                planeButton.selected = !planeButton.selected;
                planeButton.backgroundColor = [UIColor whiteColor];
                
                //                _femaleButton.imageView.backgroundColor = [UIColor whiteColor];
            }
        }

        weakSelf.mapView.mapType = MKMapTypeSatellite;

        
    }];
    
    
    
    
}
#pragma mark - 创建地图
- (void)createMapView {
    

    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.userLocation = [self.exerciseData.allLocationArray lastObject];
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    
    // 默认模式
//    _mapView.showsLabels = NO;
    [_mapView setUserTrackingMode: MKUserTrackingModeFollow animated:YES];
    // 比例尺
    _mapView.showsScale = NO;
    // 罗盘
    _mapView.showsCompass = NO;
    // 天空模式
    // 相机旋转
    _mapView.rotateEnabled = NO;
    // 楼块
//    _mapView.showsBuildings = NO;
    
    // 交互
//    _mapView.userInteractionEnabled = NO;
 
    // 中心位置
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(_userLocation.latitude, _userLocation.longitude);
    [_mapView setCenterCoordinate:centerCoordinate animated:NO];
    [self drawlocus];
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    Location *location = [_exerciseData.allLocationArray firstObject];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    
    
//    MAMapStatus *mapStatus = [MAMapStatus statusWithCenterCoordinate:centerCoordinate zoomLevel:18 rotationDegree:0 cameraDegree:0 screenAnchor:CGPointMake(0.5, 0.5)];
//    [_mapView setMapStatus:mapStatus animated:YES duration:0.5];

    [_mapView addAnnotation:pointAnnotation];
}
#pragma mark - 绘画运动轨迹
- (void)drawlocus {
    // 开始暂停状态及位置数组模型
    StatusArrayModel *statusArrayModel = [[StatusArrayModel alloc] init];
    // 记录上一次定位
    self.lastLocation = [[Location alloc] init];
    // 存 StatusArrayModel 开始暂停状态及位置数组模型
    self.statusArray = [NSMutableArray array];
    // 遍历
    for (Location *location in _exerciseData.allLocationArray) {
        // 两次定位的运动状态不同时执行条件语句
        if (location.isStart != _lastLocation.isStart) {
            // 拷贝内容
            StatusArrayModel *statusModelArr = [statusArrayModel copy];
            if (location.isStart) {
                statusArrayModel.isStart = YES;
            } else {
                statusArrayModel.isStart = NO;
            }
            // 当分段数组个数大于0的时候把最后一个元素替换为 深拷贝
            if (_statusArray.count > 0) {
                [_statusArray replaceObjectAtIndex:_statusArray.count - 1 withObject:statusModelArr];
            }
            
            [_statusArray addObject:statusArrayModel];
            // 移除本次状态所有位置信息
            [statusArrayModel.array removeAllObjects];
        }
        // 记录
        _lastLocation = location;
        // 状态模型数组添加本次位置
        [statusArrayModel.array addObject:location];
    }
    
    NSLog(@"%@", _statusArray);
    
    if (_mapView.overlays) {
        [_mapView removeOverlays:_overlayArray];
    }
    if (_overlayArray.count > 0) {
        [_overlayArray removeAllObjects];
    }
    for (StatusArrayModel *temp in _statusArray) {
        double count = temp.array.count;
        CLLocationCoordinate2D *points;
        float *velocity;
        points = malloc(sizeof(CLLocationCoordinate2D)*count);
        velocity = malloc(sizeof(float)*count);
        
        for(int i=0;i<count;i++){
            self.location  = temp.array[i];

            CLLocationDegrees latitude  = self.location.latitude;
            CLLocationDegrees longitude = self.location.longitude;
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            velocity[i] = self.location.currentSpeed;
            points[i] = coordinate;
        }
        
        self.polyline = [[GradientPolylineOverlay alloc] initWithPoints:points velocity:velocity count:count];
        [self.mapView addOverlay:self.polyline];
        
        
        
        
        
        
//        
//        CLLocationCoordinate2D commonPolylineCoords[temp.array.count];
//        
//        for (int i = 0; i < temp.array.count; i++) {
//            self.location  = temp.array[i];
//            commonPolylineCoords[i].latitude = self.location.latitude;
//            commonPolylineCoords[i].longitude = self.location.longitude;
//            
//        }
//        //构造折线对象
//        
//        MKPolyline *commonPolyline = [MKPolyline polylineWithCoordinates:commonPolylineCoords count:temp.array.count];
//        if (temp.isStart == YES) {
//            commonPolyline.title = @"1";
//        } else {
//            commonPolyline.title = @"2";
//        }
//        [_overlayArray addObject:commonPolyline];
//        
//        //在地图上添加折线对象
//        [_mapView addOverlay: commonPolyline];
    }

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
     if ([keyPath isEqualToString:@"count"] && object == _exerciseData) {
         [self drawlocus];

     }  if ([keyPath isEqualToString:@"duration"] && object == _exerciseData) {
         
         NSString *time = [change valueForKey:@"new"];
         
         NSInteger sec;
         NSInteger minu;
         NSInteger hour;
         sec = [time integerValue] % 60;
         minu = ([time integerValue] / 60)% 60;
         hour = [time integerValue] / 3600;
         
      
         
//         self.rightDataView.dataLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", hour, minu, sec];
         
     } else if ([keyPath isEqualToString:@"distance"] && object == _exerciseData) {
         self.leftDataView.dataLabel.text = [NSString stringWithFormat:@"%.2f", _exerciseData.distance];
     } else if ([keyPath isEqualToString:@"speedPerHour"] && object == _exerciseData) {
         self.rightDataView.dataLabel.text = [NSString stringWithFormat:@"%.2f", _exerciseData.speedPerHour];

     } else if ([keyPath isEqualToString:@"averageSpeed"] && object == _exerciseData) {
         
     } else if ([keyPath isEqualToString:@"maxSpeed"] && object == _exerciseData) {
         
     } else if ([keyPath isEqualToString:@"calorie"] && object == _exerciseData) {
         
     }

}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if([overlay isKindOfClass:[GradientPolylineOverlay class]]){
        //轨迹
        GradientPolylineRenderer *polylineRenderer = [[GradientPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.lineWidth = 8.f;
        return polylineRenderer;
    }
//    if ([overlay isKindOfClass:[MKPolyline class]])
//    {
//        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
//        
//      
//
//        if ([overlay.title isEqualToString:@"1"]) {
//       
//            polylineRenderer.lineWidth = 7.5f;
//            // 连接类型
//            polylineRenderer.lineJoin = kCGLineJoinRound;
//            // 端点类型
//            polylineRenderer.lineCap = kCGLineCapButt;
//            polylineRenderer.strokeColor = [UIColor colorWithRed:0.185 green:1.0 blue:0.6866 alpha:1.0];
//            
//        } else if ([overlay.title isEqualToString:@"2"]) {
//            
//            polylineRenderer.lineWidth = 7.5f;
//            // 连接类型
//            polylineRenderer.lineJoin = kCGLineJoinRound;
//            // 端点类型
//            polylineRenderer.lineCap = kCGLineCapButt;
//            polylineRenderer.lineDashPhase = 1.0;
//            NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:2] , [NSNumber numberWithInt:6], nil];
//            polylineRenderer.lineDashPattern = array;
//            polylineRenderer.strokeColor  = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
//        }

//        return polylineRenderer;
//    }
    return nil;
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.annotation = annotation;
        
        annotationView.canShowCallout = NO;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = NO;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
//        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        annotationView.image = [UIImage imageNamed:@"map_startPoint"];
        annotationView.centerOffset = CGPointMake(0, -16);
        return annotationView;
    }
    return nil;
}



//用来自定义转场动画
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    if(operation == UINavigationControllerOperationPop)
    {
        CustomAnimateTransitionPop *pingInvert = [CustomAnimateTransitionPop new];
        pingInvert.contentMode = JiangContentModeBackToExercise;
        pingInvert.button = self.backButton;
        return pingInvert;
    } else {
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
