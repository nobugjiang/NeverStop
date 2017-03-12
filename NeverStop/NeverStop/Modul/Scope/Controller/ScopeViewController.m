//
//  ScopeViewController.m
//  Never Stop
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ScopeViewController.h"
#import "Scope.h"
#import "ScopeTableViewCell.h"
#import "GroupViewController.h"
#import "Group.h"
@interface ScopeViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *scopeArray;

@end

@implementation ScopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ScopeTableView];
    self.scopeArray = [NSMutableArray array];
    [self ScopeJX];
   
    self.view.backgroundColor = [UIColor whiteColor];
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
}

- (void)ScopeTableView {
    self.tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _tableView.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    _tableView.rowHeight = 100.f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScopeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ScopeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    //cell.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    cell.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    Scope *scopeModel = _scopeArray[indexPath.row];
    cell.scopeModel = scopeModel;
    return cell;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _scopeArray.count;
}




- (void)ScopeJX {
NSString *string = @"http://api.dongdong17.com/dongdong/ios/api/v8/group_list?account_id=63375925";
    [HttpClient GET:string body:nil headerFile:@{@"Authorization" : @"Pacer kLNGVWvEuOwlHtC%2FYUh7c8PoeWA%3D"} response:JYX_JSON success:^(id result) {
        NSArray *array = [result objectForKey:@"recommends"];
        for (NSDictionary *dic in array) {
            Scope *scopeModel = [Scope mj_objectWithKeyValues:dic];
            [_scopeArray addObject:scopeModel];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupViewController *GVC = [[GroupViewController alloc] init];
    Scope *scModel = _scopeArray[indexPath.row];
    GVC.scModel = scModel;
    [self.navigationController pushViewController:GVC animated:YES];
    
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    //当tableview下拉到最后一行的时候才触发
//         if (indexPath.row == self.scopeArray.count - 1) {
//                //定义一个UIView
//             UIView *footSpinnerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 60.0f)];
//                 //顶一个有刷新图标的view
//            UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130.0f, 0.0f, 60.0f, 60.0f)];activity.color = [UIColor redColor];
//             [activity startAnimating];//启动有刷新图标的view
//             footSpinnerView.backgroundColor = [UIColor grayColor];
//             [footSpinnerView addSubview:activity];
//                //设置footerview
//             self.tableView.tableFooterView = footSpinnerView;
//             //   self.myTableView.tableHeaderView = footSpinnerView;
//             dispatch_queue_t queue = dispatch_queue_create("my queue", nil);
//            //添加完数据就重新加载数据
//            dispatch_async(queue, ^(void) {
//                       sleep(2);
//                        dispatch_sync(dispatch_get_main_queue(), ^(void){
//                            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//                                //如果数据是通过网络请求获得，在此处再次获取数据
//                                
//                                //先将之前的数据移除掉
//                                [self.scopeArray removeAllObjects];
//                                
//                                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                                    [self.scopeArray getMessageWithCount:10 Page:1 completionHandle:^(NSString *success, NSArray *message) {
//                                        if ([success isEqualToString:@"0"]) {
//                                            self.messages = [NSMutableArray arrayWithArray:message];
//                                            [self.tableView reloadData];
//                                        }else{
//                                            NSLog(@"失败");
//                                        }
//                                    }];
//                                    //通知主线程更新UI界面
//                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                        [self.tableView reloadData];
//                                    });
//                                });
//                                //结束刷新
//                                [self.tableView.mj_header endRefreshing];
//                            }];
//                            [self.tableView reloadData];
//                        });
//                   });
//         }
//        else
//             {
//                     self.tableView.tableFooterView = nil;
//                     self.tableView.tableHeaderView = nil;
//                }
//}
//

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
