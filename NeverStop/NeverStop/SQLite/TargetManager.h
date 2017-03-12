//
//  TargetManager.h
//  NeverStop
//
//  Created by DYQ on 16/11/2.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetManager : NSObject

// 单例方法
+ (TargetManager *)shareTargetManager;

/**
 *  打开数据库
 *
 *  @return 是否打开成功
 */
- (BOOL)openSQLite;
/**
 *  关闭数据库
 *
 *  @return 是否关闭成功
 */
- (BOOL)closeSQLite;

/**
 *  创建一张表
 *
 *  @return 是否创建成功
 */
- (BOOL)createTable;


/**
 插入

 @param row 选择器的行数

 @return 是否插入成功
 */
- (BOOL)insertIntoTarget:(NSString *)target row:(NSInteger)row;

/**
 更新

 @param target 运动目标
 @param row    选择器行数

 @return 是否更新成功
 */
//- (BOOL)updateTarget:(NSString *)target row:(NSInteger)row;



/**
 查询

 @return 运动目标数组
 */
- (NSArray *)selectTarget;





@end
