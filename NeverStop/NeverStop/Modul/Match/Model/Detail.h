//
//  Detail.h
//  NeverStop
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "DYQBaseModel.h"

@interface Detail : DYQBaseModel

// 楼主头像
@property (nonatomic, strong) NSString *user_pic;
// 楼主名字
@property (nonatomic, strong) NSString *user_name;
// 时间
@property (nonatomic, assign) NSNumber *time;
// 内容
@property (nonatomic, strong) NSString *content;

@end
