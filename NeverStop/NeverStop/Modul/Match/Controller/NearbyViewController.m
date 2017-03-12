//
//  NearbyViewController.m
//  NeverStop
//
//  Created by dllo on 16/10/25.
//  Copyright © 2016年 JDT. All rights reserved.
//


#import "NearbyViewController.h"
#import "Nearby.h"
#import "NearbyDetailedTableViewCell.h"
#import "NearbyDatail.h"
@interface NearbyViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *nearbyArray;
@property (nonatomic, strong) UITableView *netableView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) Nearby *nearby;

@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.nearbyArray = [NSMutableArray array];
    [self nearbyTableView];
    [self nearbyDetaileJX];
    
    self.imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, -280,SCREEN_WIDTH , 200);
    _imageView.backgroundColor = [UIColor whiteColor];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_neModel.image] placeholderImage:[UIImage imageNamed:@"w2.jpg"]];
    [_netableView addSubview:_imageView];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(15, -315, SCREEN_WIDTH, 20);
    contentLabel.text = _neModel.title;
    [_netableView addSubview:contentLabel];
    UILabel *distanceLabel = [[UILabel alloc] init];
    distanceLabel.frame = CGRectMake(16, -300, SCREEN_WIDTH, 20);
    distanceLabel.text = [NSString stringWithFormat:@"%@m", _neModel.distance];
    distanceLabel.font = [UIFont systemFontOfSize:10];
    [_netableView addSubview:distanceLabel];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _imageView.y + _imageView.height , SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [_netableView addSubview:view];
    UIImageView *userImageView = [[UIImageView alloc] init];
    [userImageView sd_setImageWithURL:[NSURL URLWithString:_neModel.user_pic]];
    userImageView.frame = CGRectMake(10, 10, 35, 35);
    [view addSubview:userImageView];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(55, 10, SCREEN_WIDTH, 20);
    nameLabel.text = _neModel.user_name;
    [view addSubview:nameLabel];
    UILabel *desc =[[UILabel alloc] init];
    desc.frame = CGRectMake(55, 27, SCREEN_WIDTH - 65, 20);
    desc.text = _neModel.desc;
    desc.numberOfLines = 0;
    desc.font = [UIFont systemFontOfSize:12];
    [view addSubview:desc];
    UILabel *number = [[UILabel alloc] init];
    number.text = [NSString stringWithFormat:@"%@人评论", _neModel.comment_num];
    number.frame = CGRectMake(SCREEN_WIDTH - 60, view.y + view.height, SCREEN_WIDTH, 30);
    number.font = [UIFont systemFontOfSize:12];
    number.textColor = [UIColor grayColor];
    [_netableView addSubview:number];
    
    
    
}

- (void)nearbyTableView {
    self.netableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _netableView.backgroundColor = [UIColor whiteColor];
    _netableView.rowHeight = 100.f;
    _netableView.contentInset = UIEdgeInsetsMake(330, 0, 0, 0);
    _netableView.delegate = self;
    _netableView.dataSource = self;
    [self.view addSubview:_netableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _nearbyArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearbyDetailedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[NearbyDetailedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    NearbyDatail *NDModel = _nearbyArray[indexPath.row];
    cell.nearbyDetailed = NDModel;
    return cell;
}

- (void)nearbyDetaileJX {
    
    
    NSString *nearbyDetaJx = @"http://www.imxingzhe.com/api/v4/lushu_info?lushu_id=144602&rand=1476845185&type=1&xingzhe_timestamp=1476845185.596367";
    
    [HttpClient GET:nearbyDetaJx body:nil headerFile:nil response:JYX_JSON success:^(id result) {
        NSArray *deArray = [result objectForKey:@"comment"];
        for (NSDictionary *deDic in deArray) {
            NearbyDatail *NDModel = [NearbyDatail modelWithDic:deDic];
            [_nearbyArray addObject:NDModel];
            
        }
        [_netableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"error");
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
