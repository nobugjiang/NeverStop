//
//  TCH_Run.h
//  NeverStop
//
//  Created by dllo on 16/10/28.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "DYQBaseModel.h"

@interface TCH_Run : DYQBaseModel
// 标题
@property (nonatomic, strong) NSString *title;
// 小标题
@property (nonatomic, strong) NSString *sub_title;
// 图片
@property (nonatomic, strong) NSString *cover_img;
// 不知道是啥
@property (nonatomic, strong) NSString *subject_name;
// 进去的图片
@property (nonatomic, strong) NSString *article_url;
@end
