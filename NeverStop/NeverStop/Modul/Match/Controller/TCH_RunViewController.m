//
//  TCH_RunViewController.m
//  NeverStop
//
//  Created by dllo on 16/10/28.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "TCH_RunViewController.h"
#import "TCH_RunTableViewCell.h"
#import "TCH_Run.h"
#import "Tch_RunDataileViewController.h"
@interface TCH_RunViewController ()

<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *runTV;
@property (nonatomic, strong) NSMutableArray *tchRunArray;
@end

@implementation TCH_RunViewController
- (void)loadView {
    [super loadView];
    _tchRunArray = [NSMutableArray array];
    [self tchRunJx];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self runTableView];
    
}


- (void)runTableView {
    
    self.runTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 34) style:UITableViewStylePlain];
    _runTV.backgroundColor = [UIColor whiteColor];
    _runTV.rowHeight = 100.f;
    _runTV.delegate = self;
    _runTV.dataSource = self;
    [self.view addSubview:_runTV];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCH_RunTableViewCell *tchRunCell = [tableView dequeueReusableCellWithIdentifier:@"tchRunCell"];
    if (tchRunCell == nil) {
        tchRunCell = [[TCH_RunTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tchRunCell"];
    }
    TCH_Run *tchRunModel = _tchRunArray[indexPath.row];
    tchRunCell.tchRun = tchRunModel;
    return tchRunCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _tchRunArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Tch_RunDataileViewController *TCHRDVC = [[Tch_RunDataileViewController alloc] init];
    TCH_Run *tchRunModel = _tchRunArray[indexPath.row];
    TCHRDVC.runModel = tchRunModel;
    [self.navigationController pushViewController:TCHRDVC animated:YES];

}



- (void)tchRunJx {
    
    NSString *tchRun = @"http://media.api.thejoyrun.com/article-list-v1?page=1&pagesize=10&signature=DD2495B087AC1C4363B8EA8A6C6866EE&subject_id=1&timestamp=1477624829";
    [HttpClient GET:tchRun body:nil headerFile:nil response:JYX_JSON success:^(id result) {
        NSArray *aray = [result objectForKey:@"data"];
        for (NSDictionary *dic in aray) {
            TCH_Run *tchRunModel = [TCH_Run modelWithDic:dic];
            [_tchRunArray addObject:tchRunModel];
        }
        [_runTV reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        
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
