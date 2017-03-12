//
//  Info.h
//  NeverStop
//
//  Created by dllo on 16/10/29.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "DYQBaseModel.h"

@interface Info : DYQBaseModel
// 标题
@property (nonatomic, strong) NSString *display_name;
// 内容
@property (nonatomic, strong) NSString *content;

// 人数
@property (nonatomic, strong) NSNumber *user_count;
// 头像
@property (nonatomic, strong) NSString *icon_image_url;
//二级界面背景图
@property (nonatomic, strong) NSString *background_image_url;
@property (nonatomic, strong) NSString *id;
@end
