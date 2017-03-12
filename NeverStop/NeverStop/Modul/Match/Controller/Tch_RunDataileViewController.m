//
//  Tch_RunDataileViewController.m
//  NeverStop
//
//  Created by dllo on 16/10/29.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "Tch_RunDataileViewController.h"
#import "TCH_Run.h"
@interface Tch_RunDataileViewController ()

@end

@implementation Tch_RunDataileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    NSURL *url = [NSURL URLWithString:_runModel.article_url];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 125);
    [self.view addSubview:webView];
    [webView loadRequest:request];
    
    
    
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
