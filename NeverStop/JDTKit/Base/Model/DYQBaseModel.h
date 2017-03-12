//
//  DYQBaseModel.h
//  DYQ_One
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface DYQBaseModel : NSObject
/**
 *  基类初始化方法
 *
 *  @param dic model对应的字典
 *
 *  @return
 */
- (instancetype)initWithDic:(NSDictionary *)dic;
/**
 *  基类构造器方法
 *
 *  @param dic model对应的字典
 *
 *  @return
 */
+ (instancetype)modelWithDic:(NSDictionary *)dic;
@end
NS_ASSUME_NONNULL_END
