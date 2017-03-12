//
//  TCH_RootViewController.m
//  NeverStop
//
//  Created by dllo on 16/10/29.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "TCH_RootViewController.h"

#import "MatchViewController.h"
#import "RecommendTableViewCell.h"
#import "Recommend.h"
#import "RouteViewController.h"
#import "NearbyTableViewCell.h"
#import "Nearby.h"
#import "NearbyViewController.h"
@interface TCH_RootViewController ()

<
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>
// 主页面
// 推荐的页面
@property (nonatomic, strong) UIScrollView *RSV;
@property (nonatomic, strong) UISegmentedControl *segment;
// 推荐按钮的判断
@property (nonatomic, assign) BOOL REB;
@property (nonatomic, strong) UIButton *recommendButton;
// 附近按钮的判断
@property (nonatomic, assign) BOOL NEB;
@property (nonatomic, strong) UIButton *nearbyButton;
// 推荐的cell数量的数组
@property (nonatomic, strong) NSMutableArray *Array;
// 附近的cell的数组
@property (nonatomic, strong) NSMutableArray *neArray;
// 推荐的tableView
@property (nonatomic, strong) UITableView *reTV;
// 附近的tableView
@property (nonatomic, strong) UITableView *neTV;
// 跑步的tableView
@property (nonatomic, strong) UITableView *runTV;
// 跑步cell的数组
@property (nonatomic, strong) NSMutableArray *tchRunArray;
@property (nonatomic, strong) UIViewController *runViewController;
@property (nonatomic, strong) UIViewController *testVC;
@end

@implementation TCH_RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self recommendScrollView];
    [self button];
    self.REB = NO;
    self.NEB = NO;
    [self recommendTableView];
    [self recommendJX];
    [self nearbyTableView];
    self.Array = [NSMutableArray array];
    self.neArray = [NSMutableArray array];
    [self nearbyJX];
    self.view.backgroundColor = [UIColor whiteColor];



}

// 推荐
- (void)recommendScrollView {
    
    self.RSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 128 - 44)];
    _RSV.scrollsToTop = NO;
    _RSV.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    //    _RSV.directionalLockEnabled = YES;
    _RSV.pagingEnabled = YES;
    //    _RSV.bounces = NO;
    _RSV.backgroundColor = [UIColor whiteColor];
    _RSV.delegate = self;
    [self.view addSubview:_RSV];
    _RSV.showsHorizontalScrollIndicator = YES;
    
}
// 推荐,附近button
- (void)button {
    self.recommendButton = [[UIButton alloc] init];
    _recommendButton.frame = CGRectMake(0, 0, self.view.frame.size.width / 2, 64);
    [_recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
    _recommendButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    [_recommendButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_recommendButton addTarget:self action:@selector(recommendButtonAction)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recommendButton];
    
    self.nearbyButton = [[UIButton alloc] init];
    _nearbyButton.frame = CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, 64);
    [_nearbyButton setTitle:@"附近" forState:UIControlStateNormal];
    _nearbyButton.backgroundColor = [UIColor whiteColor];
    [_nearbyButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];
    
    [_nearbyButton addTarget:self action:@selector(nearbyButtonAction)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nearbyButton];
    
}

