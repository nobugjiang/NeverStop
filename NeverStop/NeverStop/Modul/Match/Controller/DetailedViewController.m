//
//  DetailedViewController.m
//  NeverStop
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//
// 骑行下属的路线页面的子页面
#import "DetailedViewController.h"
#import "Detail.h"
#import "Route.h"
#import "DetailTableViewCell.h"
@interface DetailedViewController ()
<
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *deArray;
@property (nonatomic, strong) UITableView *detaTableView;
@property (nonatomic, strong) Detail *detail;
@end

@implementation DetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self DetaileScrollView];
    [self DetaileJX];
   [self DetailTableView];
    self.deArray = [NSMutableArray array];
    
    self.imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, -280,SCREEN_WIDTH , 200);
    _imageView.backgroundColor = [UIColor blackColor];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_roModel.image]];
    [_detaTableView addSubview:_imageView];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(15, -315, SCREEN_WIDTH, 20);
    contentLabel.text = _roModel.title;
    [_detaTableView addSubview:contentLabel];
    UILabel *distanceLabel = [[UILabel alloc] init];
    distanceLabel.frame = CGRectMake(16, -300, SCREEN_WIDTH, 20);
    distanceLabel.text = [NSString stringWithFormat:@"%@m", _roModel.distance];
    distanceLabel.font = [UIFont systemFontOfSize:10];
    [_detaTableView addSubview:distanceLabel];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _imageView.y + _imageView.height , SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [_detaTableView addSubview:view];
    UIImageView *userImageView = [[UIImageView alloc] init];
    [userImageView sd_setImageWithURL:[NSURL URLWithString:_roModel.user_pic]];
    userImageView.frame = CGRectMake(10, 10, 35, 35);
    [view addSubview:userImageView];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(55, 10, SCREEN_WIDTH, 20);
    nameLabel.text = _roModel.user_name;
    [view addSubview:nameLabel];
    UILabel *desc =[[UILabel alloc] init];
    desc.frame = CGRectMake(55, 27, SCREEN_WIDTH - 65, 20);
    desc.text = _roModel.desc;
    desc.numberOfLines = 0;
    desc.font = [UIFont systemFontOfSize:12];
    [view addSubview:desc];
    UILabel *number = [[UILabel alloc] init];
    number.text = [NSString stringWithFormat:@"%@人评论", _roModel.comment_num];
    number.frame = CGRectMake(SCREEN_WIDTH - 60, view.y + view.height, SCREEN_WIDTH, 30);
    number.font = [UIFont systemFontOfSize:12];
    number.textColor = [UIColor grayColor];
    [_detaTableView addSubview:number];


    
    
}

- (void)DetailTableView {
    self.detaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _detaTableView.backgroundColor = [UIColor whiteColor];
    _detaTableView.rowHeight = 100.f;
    _detaTableView.contentInset = UIEdgeInsetsMake(330, 0, 0, 0);
    _detaTableView.delegate = self;
    _detaTableView.dataSource = self;
    [self.view addSubview:_detaTableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _deArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    Detail *deModel = _deArray[indexPath.row];
    cell.detail = deModel;
    return cell;
}







- (void)DetaileJX {

    
    NSString *detaJx = @"http://www.imxingzhe.com/api/v4/lushu_info?lushu_id=816086&rand=1476844557&type=1&xingzhe_timestamp=1476844557.816226";
    
    [HttpClient GET:detaJx body:nil headerFile:nil response:JYX_JSON success:^(id result) {
        NSArray *deArray = [result objectForKey:@"comment"];
        for (NSDictionary *deDic in deArray) {
                Detail *deModel = [Detail modelWithDic:deDic];
                [_deArray addObject:deModel];
            
        }
        [_detaTableView reloadData];
        
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
