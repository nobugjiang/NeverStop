//
//  SQLiteDatabaseManager.h
//  NeverStop
//
//  Created by DYQ on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StepCountModel;

@interface SQLiteDatabaseManager : NSObject

// 单例方法
+ (SQLiteDatabaseManager *)shareManager;

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
 插入对象

 @param stepCountModel 计步对象

 @return 是否插入成功
 */
- (BOOL)insertIntoWithStepCountModel:(NSString *)date;


/**
 更新

 @param StepCount 步数
 @param date      日期

 @return 是否更新成功
 */
- (BOOL)updateStepCount:(NSString *)StepCount date:(NSString *)date;


/**
 查询

 @param date 日期

 @return Model
 */
- (StepCountModel *)selectStepCountWithDate:(NSString *)date;


/**
 删除

 @param Date 日期

 @return 是否删除成功
 */
- (BOOL)deleteStepCountWithDate:(NSString *)Date;

@end
