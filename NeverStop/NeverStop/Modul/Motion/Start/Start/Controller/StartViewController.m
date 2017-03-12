//
//  StartViewController.m
//  NeverStop
//
//  Created by Jiang on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "StartViewController.h"
#import "JiangPickerView.h"
#import "AimSettingPickerView.h"
#import "CaloriePickerView.h"
#import "CustomPickerView.h"
#import "ExerciseViewController.h"
#import "CustomAnimateTransitionPush.h"
@interface StartViewController ()
<
MKMapViewDelegate,
AMapSearchDelegate,
AimSettingPickerViewDelegate,
CaloriePickerViewDelegate,
CustomPickerViewDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) AMapSearchAPI *mapSearchAPI;
@property (nonatomic, strong) JiangPickerView *aimPickerView;

@property (nonatomic, strong) NSString *setting;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) ExerciseData *exerciseData;

@end

@implementation StartViewController
- (void)dealloc {
    
    self.navigationController.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.delegate = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义一个NaVigationBar
    self.row = 0;
    self.navigationItem.title = @"运动";

    __weak typeof(self) weakSelf = self;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem getBarButtonItemWithImageName:@"nav_back_black" HighLightedImageName:nil targetBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    //消除阴影
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatMapView];
    
    // 设定目标按钮
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settingButton setTitle:@"设定单次目标" forState:UIControlStateNormal];
    [_settingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _settingButton.titleLabel.font = kFONT_SIZE_18_BOLD;
    _settingButton.backgroundColor = [UIColor clearColor];
    CGFloat width = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
    _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width / 2, _mapView.y + _mapView.height, width, 50);
    
    [_settingButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        AimSettingPickerView *aimSettingPicker = [[AimSettingPickerView alloc]init];
        aimSettingPicker.delegate = weakSelf;
        aimSettingPicker.contentMode = JiangPickerContentModeBottom;
        [aimSettingPicker show];
        
    }];
    [self.view addSubview:_settingButton];
    
    
    
    // 缩放 开始按钮
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.frame = CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 240, 80, 80);
    UIImage *startImage = [UIImage imageNamed:@"start_btn"];
    [_startButton setBackgroundImage:startImage forState:UIControlStateNormal];
    [_startButton setBackgroundImage:startImage forState:UIControlStateHighlighted];
    [_startButton setBackgroundImage:startImage forState:UIControlStateHighlighted];
//    _startButton.backgroundColor = [UIColor greenColor];
    
    
    
    
    [_startButton addTarget:self action:@selector(pressedEvent:) forControlEvents:UIControlEventTouchDown];
    [_startButton addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [_startButton addTarget:self action:@selector(unpressedEvent:) forControlEvents:UIControlEventTouchUpInside];
    _startButton.layer.cornerRadius = 40;
    _startButton.clipsToBounds = YES;
    [self.view addSubview:_startButton];
    
    
    
    NSLog(@"+++++++++%f++++++++%f", _settingButton.frame.origin.y, _settingButton.frame.size.height);
    
    
}