// 推荐button的点击方法
- (void)recommendButtonAction {
    _REB = NO;
    if (_REB == NO) {
       
        [_recommendButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        _recommendButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
        
        _nearbyButton.backgroundColor = [UIColor whiteColor];
        [_nearbyButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];
        _REB = YES;
    } else  if (_REB == YES) {
        //_REB = YES;
        _recommendButton.backgroundColor = [UIColor whiteColor];
        [_recommendButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];
        _REB = NO;
    }
    
    _RSV.contentOffset = CGPointMake(0, 0);
    
}
// 附近button的点击方法
- (void)nearbyButtonAction {
    _REB = NO;
    if (_REB == NO) {
        [self nearbyTableView];
        _REB = YES;
        [_nearbyButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        _nearbyButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
        
        _recommendButton.backgroundColor = [UIColor whiteColor];
        [_recommendButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];
        
    } else {
        _REB = NO;
        _nearbyButton.backgroundColor = [UIColor whiteColor];
        [_nearbyButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];
        
    }
    
    _RSV.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    
}



//推荐的tableView
- (void)recommendTableView {
    self.reTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _RSV.height) style:UITableViewStylePlain];
    _reTV.backgroundColor = [UIColor whiteColor];
    _reTV.rowHeight = 155.f;
    _reTV.delegate = self;
    _reTV.dataSource = self;
    [_RSV addSubview:_reTV];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   
        if (_RSV.contentOffset.x == SCREEN_WIDTH) {
            return _neArray.count;
        } else if (_RSV.contentOffset.x == 0) {
            return _Array.count;
        
        }
    return 0;
}
// 联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {

    if (_RSV.contentOffset.x >= SCREEN_WIDTH) {
        _REB = YES;
        [_nearbyButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        _nearbyButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
        
        _recommendButton.backgroundColor = [UIColor whiteColor];
        [_recommendButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];
    } else {
        
        _REB = NO;
        [_recommendButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        _recommendButton.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
        
        _nearbyButton.backgroundColor = [UIColor whiteColor];
        [_nearbyButton setTitleColor:[UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0]forState:UIControlStateNormal];
        
    }

    
    


}







- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        if (_neTV ==  tableView) {
            NearbyTableViewCell *neCell = [tableView dequeueReusableCellWithIdentifier:@"neCell"];
            if (neCell == nil) {
                neCell = [[NearbyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"neCell"];
            }
            Nearby *nearbyModel = _neArray[indexPath.row];
            neCell.nearby = nearbyModel;
            return neCell;
            
        } else  {
            RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[RecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.backgroundColor = [UIColor lightGrayColor];
            Recommend *recommendModel = _Array[indexPath.row];
            cell.recommend = recommendModel;
            return cell;
        }
    return 0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if (_RSV.contentOffset.x == SCREEN_WIDTH) {
            NearbyViewController *NVC = [[NearbyViewController alloc] init];
            Nearby *neModel = _neArray[indexPath.row];
            NVC.neModel = neModel;
            [self.navigationController pushViewController:NVC animated:YES];
        } else if (_RSV.contentOffset.x == 0) {
            RouteViewController *RVC = [[RouteViewController alloc] init];
            [self.navigationController pushViewController:RVC animated:YES];
        }
}


- (void) recommendJX {
    
    NSString *recommendJx = @"http://www.imxingzhe.com/api/v4/collection_list/?lat=38.88268844181218&limit=20&lng=121.5394275381143&page=0&province_id=0&type=0&xingzhe_timestamp=1476843880.032672";
    
    [HttpClient GET:recommendJx body:nil headerFile:nil response:JYX_JSON success:^(id result) {
        
        NSDictionary *Dic = result;
        NSArray *reArray = [Dic objectForKey:@"lushu_collection"];
        for (NSDictionary *reDic in reArray) {
            Recommend *reModel = [Recommend modelWithDic:reDic];
            [_Array addObject : reModel];
        }
        [_reTV reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];
    
}

- (void)nearbyJX {
    
    NSString *nearby = @"http://www.imxingzhe.com/api/v4/lushu_search?lat=38.88267204674046&limit=20&lng=121.5393655619539&page=0&type=3&xingzhe_timestamp=1476844257.990716";
    [HttpClient GET:nearby body:nil headerFile:nil response:JYX_JSON success:^(id result) {
        for (NSDictionary *neDIc in result) {
            Nearby *neModel = [Nearby modelWithDic:neDIc];
            [_neArray addObject:neModel];
        }
        [_neTV reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}



// 附近的tabelView
- (void) nearbyTableView {
    
    self.neTV = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 64 - 44) style:UITableViewStylePlain];
    _neTV.backgroundColor = [UIColor whiteColor];
    _neTV.rowHeight = 160.f;
    _neTV.delegate = self;
    _neTV.dataSource = self;
    [_RSV addSubview:_neTV];
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
