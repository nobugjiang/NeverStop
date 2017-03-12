//
//  RouteViewController.m
//  NeverStop
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

// 骑行所属推荐的二级界面
#import "RouteViewController.h"
#import "RouteTableViewCell.h"
#import "Route.h"
#import "DetailedViewController.h"
@interface RouteViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *routeArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.routeArray = [NSMutableArray array];
    [self roubeJX];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = 160.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _routeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[RouteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    Route *routeModel = _routeArray[indexPath.row];
    cell.route = routeModel;
    return cell;
}

- (void) roubeJX {
    
    NSString *roubeJx = @"http://www.imxingzhe.com/api/v4/collection_info/?id=41&xingzhe_timestamp=1476844466.793446";
    
    [HttpClient GET:roubeJx body:nil headerFile:nil response:JYX_JSON success:^(id result) {
        NSArray *roArray = [result objectForKey:@"collection"];
        for (NSDictionary *roDic in roArray) {
            Route *roModel = [Route modelWithDic:roDic];
            [_routeArray addObject:roModel];
            
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   DetailedViewController *DVC = [[DetailedViewController alloc] init];
    Route *roModel = _routeArray[indexPath.row];
    DVC.roModel = roModel;
    
    [self.navigationController pushViewController:DVC animated:YES];
    
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
