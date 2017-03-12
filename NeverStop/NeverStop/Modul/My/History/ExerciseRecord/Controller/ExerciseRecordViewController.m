//
//  ExerciseRecordViewController.m
//  NeverStop
//
//  Created by Jiang on 16/11/5.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ExerciseRecordViewController.h"
#import "JiangSegmentScrollView.h"
#import "Location.h"
#import "StatusArrayModel.h"
#import "VerticalButton.h"
#import "ExerciseDataView.h"
//#import "MAMutablePolylineRenderer.h"
//#import "MAMutablePolyline.h"
#import "RecordTableViewCell.h"
@interface ExerciseRecordViewController ()
<
MKMapViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIView *detailsRecordView;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Location *userLocation;
@property (nonatomic, strong) MKPolyline *commonPolyline;
@property (nonatomic, strong) Location *lastLocation;
@property (nonatomic, strong) NSMutableArray *statusArray;

@property (nonatomic, strong) NSMutableArray *overlayArray;

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) JiangSegmentScrollView *scView;
@property (nonatomic, strong) UIVisualEffectView *menuEffectView;

@property (nonatomic, strong) MKPointAnnotation *myLocation;

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) double averageSpeed;
@property (nonatomic, assign) NSInteger currentLocationIndex;
//@property (nonatomic, strong) MAMutablePolyline *mutablePolyline;
@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D maxCoordinate;
@property (nonatomic, assign) CLLocationCoordinate2D minCoordiante;

//@property (nonatomic, strong) MAMutablePolylineRenderer *mutableView;




@property (nonatomic, strong) UITableView *tableView;




@end

@implementation ExerciseRecordViewController
- (void)loadView {
    [super loadView];
    [self dealWithMaxMinData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    UIBarButtonItem *backItem = [UIBarButtonItem getBarButtonItemWithImageName:@"navigator_btn_back" HighLightedImageName:nil targetBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(0, 0, 21, 21);
    [playButton setBackgroundImage:[UIImage imageNamed:@"nav_guiji"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(actionPlayAndStop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *playItem = [[UIBarButtonItem alloc] initWithCustomView:playButton];
    UIBarButtonItem *cameraItem = [UIBarButtonItem getBarButtonItemWithImageName:@"nav_camera" HighLightedImageName:nil targetBlock:^{
        __block UIImage *screenshotImage = nil;
        
        // 截图附加选项
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        // 设置截图区域(在地图上的区域,作用在地图)
        options.region = self.mapView.region;
        //    options.mapRect = self.mapView.visibleMapRect;
        
        // 设置截图后的图片大小(作用在输出图像)
        options.size = self.mapView.frame.size;
        // 设置截图后的图片比例（默认是屏幕比例， 作用在输出图像）
        options.scale = [[UIScreen mainScreen] scale];
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        [snapshotter startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
            if (error) {
                NSLog(@"截图错误：%@",error.localizedDescription);
            }else
            {
                // 设置屏幕上图片显示
                screenshotImage = snapshot.image;
                // 将图片保存到指定路径（此处是桌面路径，需要根据个人电脑不同进行修改）
//                NSData *data = UIImagePNGRepresentation(snapshot.image);
//                [data writeToFile:@"/Users/wangshunzi/Desktop/snap.png" atomically:YES];
            }
        }];
        
        
        UIImageView *iamgeView = [[UIImageView alloc] initWithImage:screenshotImage];

        UIImageWriteToSavedPhotosAlbum(iamgeView.image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    self.navigationItem.rightBarButtonItems = @[playItem, cameraItem];

    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.title = @"运动记录";
    [self createMapView];
    [self createTableView];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            [array addObject:_mapView];
        }if (i == 1) {
            [array addObject:_tableView];
        }
    }
   self.scView = [[JiangSegmentScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height - 64) titleArray:@[@"轨迹", @"详情"] contentViewArray:array];
    [self.view addSubview:_scView];
    [self createBtn];
    [self createEffectView];
    // Do any additional setup after loading the view.
    
    [self drawlocus];
    [self initVariates];

}

#pragma mark - 保存图片
 - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在保存";
        hud.offset = CGPointMake(0, SCREEN_HEIGHT / 2 - 60);
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            [self doSomething];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud1.mode = MBProgressHUDModeCustomView;
                UIImage *image = [UIImage imageNamed:@"error"];
                
                hud1.customView = [[UIImageView alloc] initWithImage:image];
                hud1.offset = CGPointMake(0, SCREEN_HEIGHT / 2 - 60);
                
                hud1.label.text = @"保存失败";
                [hud1 hideAnimated:YES afterDelay:1.0f];
                
            });
        });

    } else {
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在保存";
        hud.offset = CGPointMake(0, -60);

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            [self doSomething];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud1.mode = MBProgressHUDModeCustomView;
                UIImage *image = [UIImage imageNamed:@"Checkmark"];
                
                hud1.customView = [[UIImageView alloc] initWithImage:image];
                hud1.offset = CGPointMake(0, -60);

                hud1.label.text = @"保存成功";
                [hud1 hideAnimated:YES afterDelay:1.0f];

            });
        });

        
        
           }
}
- (void)doSomething {
    sleep(1);
}

