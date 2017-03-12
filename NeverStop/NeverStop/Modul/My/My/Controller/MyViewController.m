//
//  MyViewController.m
//  Never Stop
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MyViewController.h"
#import "MyInfoTableViewCell.h"
#import "ScoreViewController.h"
#import "PlanViewController.h"
#import "HistoryViewController.h"
#import "OthersViewController.h"
#import "MemberHeadView.h"
#import "WaveImageView.h"

static CGFloat const imageHeight = 200;
@interface MyViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *myInfoTableView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, retain) MemberHeadView *memberHeadView;
@property (nonatomic, retain) WaveImageView *waveImageView;
/** 是否正在播放动画 */
@property (nonatomic, assign, getter=isShowWave) BOOL showWave;
@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.navigationController.navigationBar.translucent = YES;}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.navigationItem.title = @"我的";
    
    [self createMyInfoTableView];
     [self setupHeaderView];
}
- (void)setupHeaderView
{
    self.waveImageView = [[WaveImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, imageHeight)];
    _waveImageView.image = [UIImage imageNamed:@"headImage.jpg"];
    [_myInfoTableView addSubview:_waveImageView];
    
    
    self.memberHeadView = [[MemberHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    [self scrollViewDidScroll:self.myInfoTableView];
    _memberHeadView.clipsToBounds = YES;
    _memberHeadView.contentMode = UIViewContentModeScaleAspectFill;
    _memberHeadView.clipsToBounds = YES;
    _myInfoTableView.tableHeaderView = _memberHeadView;
    _myInfoTableView.tableHeaderView.frame = _memberHeadView.frame;
    
    
    
    //    // 与图像高度一样防止数据被遮挡
    //    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , _headWaveView.height)];
    
}

- (void)createMyInfoTableView {
    
    self.myInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT - 40) style:UITableViewStyleGrouped];
    _myInfoTableView.delegate = self;
    _myInfoTableView.dataSource = self;
//    _myInfoTableView.rowHeight = 100.f;
//    _myInfoTableView.contentInset = UIEdgeInsetsMake(SCREEN_HEIGHT / 3, 0, 44, 0);
    [self.view addSubview:_myInfoTableView];
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (-scrollView.contentOffset.y >= SCREEN_HEIGHT / 3) {
//        _topImageView.y = scrollView.contentOffset.y;
//        _topImageView.height = SCREEN_HEIGHT / 3 + (-scrollView.contentOffset.y - SCREEN_HEIGHT / 3);
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (3 == indexPath.row | 2 == indexPath.row) {
        return 80;
    }
    return 100.f;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[MyInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.imageName = @"recode";
            cell.title = @"成绩";
            cell.subtitle = @"个人运动记录";
            break;
        case 1:
            cell.imageName = @"plane";
            cell.title = @"训练计划";
            cell.subtitle = @"加入训练计划";
            break;
        case 2:
            cell.imageName = @"hist";
            cell.title = @"历史记录";
//            cell.subtitle = @"";
            break;
        case 3:
            cell.imageName = @"set";
            cell.title = @"设置";
//            cell.subtitle = @"";
            break;
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            ScoreViewController *scoreVC = [[ScoreViewController alloc] init];
            scoreVC.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:scoreVC animated:YES];
        }
            break;
        case 1: {
            PlanViewController *planVC = [[PlanViewController alloc] init];
            planVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:planVC animated:YES];

        }
            break;
        case 2: {
            HistoryViewController *historyVC = [[HistoryViewController alloc] init];
            historyVC.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:historyVC animated:YES];
        }
            break;
        case 3: {
            OthersViewController *othersVC = [[OthersViewController alloc] init];
            othersVC.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:othersVC animated:YES];
        }
            break;

            
        default:
            break;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.isShowWave) {
        [self.waveImageView starWave];
    }
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //    NSLog(@"%f", fabs(offsetY));
    if (fabs(offsetY) > 20) {
        self.showWave = YES;
    }
    else {
        self.showWave = NO;
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.waveImageView stopWave];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGRect tempF = self.waveImageView.frame;
    //     如果offsetY大于0，说明是向上滚动，缩小
    if (offsetY > 0) {
        _waveImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, imageHeight);
        //        NSLog(@"%f", _waveImageView.y);
        //        NSLog(@"%f", _tableView.y);
        //        _tableView.y = -64;
        
    }else{
        // 如果offsetY小于0，让headImageView的Y值等于0，headImageView的高度要放大
        tempF.size.height = imageHeight - offsetY;
        //        NSLog(@"%f", tempF.size.height);
        
        tempF.origin.y = 0 + offsetY;
        //        NSLog(@"%f", tempF.origin.y);
        
        self.waveImageView.frame = tempF;
    }
    CGFloat alpha = offsetY / 64;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
    
    
    
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.f, 0.f, 1.f, 1.f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 用颜色填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return  image;
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
