//
//  TCH_RunTableViewCell.h
//  NeverStop
//
//  Created by dllo on 16/10/28.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCH_Run.h"
@interface TCH_RunTableViewCell : UITableViewCell
@property (nonatomic, strong) TCH_Run *tchRun;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *sub;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) NSString *url;
@end