- (CLLocationCoordinate2D *)initdata {
    CLLocationCoordinate2D commonPolylineCoords[_exerciseData.allLocationArray.count];
    int i = 0;
    for (Location *location in _exerciseData.allLocationArray) {
        
        commonPolylineCoords[i].latitude = location.latitude;
        commonPolylineCoords[i].longitude = location.longitude;
        i++;
    }
    CLLocationCoordinate2D *coordinates = commonPolylineCoords;
    return coordinates;
}
#pragma mark - 获取最大最小经纬度
- (void)dealWithMaxMinData {
    CGFloat maxLatitude = 0;
    CGFloat maxLongitude = 0;
    CGFloat minLatitude = MAXFLOAT;
    CGFloat minLongitude = MAXFLOAT;
    for (Location *location in _exerciseData.allLocationArray) {
        maxLatitude = maxLatitude > location.latitude ? maxLatitude : location.latitude;
        maxLongitude = maxLongitude > location.longitude ? maxLongitude : location.longitude;
        minLatitude = minLatitude < location.latitude ? minLatitude : location.latitude;
        minLongitude = minLongitude < location.longitude ? minLongitude : location.longitude;
    }
    self.centerCoordinate = CLLocationCoordinate2DMake(minLatitude / 2 + maxLatitude / 2, minLongitude / 2  + maxLongitude / 2);
    self.maxCoordinate = CLLocationCoordinate2DMake(maxLatitude, maxLongitude);
    self.minCoordiante = CLLocationCoordinate2DMake(minLatitude, minLongitude);
}

