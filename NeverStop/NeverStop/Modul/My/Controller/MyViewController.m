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

@interface MyViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *myInfoTableView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *userNameLabel;

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createMyInfoTableView];
    
    
}

- (void)createMyInfoTableView {
    
    self.myInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _myInfoTableView.delegate = self;
    _myInfoTableView.dataSource = self;
//    _myInfoTableView.rowHeight = 100.f;
    _myInfoTableView.contentInset = UIEdgeInsetsMake(SCREEN_HEIGHT / 3, 0, 44, 0);
    [self.view addSubview:_myInfoTableView];
    
    self.topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -SCREEN_HEIGHT / 3, SCREEN_WIDTH, SCREEN_HEIGHT / 3)];
    _topImageView.image = [UIImage imageNamed:@"top.jpg"];
    [_myInfoTableView addSubview:_topImageView];
    
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80) / 2, -40, 80, 80)];
    userView.backgroundColor = [UIColor whiteColor];
    userView.layer.cornerRadius = 40;
    userView.layer.borderColor = [UIColor grayColor].CGColor;
    userView.layer.borderWidth = 2.f;
    [_myInfoTableView addSubview:userView];
    
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    userImageView.image = [UIImage imageNamed:@"userImage"];
    [userView addSubview:userImageView];
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300) / 2, userView.y + userView.height, 300, 50)];
    _userNameLabel.text = [[EMClient sharedClient] currentUsername];
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    _userNameLabel.font = kFONT_SIZE_24;
    [_myInfoTableView addSubview:_userNameLabel];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (-scrollView.contentOffset.y >= SCREEN_HEIGHT / 3) {
        _topImageView.y = scrollView.contentOffset.y;
        _topImageView.height = SCREEN_HEIGHT / 3 + (-scrollView.contentOffset.y - SCREEN_HEIGHT / 3);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (3 == indexPath.row | 4 == indexPath.row) {
        return 80;
    }
    return 100.f;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[MyInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
    switch (indexPath.row) {
        case 1:
            cell.imageName = @"recode";
            cell.title = @"成绩";
            cell.subtitle = @"个人运动记录";
            break;
        case 2:
            cell.imageName = @"plane";
            cell.title = @"训练计划";
            cell.subtitle = @"加入训练计划";
            break;
        case 3:
            cell.imageName = @"hist";
            cell.title = @"历史记录";
//            cell.subtitle = @"";
            break;
        case 4:
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
        case 1: {
            ScoreViewController *scoreVC = [[ScoreViewController alloc] init];
            [self.navigationController pushViewController:scoreVC animated:YES];
        }
            break;
        case 2: {
            PlanViewController *planVC = [[PlanViewController alloc] init];
            [self.navigationController pushViewController:planVC animated:YES];
        }
            break;
        case 3: {
            HistoryViewController *historyVC = [[HistoryViewController alloc] init];
            [self.navigationController pushViewController:historyVC animated:YES];
        }
            break;
        case 4: {
            OthersViewController *othersVC = [[OthersViewController alloc] init];
            [self.navigationController pushViewController:othersVC animated:YES];
        }
            break;

            
        default:
            break;
    }
}

- (void)setUserName:(NSString *)userName {
    if (_userName != userName) {
        _userName = userName;
        self.userNameLabel.text = userName;
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
