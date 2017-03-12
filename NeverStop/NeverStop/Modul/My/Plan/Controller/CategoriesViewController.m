//
//  CategoriesViewController.m
//  NeverStop
//
//  Created by DYQ on 16/11/1.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoriesModel.h"
#import "CategoriesTableViewCell.h"

@interface CategoriesViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) NSMutableArray *categoriesArr;
@property (nonatomic, strong) UITableView *categoriesTableView;

@end

@implementation CategoriesViewController
- (void)viewWillAppear:(BOOL)animated {
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
    self.navigationItem.title = @"训练计划";
    self.categoriesArr = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
    [self createCategoriesTableView];
}

- (void)createCategoriesTableView {
    self.categoriesTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _categoriesTableView.delegate = self;
    _categoriesTableView.dataSource = self;
    _categoriesTableView.rowHeight = 200;
    _categoriesTableView.contentInset = UIEdgeInsetsMake(0, 0, 24, 0);
    [self.view addSubview:_categoriesTableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categoriesArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[CategoriesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor colorWithRed:0.3446 green:0.3446 blue:0.3446 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CategoriesModel *categoriesModel = _categoriesArr[indexPath.row];
    cell.categoriesModel = categoriesModel;
    return cell;
    
    
    
}

- (void)getData {
    long long timeStamp = [NSDate timeStamp];
    NSString *urlString = [NSString stringWithFormat:@"http://training.api.thejoyrun.com/getPlanCategories?signature=0D69F33CB8809BD2CB62F00621E456C1&timestamp=%lld&trainId=%@", timeStamp, _trainId];
    [HttpClient GET:urlString body:nil headerFile:nil response:JYX_JSON success:^(id result) {
        NSArray *dataArr = [result objectForKey:@"data"];
        for (NSDictionary *dataDic in dataArr) {
            CategoriesModel *categoriesModel = [CategoriesModel modelWithDic:dataDic];
            [_categoriesArr addObject:categoriesModel];
        }
        [_categoriesTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
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