- (void)createMapView {
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _mapView.showsUserLocation = NO;
    _mapView.delegate = self;
    
    // 默认模式
    //    _mapView.showsLabels = NO;
//    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    // 比例尺
    _mapView.showsScale = NO;
    // 罗盘
    _mapView.showsCompass = NO;
      // 相机旋转
    _mapView.rotateEnabled = NO;
    
   
    
    
    
    MKPointAnnotation *startPointAnnotation = [[MKPointAnnotation alloc] init];
    Location *startLocation = [_exerciseData.allLocationArray firstObject];
    startPointAnnotation.coordinate = CLLocationCoordinate2DMake(startLocation.latitude, startLocation.longitude);
    startPointAnnotation.title = @"start";
    [_mapView addAnnotation:startPointAnnotation];
    MKPointAnnotation *endPointAnnotation = [[MKPointAnnotation alloc] init];
    Location *endLocation = [_exerciseData.allLocationArray lastObject];
    endPointAnnotation.coordinate = CLLocationCoordinate2DMake(endLocation.latitude, endLocation.longitude);
    endPointAnnotation.title = @"end";
    [_mapView addAnnotation:endPointAnnotation];
    
    MKPointAnnotation *minPointAnnotation = [[MKPointAnnotation alloc] init];
    minPointAnnotation.coordinate = CLLocationCoordinate2DMake(_minCoordiante.latitude, _maxCoordinate.longitude);;
    minPointAnnotation.title = @"maxmin";
    [_mapView addAnnotation:minPointAnnotation];
    
    MKPointAnnotation *maxPointAnnotation = [[MKPointAnnotation alloc] init];
    maxPointAnnotation.coordinate = CLLocationCoordinate2DMake(_maxCoordinate.latitude, _minCoordiante.longitude);;
    maxPointAnnotation.title = @"maxmin";
    [_mapView addAnnotation:maxPointAnnotation];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    // 设置需要轻拍的次数
    //    tap.numberOfTapsRequired = 2;
    // 设置多点轻拍
    tap.numberOfTouchesRequired = 1;
    // 视图添加一个手势
    [_mapView addGestureRecognizer:tap];
}
- (void)createBtn {
    __weak typeof(self) weakSelf = self;
    
    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(SCREEN_WIDTH - 40, 15, 30, 30);
    _locationButton.layer.cornerRadius = 4;
    [_locationButton setBackgroundImage:[UIImage imageNamed:@"map_btn_location"] forState:UIControlStateNormal];
    _locationButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    [_locationButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf.mapView showAnnotations:weakSelf.mapView.annotations animated:YES];

        
        
    }];
    [self.mapView addSubview:_locationButton];
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuButton.frame = CGRectMake(SCREEN_WIDTH - 40, _locationButton.y + _locationButton.height + 15, 30, 30);
    _menuButton.layer.cornerRadius = 4;
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
    [self.mapView addSubview:_menuButton];


}
- (void)createEffectView {
    UIView *effectView= [[UIView alloc] init];
    effectView.backgroundColor = [UIColor whiteColor];
    effectView.userInteractionEnabled = YES;
    effectView.frame = CGRectMake(20, _mapView.height - 160, SCREEN_WIDTH - 40, 140);
    effectView.layer.cornerRadius = 8;
    effectView.clipsToBounds = YES;
    // 把要添加的视图加到毛玻璃上
    [self.mapView addSubview:effectView];
    
    UILabel *distanceLabel = [[UILabel alloc] init];
    distanceLabel.text = [NSString stringWithFormat:@"%.2f", _exerciseData.distance];
    distanceLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:40];
    CGFloat width = [distanceLabel.text widthWithFont:distanceLabel.font constrainedToHeight:70];
    distanceLabel.frame = CGRectMake(effectView.width / 2 - width / 2 - 20, 0, width, 70);
