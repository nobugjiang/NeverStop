//
//  MatchViewController.m
//  Never Stop
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MatchViewController.h"

#import "TCH_RootViewController.h"
#import "TCH_RunViewController.h"
@interface MatchViewController ()



@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) TCH_RootViewController *rootVC;
@property (nonatomic, strong) TCH_RunViewController *runVC;
@property (nonatomic, strong) UIViewController *currentVC;
@end

@implementation MatchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addSubControllers];
  
    
    NSArray *array = [NSArray arrayWithObjects:@"骑行",@"跑步", nil];
    
    self.segment = [[UISegmentedControl alloc]initWithItems:array];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = _segment;//设置navigation上的titleview
    
    
    
    _segment.frame = CGRectMake(0, 0, 160, 35);

    // 设置默认和颜色
    _segment.selectedSegmentIndex = 0;
    _segment.tintColor = [UIColor colorWithRed:37/255.f green:54/255.f blue:74/255.f alpha:1.0];
  
    [_segment addTarget:self action:@selector(segmentedAction:)forControlEvents:UIControlEventValueChanged];
    
}


- (void)addSubControllers{
    _rootVC = [[TCH_RootViewController alloc]init];
    [self addChildViewController:_rootVC];
    
    _runVC = [[TCH_RunViewController alloc]init];
    [self addChildViewController:_runVC];
    
   
    
    //调整子视图控制器的Frame已适应容器View
//    [self fitFrameForChildViewController:_runVC];
    //设置默认显示在容器View的内容
    [self.view addSubview:_rootVC.view];
    
    
    _currentVC = _rootVC;
}
//- (void)fitFrameForChildViewController:(UIViewController *)childViewController{
//    CGRect frame = self.view.frame;
//    frame.origin.y = 0;
//    childViewController.view.frame = frame;
//}

//转换子视图控制器
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVC = newViewController;
        }else{
            _currentVC = oldViewController;
        }
    }];
}

//移除所有子视图控制器
- (void)removeAllChildViewControllers{
    for (UIViewController *vc in self.childViewControllers) {
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}









- (void)segmentedAction:(NSInteger)index {

            NSInteger Index = _segment.selectedSegmentIndex;
            NSLog(@"Index %ld", Index);
            switch (Index) {
                case 0:
//                    [self fitFrameForChildViewController:_rootVC];
                    [self transitionFromOldViewController:_currentVC toNewViewController:_rootVC];                      break;
                case 1:
//                    [self fitFrameForChildViewController:_runVC];
                    [self transitionFromOldViewController:_currentVC toNewViewController:_runVC];
                    break;
                default:
                    break;
        
    }
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
