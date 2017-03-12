//
//  PlanViewController.m
//  NeverStop
//
//  Created by DYQ on 16/10/31.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "PlanViewController.h"
#import "PlanModel.h"
#import "PlanTableViewCell.h"
#import "CategoriesViewController.h"

@interface PlanViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) NSMutableArray *planModelArr;
@property (nonatomic, strong) UITableView *planTableView;

@end

@implementation PlanViewController

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
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.title = @"运动计划";
    self.planModelArr = [NSMutableArray array];
    [self createPlanTableView];
    [self getData];
    
}

- (void)createPlanTableView {
    self.planTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _planTableView.delegate = self;
    _planTableView.dataSource = self;
    _planTableView.rowHeight = 201;
    _planTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _planTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:_planTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _planModelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[PlanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PlanModel *planModel = _planModelArr[indexPath.row];
    cell.planModel = planModel;
    return cell;
}

- (void)getData {
    
    [HttpClient GET:@"http://training.api.thejoyrun.com/getTrains" body:nil headerFile:nil response:JYX_JSON success:^(id result) {
        NSArray *dataArr = [result objectForKey:@"data"];
        for (NSDictionary *dataDic in dataArr) {
            PlanModel *planModel = [PlanModel mj_objectWithKeyValues:dataDic];
            [_planModelArr addObject:planModel];
        }
        [_planTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error : %@", error);
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoriesViewController *categoriesVC = [[CategoriesViewController alloc] init];
    PlanModel *planModel = _planModelArr[indexPath.row];
    categoriesVC.trainId = planModel.trainId;
    [self.navigationController pushViewController:categoriesVC animated:YES];


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
