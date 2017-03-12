//
//  ScoreViewController.m
//  NeverStop
//
//  Created by DYQ on 16/10/31.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ScoreViewController.h"
#import "ScoreTableViewCell.h"

@interface ScoreViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *scoreTableView;

@end

@implementation ScoreViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    UIBarButtonItem *backItem = [UIBarButtonItem getBarButtonItemWithImageName:@"navigator_btn_back" HighLightedImageName:nil targetBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.title = @"成绩";
    self.navigationItem.leftBarButtonItem = backItem;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createScoreTableView];
}

- (void)createScoreTableView {
    self.scoreTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _scoreTableView.delegate = self;
    _scoreTableView.dataSource = self;
    _scoreTableView.rowHeight =  80.f;
    _scoreTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:_scoreTableView];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.type = [NSString stringWithFormat:@"%ld", indexPath.row];
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
