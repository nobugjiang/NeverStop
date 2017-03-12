//
//  OthersViewController.m
//  NeverStop
//
//  Created by DYQ on 16/11/1.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "OthersViewController.h"
#import "TargetViewController.h"
#import "AboutViewController.h"

@interface OthersViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *othersTableView;
@property (nonatomic, strong) UILabel *cachesLabel;
//@property (nonatomic, assign) CGFloat folderSize;


@end

@implementation OthersViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationController.navigationBar.translucent = NO;
    self.cachesLabel.text = [NSString stringWithFormat:@"%.2fM", [self folderSize]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    UIBarButtonItem *backItem = [UIBarButtonItem getBarButtonItemWithImageName:@"navigator_btn_back" HighLightedImageName:nil targetBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.leftBarButtonItem = backItem;
    // Do any additional setup after loading the view.
    
    [self createOthersTableView];
    
}

- (void)createOthersTableView {
    self.othersTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _othersTableView.delegate = self;
    _othersTableView.dataSource = self;
    [self.view addSubview:_othersTableView];
    
    self.cachesLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 47, 80, 40)];
    _cachesLabel.textAlignment = NSTextAlignmentRight;
    _cachesLabel.textColor = [UIColor lightGrayColor];
    _cachesLabel.font = kFONT_SIZE_15;
    [self.othersTableView addSubview:_cachesLabel];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
// 计算缓存
- (CGFloat)folderSize{
    
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    CGFloat folderSize;
    
//    dispatch_async(globalQueue, ^{
        //获取路径
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
        
        //获取所有文件的数组
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
        
        for(NSString *path in files) {
            
            NSString*filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
            
            //累加
            folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
        }
    
//    });

    //转换为M为单位
    CGFloat sizeM = folderSize / 1024.0 / 1024.0;
    
    return sizeM;
}

// 清除缓存
- (void)removeCache{
    //===============清除缓存==============
    //获取路径
    NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    //返回路径中的文件数组
    NSArray*files = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",[files count]);
    for(NSString *p in files){
        NSError*error;
        
        NSString*path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        
        if([[NSFileManager defaultManager]fileExistsAtPath:path])
        {
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if(isRemove) {
                _cachesLabel.text = [NSString stringWithFormat:@"%.2fM", [self folderSize]];
            }else{
                NSLog(@"清除失败");
            } 
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"手机计步";
            break;
        case 1:
            cell.textLabel.text = @"清除缓存";
            break;
        case 2:
            cell.textLabel.text = @"关于NeverStop";
            break;
        default:
            break;
    }
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            TargetViewController *targetVC = [[TargetViewController alloc] init];
            [self.navigationController pushViewController:targetVC animated:YES];
        }
            break;
        case 1:{
            [self removeCache];
        }
            break;
        case 2:{
            AboutViewController *aboutVC = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
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