//    [distanceLabel sizeToFit];
    [effectView addSubview:distanceLabel];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(distanceLabel.x + distanceLabel.width + 10, distanceLabel.y + distanceLabel.height - 44, 50, 30)];
    textLabel.text = @"公里";
    textLabel.font = kFONT_SIZE_18_BOLD;
    [effectView addSubview:textLabel];
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(40, distanceLabel.y + distanceLabel.height, effectView.width - 80, 1)];
    lineV.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [effectView addSubview:lineV];
    
    ExerciseDataView *leftDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(0, effectView.height - 70, effectView.width / 3, 60)];
    leftDataView.titleLabel.font = kFONT_SIZE_18_BOLD;
    leftDataView.titleLabel.text = @"时长";
    leftDataView.titleLabel.textColor = [UIColor blackColor];
    leftDataView.dataLabel.textColor = [UIColor blackColor];
    leftDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
    NSInteger time = _exerciseData.duration;
    NSInteger sec;
    NSInteger minu;
    NSInteger hour;
    sec = time % 60;
    minu = time / 60 % 60;
    hour = time / 3600;
    leftDataView.dataLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", hour, minu, sec];

    [effectView addSubview:leftDataView];
    
    ExerciseDataView *middleDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(leftDataView.x + leftDataView.width, leftDataView.y, effectView.width / 3, leftDataView.height)];
    middleDataView.titleLabel.font = kFONT_SIZE_18_BOLD;
    middleDataView.titleLabel.text = @"平均配速";
    
    middleDataView.titleLabel.textColor = [UIColor blackColor];

    middleDataView.dataLabel.textColor = [UIColor blackColor];
    middleDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
    NSInteger timeSpeedSetting = (int)_exerciseData.averageSpeedSetting;
    NSInteger secSpeedSetting;
    NSInteger minuSpeedSetting;
    secSpeedSetting = timeSpeedSetting % 60;
    minuSpeedSetting = timeSpeedSetting / 60;
    middleDataView.dataLabel.text = [NSString stringWithFormat:@"%ld'%ld\"", minuSpeedSetting, secSpeedSetting];

    [effectView addSubview:middleDataView];
    
    
    ExerciseDataView *rightDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(middleDataView.x + middleDataView.width, middleDataView.y, effectView.width / 3, middleDataView.height)];
    rightDataView.titleLabel.font = kFONT_SIZE_18_BOLD;
    rightDataView.titleLabel.text = @"大卡";
    rightDataView.titleLabel.textColor = [UIColor blackColor];

    rightDataView.dataLabel.textColor = [UIColor blackColor];
    rightDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
    rightDataView.dataLabel.text = [NSString stringWithFormat:@"%.1f", _exerciseData.calorie];
    [effectView addSubview:rightDataView];
    
    UIView *lineHFirst = [[UIView alloc] initWithFrame:CGRectMake(middleDataView.x, middleDataView.y + middleDataView.height / 2 - 20, 1, 40)];
    lineHFirst.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [effectView addSubview:lineHFirst];
    
    UIView *lineHSecond = [[UIView alloc] initWithFrame:CGRectMake(rightDataView.x, rightDataView.y + rightDataView.height / 2 - 20, 1, 40)];
    lineHSecond.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [effectView addSubview:lineHSecond];
    

}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
//    if ([overlay isKindOfClass:[MAMutablePolyline class]])
//    {
//        MAMutablePolylineRenderer *view = [[MAMutablePolylineRenderer alloc] initWithMutablePolyline:(MAMutablePolyline *)overlay];
//        view.lineWidth = 4.0;
//        view.strokeColor = [UIColor greenColor];
//        
//        return view;
//    }

    if ([overlay isKindOfClass:[MKPolyline class]])
    {
//        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
        
        
        if ([overlay.title isEqualToString:@"1"]) {
        
            
      
//            CLLocationCoordinate2D *coordinates = [self initdata];
//            MAMapPoint mapPoints[_exerciseData.allLocationArray.count];
//            for (int i = 0; i < _exerciseData.allLocationArray.count; i++) {
//                mapPoints[i] = MAMapPointForCoordinate(coordinates[i]);
//            }
//            CGPoint *points = [polylineRenderer glPointsForMapPoints:mapPoints count:_exerciseData.allLocationArray.count];
//            
//            [polylineRenderer renderLinesWithPoints:points pointCount:_exerciseData.allLocationArray.count strokeColors:@[[UIColor greenColor],[UIColor redColor]] drawStyleIndexes:@[@1, @2] isGradient:YES lineWidth:7.5f looped:NO LineJoinType:kMALineJoinMiter LineCapType:kMALineCapButt lineDash:NO];
//            
            
            //        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:commonPolyline];
        
            polylineRenderer.lineWidth = 7.5f;
            // 连接类型
            polylineRenderer.lineJoin = kCGLineJoinRound;
            // 端点类型
            polylineRenderer.lineCap = kCGLineCapButt;
            
            polylineRenderer.strokeColor = [UIColor colorWithRed:0.185 green:1.0 blue:0.6866 alpha:1.0];
            
        } else if ([overlay.title isEqualToString:@"2"]) {
            
            polylineRenderer.lineWidth = 7.5f;
            // 连接类型
            polylineRenderer.lineJoin = kCGLineJoinRound;
            // 端点类型
            polylineRenderer.lineCap = kCGLineCapButt;
            polylineRenderer.lineDashPhase = 2.0;
            NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithInt:2] , [NSNumber numberWithInt:6], nil];
            polylineRenderer.lineDashPattern = array;
     
            polylineRenderer.strokeColor  = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
          
        }
        
        return polylineRenderer;
    }
    return nil;
}


- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (_menuButton.selected == YES) {
        [_menuEffectView removeFromSuperview];
        _menuButton.selected = NO;
    }
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
    
    _menuEffectView.frame = CGRectMake(SCREEN_WIDTH - 235, _menuButton.y + _menuButton.height + 20, 220, 120);
    _menuEffectView.layer.cornerRadius = 6;
    _menuEffectView.clipsToBounds = YES;

    [self.mapView addSubview:_menuEffectView];
    
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
    
//    NSLog(@"%@", _statusArray);
    
    if (_mapView.overlays) {
        [_mapView removeOverlays:_overlayArray];
    }
    if (_overlayArray.count > 0) {
        [_overlayArray removeAllObjects];
    }

    for (StatusArrayModel *temp in _statusArray) {
        
        CLLocationCoordinate2D commonPolylineCoords[temp.array.count];
        
        for (int i = 0; i < temp.array.count; i++) {
            self.location  = temp.array[i];
            commonPolylineCoords[i].latitude = self.location.latitude;
            commonPolylineCoords[i].longitude = self.location.longitude;
        }

        
        //构造折线对象
        
        MKPolyline *commonPolyline = [MKPolyline polylineWithCoordinates:commonPolylineCoords count:temp.array.count];
  
        if (temp.isStart == YES) {
            commonPolyline.title = @"1";
            
            
        } else {
            commonPolyline.title = @"2";
        }
        [_overlayArray addObject:commonPolyline];
        
//        在地图上添加折线对象
        [_mapView addOverlay: commonPolyline];
    }
    
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];

    
    self.averageSpeed = _exerciseData.averageSpeed;
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if([annotation isEqual:self.myLocation]) {
        
        static NSString *annotationIdentifier = @"myLcoationIdentifier";
        
        MKAnnotationView *poiAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        }
        
        poiAnnotationView.image = [UIImage imageNamed:@"aeroplane.png"];
        poiAnnotationView.canShowCallout = NO;
        
        return poiAnnotationView;
    }
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
         if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.annotation = annotation;
        annotationView.canShowCallout = NO;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = NO;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        //        annotationView.pinColor = MAPinAnnotationColorPurple;
//        annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_marker_%ld.png",((MAPointAnnotation *)annotation).]];
        if ([annotation.title isEqualToString:@"start"]) {
            annotationView.image = [UIImage imageNamed:@"map_startPoint"];
        } else if ([annotation.title isEqualToString:@"end"]) {
            annotationView.image = [UIImage imageNamed:@"map_endPoint"];

        } else if ([annotation.title isEqualToString:@"maxmin"]) {
            annotationView.image = nil;
        }
        annotationView.centerOffset = CGPointMake(0, -16);
        
        return annotationView;
    }
    return nil;
}

- (void)actionPlayAndStop
{
   
    
    self.isPlaying = !self.isPlaying;
    if (self.isPlaying)
    {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"nav_guiji"];
        if (self.myLocation == nil)
        {
            self.myLocation = [[MKPointAnnotation alloc] init];
            self.myLocation.title = @"AMap";
            Location *locaion = _exerciseData.allLocationArray.firstObject;
            self.myLocation.coordinate = CLLocationCoordinate2DMake(locaion.latitude, locaion.longitude);
            
            [self.mapView addAnnotation:self.myLocation];
        }
        
        [self animateToNextCoordinate];
    }
    else
    {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"nav_guiji"];
        
        MKAnnotationView *view = [self.mapView viewForAnnotation:self.myLocation];
        
        if (view != nil)
        {
            [view.layer removeAllAnimations];
        }
    }
}


