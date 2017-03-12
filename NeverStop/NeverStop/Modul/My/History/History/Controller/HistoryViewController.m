//
//  HistoryViewController.m
//  NeverStop
//
//  Created by DYQ on 16/11/1.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "HistoryData.h"
#import "ExerciseRecordViewController.h"
@interface HistoryViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) NSMutableArray *exerciseArray;

@end

@implementation HistoryViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationController.navigationBar.translucent = NO;
}
- (void)loadView {
    [super loadView];
    self.exerciseArray = [NSMutableArray array];
    
    [[MapDataManager shareDataManager] openDB];
    [[MapDataManager shareDataManager] createTable];
    NSArray *array = [[MapDataManager shareDataManager] selectAll];
    NSString *lastStr;
    int a = 0;
    HistoryData *data = [[HistoryData alloc] init];
    for (ExerciseData *exerciseData in array) {
        
        data.dateSection = [exerciseData.startTime substringWithRange:NSMakeRange(2, 6)];
        
        if ([data.dateSection isEqualToString:lastStr] || (a == 0) || ((a + 1) == array.count)) {
            [data.array addObject:exerciseData];
        }
        if ((![data.dateSection isEqualToString:lastStr] && a != 0 )|| (a + 1) == array.count) {
            [self.exerciseArray addObject:[data copy]];
            [data.array removeAllObjects];
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:data forKey:@"data"];
        a++;
        lastStr = data.dateSection;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    UIBarButtonItem *backItem = [UIBarButtonItem getBarButtonItemWithImageName:@"navigator_btn_back" HighLightedImageName:nil targetBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.leftBarButtonItem = backItem;
    self.navigationItem.title = @"历史记录";
    [self createHistoryTableView];
}

- (void)createHistoryTableView {
    
    self.historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _historyTableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    _historyTableView.showsHorizontalScrollIndicator = NO;

    _historyTableView.rowHeight = 100;
    [self.view addSubview:_historyTableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _exerciseArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    HistoryData *data = _exerciseArray[section];

    return data.dateSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HistoryData *data = _exerciseArray[section];
    return data.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    }
    HistoryData *data = _exerciseArray[indexPath.section];
    cell.exerciseData = data.array[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExerciseRecordViewController *exerciseRecordVC = [[ExerciseRecordViewController alloc] init];
    HistoryData *data = _exerciseArray[indexPath.section];
    exerciseRecordVC.exerciseData = data.array[indexPath.row];
    [self.navigationController pushViewController:exerciseRecordVC animated:YES];
    
    
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
