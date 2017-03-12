//
//  Recommend.h
//  NeverStop
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//


#import "DYQBaseModel.h"

@interface Recommend : DYQBaseModel
 // 标题
@property (nonatomic, strong) NSString *title;
// 用户名
@property (nonatomic, strong) NSString *user_name;
// 点赞人数
@property (nonatomic, strong) NSNumber *like_count;
// 图片,但是是下载
@property (nonatomic, strong) NSString *pic;


@end