- (void)animateToNextCoordinate
{
    if (self.myLocation == nil)
    {
        return;
    }
   
    CLLocationCoordinate2D *coordinates = [self initdata];
          if (self.currentLocationIndex == _exerciseData.allLocationArray.count)
        {
            self.currentLocationIndex = 0;
            [self actionPlayAndStop];
            return;
        }
        
        
        CLLocationCoordinate2D nextCoord = coordinates[self.currentLocationIndex];
        CLLocationCoordinate2D preCoord = self.currentLocationIndex == 0 ? nextCoord : self.myLocation.coordinate;
        
        double heading = [self coordinateHeadingFrom:preCoord To:nextCoord];
        CLLocationDistance distance = MKMetersBetweenMapPoints(MKMapPointForCoordinate(nextCoord), MKMapPointForCoordinate(preCoord));
        NSTimeInterval duration = distance / (_exerciseData.averageSpeed * 1000 / 60 / 60 * 1000);
        
        [UIView animateWithDuration:duration
                         animations:^{
                             self.myLocation.coordinate = nextCoord;
                         }
                         completion:^(BOOL finished){
                             self.currentLocationIndex++;
                             if (finished)
                             {
                                 [self animateToNextCoordinate];
                             }
                         }];
        MKAnnotationView *view = [self.mapView viewForAnnotation:self.myLocation];
        if (view != nil)
        {
            view.transform = CGAffineTransformMakeRotation((CGFloat)(heading / 180.0 * M_PI));
        }

    
    
    
}

- (double)coordinateHeadingFrom:(CLLocationCoordinate2D)head To:(CLLocationCoordinate2D)rear
{
    if (!CLLocationCoordinate2DIsValid(head) || !CLLocationCoordinate2DIsValid(rear))
    {
        return 0.0;
    }
    
    double delta_lat_y = rear.latitude - head.latitude;
    double delta_lon_x = rear.longitude - head.longitude;
    
    if (fabs(delta_lat_y) < 0.000001)
    {
        return delta_lon_x < 0.0 ? 270.0 : 90.0;
    }
    
    double heading = atan2(delta_lon_x, delta_lat_y) / M_PI * 180.0;
    
    if (heading < 0.0)
    {
        heading += 360.0;
    }
    return heading;
}

#pragma mark - Initialazation

- (void)initVariates
{
    self.isPlaying = NO;
    self.currentLocationIndex = 0;
    self.averageSpeed = 2;
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView *headView= [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    headView.layer.cornerRadius = 8;
    headView.clipsToBounds = YES;
    self.tableView.tableHeaderView = headView;
    
    UIView *leftBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3 * 2, 100)];
    [headView addSubview:leftBackView];
    
    UILabel *distanceLabel = [[UILabel alloc] init];
    distanceLabel.text = [NSString stringWithFormat:@"%.2f", _exerciseData.distance];
    distanceLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:40];
    CGFloat width = [distanceLabel.text widthWithFont:distanceLabel.font constrainedToHeight:70];
    distanceLabel.frame = CGRectMake(leftBackView.width / 2 - width / 2 - 20, 20, width, 70);
    //    [distanceLabel sizeToFit];
    [leftBackView addSubview:distanceLabel];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(distanceLabel.x + distanceLabel.width + 10, distanceLabel.y + distanceLabel.height - 44, 50, 30)];
    textLabel.text = @"公里";
    textLabel.font = kFONT_SIZE_18_BOLD;
    [leftBackView addSubview:textLabel];
    
    UIView *rightackView = [[UIView alloc] initWithFrame:CGRectMake(leftBackView.x + leftBackView.width, 0, SCREEN_WIDTH / 3, 100)];
    NSString *type;
    NSString *date;
    NSString *time;
    if ([_exerciseData.exerciseType isEqualToString:@"run"]) {
        type = @"跑步";
    } else if ([_exerciseData.exerciseType isEqualToString:@"walk"]) {
        type = @"健走";
    } else {
        type = @"骑车";
    }
    NSArray *array = [_exerciseData.startTime componentsSeparatedByString:@" "];
    date =  [array.firstObject substringFromIndex:5];
    time = [array.lastObject substringToIndex:5];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, rightackView.height / 2 - 30, 100, 20)];
    typeLabel.text = type;
    typeLabel.textColor = [UIColor grayColor];
    [rightackView addSubview:typeLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(typeLabel.x, typeLabel.y + typeLabel.height, 100, 20)];
    dateLabel.textColor = [UIColor grayColor];

    dateLabel.text = date;
    [rightackView addSubview:dateLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateLabel.x, dateLabel.y + dateLabel.height, 100, 20)];
    timeLabel.text = time;
    timeLabel.textColor = [UIColor grayColor];

    [rightackView addSubview:timeLabel];
    [headView addSubview:rightackView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(leftBackView.x + leftBackView.width, 30, 1, 40)];
    lineView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [headView addSubview:lineView];
    
