//
//  Nearby.h
//  NeverStop
//
//  Created by dllo on 16/10/25.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "DYQBaseModel.h"

@interface Nearby : DYQBaseModel
@property (nonatomic, strong) NSString *title;
// 评论数
@property (nonatomic, strong) NSNumber *comment_num;
// 地图图片
@property (nonatomic, strong) NSString *image;
// 楼主头像
@property (nonatomic, strong) NSString *user_pic;
// 楼主名字
@property (nonatomic, strong) NSString *user_name;
// 距离
@property (nonatomic, strong) NSNumber *distance;

@property (nonatomic, strong) NSString *desc;
@end
