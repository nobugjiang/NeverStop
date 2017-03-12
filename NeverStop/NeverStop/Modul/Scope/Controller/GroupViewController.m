//
//  GroupViewController.m
//  NeverStop
//
//  Created by dllo on 16/10/31.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "GroupViewController.h"
#import "Group.h"
#import "Scope.h"
#import "Info.h"
#import "LocationModel.h"

#import <QuartzCore/QuartzCore.h>

@interface GroupViewController ()
@property (nonatomic, strong) NSMutableArray *groupArray;
@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.groupArray = [NSMutableArray array];
    //[self AnotherJX];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 130);
    imageView.backgroundColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_scModel.info.background_image_url]];
    [self.view addSubview:imageView];
    
    
    
    
    UIImageView *userImageView = [[UIImageView alloc] init];
    [userImageView sd_setImageWithURL:[NSURL URLWithString:_scModel.info.icon_image_url]];
    userImageView.frame = CGRectMake(30, 75, 85, 85);
    //userImageView.backgroundColor = [UIColor whiteColor];
    [userImageView.layer setBorderWidth:4];
    userImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    userImageView.layer.cornerRadius = 10;
    userImageView.clipsToBounds = YES;
    [self.view addSubview:userImageView];
    
    
    
    
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(30, userImageView.y + userImageView.height + 20, 300,40);
    titleLabel.text = _scModel.info.display_name;
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    UILabel *userContLabel = [[UILabel alloc] init];
    userContLabel.frame = CGRectMake(40, titleLabel.y + 40, 40, 20);
    userContLabel.text = [NSString stringWithFormat:@"%@", _scModel.info.user_count];
    userContLabel.font = [UIFont systemFontOfSize:12];
    userContLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:userContLabel];
    
    UIImageView *addressImageView = [[UIImageView alloc] init];
    addressImageView.frame = CGRectMake(25, userContLabel.y + 5, 10, 10);
    addressImageView.image = [UIImage imageNamed:@"mmm"];
    [self.view addSubview:addressImageView];

    
    UIImageView *userContImageView = [[UIImageView alloc] init];
    userContImageView.frame = CGRectMake(75, userContLabel.y + 6, 8, 10);
    userContImageView.image = [UIImage imageNamed:@"dw"];
    [self.view addSubview:userContImageView];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.frame = CGRectMake(90, userContLabel.y, 300, 20);
    addressLabel.text = _scModel.location.display_name;
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:addressLabel];

    
    UIButton *goButton = [[UIButton alloc] init];
    goButton.frame = CGRectMake(SCREEN_WIDTH - 120, 190, 100, 40);
    [goButton.layer setBorderWidth:1];//设置边界的宽度
    goButton.layer.borderColor = [[UIColor orangeColor] CGColor];
    [goButton setTitle:@"加入" forState:UIControlStateNormal];
    [goButton setTitleColor:[UIColor orangeColor]forState:UIControlStateNormal];
    goButton.layer.cornerRadius = 5;
    goButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:goButton];
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.frame = CGRectMake(20, 330, SCREEN_WIDTH - 40, 100);
    contentLabel.text = _scModel.info.content;
    //contentLabel.backgroundColor = [UIColor grayColor];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.numberOfLines = 0;
    [contentLabel sizeToFit];
    [self.view addSubview:contentLabel];
    
    
    
    
    UIButton *gogoButton = [[UIButton alloc] init];
    gogoButton.frame = CGRectMake(75, contentLabel.y + contentLabel.height + 30, SCREEN_WIDTH - 150, 40);
    gogoButton.backgroundColor = [UIColor orangeColor];
    [gogoButton setTitle:@"加入群组" forState:UIControlStateNormal];

    [gogoButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    gogoButton.layer.cornerRadius = 20;
    [self.view addSubview:gogoButton];
}




- (void)AnotherJX{
    
    NSString *tring = @"http://api.dongdong17.com/dongdong/ios/api/v7/groups/10674310";
    
    [HttpClient GET:tring body:nil headerFile:@{@"Authorization" : @"Pacer tFyDfkQNbYsfCzNe4kriA%2BL5xEU%3D"} response:JYX_JSON success:^(id result) {
        
        NSArray *array = [result objectForKey:@"group"];
        
        for (NSDictionary *dic in array) {
            Group *groupModel = [Group mj_objectWithKeyValues:dic];
            [_groupArray addObject:groupModel];
            NSLog(@"%@",_groupArray);
        }
        
        
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