//    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(headView.width / 2 - 120, headView.height - 1, 240, 1)];
//    bottomLineView.backgroundColor = [UIColor lightGrayColor];
//    [headView addSubview:bottomLineView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell * ) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *const cellIdentifier = @"cell";
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *durationStr = [NSString stringWithFormat:@"%.2f", _exerciseData.duration];
    NSInteger sec;
    NSInteger minu;
    NSInteger hour;
    sec = [durationStr integerValue] % 60;
    minu = ([durationStr integerValue] / 60)% 60;
    hour = [durationStr integerValue] / 3600;
    

    NSInteger timeSpeedSetting = (int)_exerciseData.averageSpeedSetting;
    NSInteger secSpeedSetting;
    NSInteger minuSpeedSetting;
    secSpeedSetting = timeSpeedSetting % 60;
    minuSpeedSetting = timeSpeedSetting / 60;

    
    
    
    
    switch (indexPath.row) {
        case 0:
            cell.leftDataView.dataLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", hour, minu, sec];;
            cell.leftDataView.titleLabel.text = @"时长";
            cell.leftImageView.image = [UIImage imageNamed:@"表-4"];
            cell.rightDataView.dataLabel.text = [NSString stringWithFormat:@"%ld'%ld\"", minuSpeedSetting, secSpeedSetting];
            cell.rightDataView.titleLabel.text = @"平均配速";
            cell.rightImageView.image = [UIImage imageNamed:@"快速抄表"];
            break;
        case 1:
            cell.leftDataView.dataLabel.text = [NSString stringWithFormat:@"%.1f", _exerciseData.calorie];;
            cell.leftDataView.titleLabel.text = @"卡路里(大卡)";
            cell.leftImageView.image = [UIImage imageNamed:@"676-卡里路-4"];
            cell.rightImageView.image = [UIImage imageNamed:@"速度表"];

            cell.rightDataView.dataLabel.text = [NSString stringWithFormat:@"%.2f", _exerciseData.averageSpeed];
            cell.rightDataView.titleLabel.text = @"平均速度(Km/h)";
            break;
        case 2:
            if (_exerciseData.isComplete == 1) {
                cell.leftDataView.dataLabel.text = @"已完成";
            } else {
                cell.leftDataView.dataLabel.text = @"未完成";
            }
            cell.rightImageView.image = [UIImage imageNamed:@"速度表"];

            cell.leftImageView.image = [UIImage imageNamed:@"目标"];
            cell.leftDataView.titleLabel.text = _exerciseData.aim;
            cell.rightDataView.dataLabel.text = [NSString stringWithFormat:@"%.2f", _exerciseData.maxSpeed];
            cell.rightDataView.titleLabel.text = @"最大速度(Km/h)";
            
            break;
        default:
            break;
    }
    return cell;
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
