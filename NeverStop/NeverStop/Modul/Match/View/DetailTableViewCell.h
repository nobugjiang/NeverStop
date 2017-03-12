//
//  DetailTableViewCell.h
//  NeverStop
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Detail.h"
@interface DetailTableViewCell : UITableViewCell
@property (nonatomic, strong) Detail *detail;
// 头像
@property (nonatomic, strong) UIImageView *userPic;
// 名字
@property (nonatomic, strong) UILabel *nameLabel;
// 时间
@property (nonatomic, assign) NSNumber *time;
// 内容
@property (nonatomic, strong) UILabel *content;
@end