- (void)aimSettingPicker:(AimSettingPickerView *)aimSettingPicker setting:(NSString *)setting viewForRow:(NSInteger)row forChildRow:(NSInteger)childRow {
    
//    NSLog(@"%ld %ld", (long)childRow, (long)row);
    self.row = row;
    CustomPickerView *customPicker = [[CustomPickerView alloc] init];
    customPicker.delegate = self;
    customPicker.contentMode = JiangPickerContentModeBottom;
    CaloriePickerView *caloriePicker = [[CaloriePickerView alloc] init];
    caloriePicker.delegate = self;
    caloriePicker.contentMode = JiangPickerContentModeBottom;
    MapDataManager *mapDataManager = [MapDataManager shareDataManager];
    [mapDataManager openDB];
    [mapDataManager createTable];
    
    NSArray *array = [mapDataManager selectAll];
    NSString *str;
    if (array.count > 0) {
       self.exerciseData = [array lastObject];
    }
    switch (row) {
        case 0:
            [_settingButton setTitle:@"设定单次目标" forState:UIControlStateNormal];
            CGFloat width0 = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
            _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width0 / 2, _mapView.y + _mapView.height + 64, width0, 50);
            break;
        case 1:
            if (array.count > 0) {
                self.row = _exerciseData.aimType;
            } else {
                self.row = 0;
            }
            str = [setting stringByReplacingOccurrencesOfString:@"上次选择 " withString:@""];
            if (self.row == 0) {
                [_settingButton setTitle:@"设定单次目标" forState:UIControlStateNormal];
            } else {
            [_settingButton setTitle:str forState:UIControlStateNormal];
            }
            CGFloat width1 = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
            _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width1 / 2, _mapView.y + _mapView.height + 64, width1, 50);
            break;
        case 2:
            if (childRow != 0) {
                NSString *distanceStr = [NSString stringWithFormat:@"距离目标: %@", setting];
                [_settingButton setTitle:distanceStr forState:UIControlStateNormal];
                CGFloat width2 = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
                _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width2 / 2, _mapView.y + _mapView.height + 64, width2, 50);
                
            } else {
                customPicker.cus_ContentMode = CustomPickerContentModeDistance;
                [customPicker show];
            }
            break;
        case 3:
            if (childRow != 0) {
                NSString *timeStr = [NSString stringWithFormat:@"时间目标: %@", setting];
                [_settingButton setTitle:timeStr forState:UIControlStateNormal];
                CGFloat width3 = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
                _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width3 / 2, _mapView.y + _mapView.height + 64, width3, 50);
            } else {
                customPicker.cus_ContentMode = CustomPickerContentModeTime;
                [customPicker show];
            }
            break;
        case 4:
            if (childRow != 0) {
                NSString *calorieStr = [NSString stringWithFormat:@"卡路里目标: %@", setting];
                [_settingButton setTitle:calorieStr forState:UIControlStateNormal];
                CGFloat width4 = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
                _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width4 / 2, _mapView.y + _mapView.height + 64, width4, 50);
            } else {
                [caloriePicker show];
            }
            break;
        default:
            break;
    }
    NSLog(@"+++++++++%f++++++++%f", _settingButton.frame.origin.y, _settingButton.frame.size.height);
    
    
    
}
- (void)caloriePicker:(CaloriePickerView *)caloriePicker selected:(NSString *)selected {
    NSString *string = [NSString stringWithFormat:@"卡路里目标: %@大卡", selected];
    [_settingButton setTitle:string forState:UIControlStateNormal];
    CGFloat width = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
    _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width / 2, _mapView.y + _mapView.height + 100, width, 50);
    
}
- (void)customPicker:(CustomPickerView *)customPicker selected:(NSString *)selected childSelected:(NSString *)childSelected viewForRow:(NSInteger)row forChildRow:(NSInteger)childRow {
    if (customPicker.cus_ContentMode == CustomPickerContentModeDistance) {
        [_settingButton setTitle:[NSString stringWithFormat:@"距离目标: %@.%@公里", selected, childSelected] forState:UIControlStateNormal];
        CGFloat width = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
        _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width / 2, _mapView.y + _mapView.height + 100, width, 50);
    } else {
        NSInteger time = [selected intValue] * 60 + [childSelected intValue];
        [_settingButton setTitle:[NSString stringWithFormat:@"时间目标: %ld分钟", time] forState:UIControlStateNormal];
        CGFloat width = [_settingButton.titleLabel.text widthWithFont:_settingButton.titleLabel.font constrainedToHeight:50];
        _settingButton.frame = CGRectMake(SCREEN_WIDTH / 2 - width / 2, _mapView.y + _mapView.height + 100, width, 50);
    }
    
}




//用来自定义转场动画
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    if(operation == UINavigationControllerOperationPush)
    {
        CustomAnimateTransitionPush *animateTransitionPush=[CustomAnimateTransitionPush new];
        animateTransitionPush.contentMode = JiangContentModeToExercise;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _startButton.frame;
        button.y = button.y + 64;
        animateTransitionPush.button = button;
        return animateTransitionPush;
    }
    else
    {
        return nil;
    }
    
}





//按钮的压下事件 按钮缩小
- (void)pressedEvent:(UIButton *)btn
{
    //缩放比例必须大于0，且小于等于1
    
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.75, 0.75);
    }];
    
    
}
//点击手势拖出按钮frame区域松开，响应取消
- (void)cancelEvent:(UIButton *)btn
{
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}
//按钮的松开事件 按钮复原 执行响应
- (void)unpressedEvent:(UIButton *)btn
{
    [UIView animateWithDuration:0.25 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        ExerciseViewController *exerciseVC = [[ExerciseViewController alloc] init];
        exerciseVC.aim = _settingButton.currentTitle;
        exerciseVC.exerciseType = self.exerciseType;
        exerciseVC.aimType = _row;
        [self.navigationController pushViewController:exerciseVC animated:YES];
        
    }];
}


- (void)creatMapView {
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 320)];
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
  
    // 默认模式
    
    [_mapView setUserTrackingMode: MKUserTrackingModeFollow animated:YES];
    // 比例尺
    _mapView.showsScale = NO;
    // 罗盘
    _mapView.showsCompass = NO;
    // 允许缩放
    _mapView.zoomEnabled = YES;
    
    // 楼块
    _mapView.showsBuildings = NO;
    
    //    _mapView.logoCenter = CGPointMake(SCREEN_WIDTH - 55, 450);
    // 交互
    _mapView.userInteractionEnabled = NO;
    // 中心位置
    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
}

// 自定义精度圈样式
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {

    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:(MKPolyline *)overlay];
        polylineRenderer.lineWidth = 10.f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:0.1786 green:0.9982 blue:0.8065 alpha:1.0];
        // 连接类型
        polylineRenderer.lineJoin = kCGLineJoinRound;
        // 端点类型
        polylineRenderer.lineCap = kCGLineCapRound;
        
        return polylineRenderer;
    }
    return nil;
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
