//
//  AboutViewController.m
//  NeverStop
//
//  Created by DYQ on 16/11/1.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
}

- (void)createView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 5 + 10)];
    backView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:backView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, SCREEN_HEIGHT / 5)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImageView];
    
    UILabel *editionLabel = [[UILabel alloc] initWithFrame:CGRectMake((logoImageView.width - 100) / 2, logoImageView.height - 25, 100, 20)];
    editionLabel.text = @"v1.0.0";
    editionLabel.textAlignment = NSTextAlignmentCenter;
    [logoImageView addSubview:editionLabel];
    
    UILabel *aboutUsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, backView.y + backView.height + 30, SCREEN_WIDTH - 100, SCREEN_HEIGHT / 2)];
    aboutUsLabel.text = @"        我们是一群热爱运动热爱生活的年轻人，因为运动，我们的学习、工作充满活力和智慧。\n        没有人天生就是懒惰的，也没有人会享受肥胖带来的一系列麻烦，你以为你坚持不了，只是你还没有发现更好的你。\n        加入Never Stop，让运动变得简单，让你发现最好的你。";
    aboutUsLabel.numberOfLines = 0;
    [aboutUsLabel sizeToFit];
//    aboutUsLabel.font = ;
    [self.view addSubview:aboutUsLabel];
    
    
    
    
    
    
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
