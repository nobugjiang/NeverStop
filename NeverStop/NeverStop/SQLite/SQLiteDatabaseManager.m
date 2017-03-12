//
//  SQLiteDatabaseManager.m
//  NeverStop
//
//  Created by DYQ on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "SQLiteDatabaseManager.h"
#import <sqlite3.h>
#import "StepCountModel.h"

@interface SQLiteDatabaseManager () {
    sqlite3 *dbPointer;
}


@end

@implementation SQLiteDatabaseManager
// 单例方法
+ (SQLiteDatabaseManager *)shareManager {
    static SQLiteDatabaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SQLiteDatabaseManager alloc] init];
    });
    return manager;
}
- (BOOL)openSQLite {
    
    if (dbPointer != nil) {
        return YES;
    }
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *stepDBPath = [documentsPath stringByAppendingPathComponent:@"StepCount.db"];
//    NSLog(@"path : %@", stepDBPath);
    // 打开数据库(如果没有就先创建,后打开,如果有,就直接打开)
    // 参数1:数据库文件路径
    // 参数2:数据库指针地址
    
    // studentDBPath UTF8String   OC字符串转C字符串
    int result = sqlite3_open([stepDBPath UTF8String], &dbPointer);
    
    
    return [self isSuccessWithResult:result alert:@"打开数据库"];
    
}
- (BOOL)closeSQLite {
    int result = sqlite3_close(dbPointer);
    dbPointer = nil;
    
    return [self isSuccessWithResult:result alert:@"关闭数据库"];
}
- (BOOL)createTable {
    // 创建 : create table 表名 (字段1名 类型 约束, ......)
    // primary key:主键,只能是唯一的,不存在重复出现的情况,不推荐主动存,推荐计算机生成
    // autoincrement:自增
    // not null:不为空
    NSString *createTableSQL = @"create table if not exists StepCount (id integer primary key autoincrement, date text not null unique, stepCount integer)";
    // 执行SQL语句
    // 参数1 : 数据库指针
    // 参数2 : 执行的SQL语句
    // 参数3 : 回调函数
    // 参数4 : 回调函数的参数
    // 参数5 : 错误信息
    
    char *error = NULL;
    int result = sqlite3_exec(dbPointer, [createTableSQL UTF8String], NULL, NULL, &error);
    [self logErrorMessage:error];
    return [self isSuccessWithResult:result alert:@"创建表"];
}

- (BOOL)insertIntoWithStepCountModel:(NSString *)date {
    NSString *insertSQL = [NSString stringWithFormat:@"insert into StepCount values (null, '%@', '0')", date];
    char *error = NULL;
    
    int result = sqlite3_exec(dbPointer, [insertSQL UTF8String], NULL, NULL, &error);
    [self logErrorMessage:error];
    return [self isSuccessWithResult:result alert:@"插入"];

}

- (BOOL)updateStepCount:(NSString *)StepCount date:(NSString *)date {
    NSString *updateSQL = [NSString stringWithFormat:@"update StepCount set stepCount = '%@' where date = '%@'", StepCount, date];
    char *error = NULL;
    int result = sqlite3_exec(dbPointer, [updateSQL UTF8String], NULL, NULL, &error);
    [self logErrorMessage:error];
    return [self isSuccessWithResult:result alert:@"更新"];
}

- (StepCountModel *)selectStepCountWithDate:(NSString *)date {
    
    NSString *selectSQL = [NSString stringWithFormat:@"select * from StepCount where date = '%@'", date];
    
    // 准备执行SQL
    // 参数1:数据库指针
    // 参数2:SQL语句
    // 参数3:约束SQL语句长度(-1代表从头读到尾)
    // 参数4:数据库替身指针
    // 参数5:超出SQL语句约束长度的部分存储的指针
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare(dbPointer, [selectSQL UTF8String], -1, &stmt, NULL);
    
//    NSMutableArray *resultArray = [NSMutableArray array];
    StepCountModel *stepCountModel = [[StepCountModel alloc] init];
    
    if (result == SQLITE_OK) {
        // sqlite3_step(stmt) 等于 SQLITE_ROW 代表有数据  等于 SQLITE_DONE代表已经没有其他数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            // 获取第1列数据 (date)
            const unsigned char *date =  sqlite3_column_text(stmt, 1);
            // 获取第2列数据 (stepCount)
            const unsigned char *stepCount = sqlite3_column_text(stmt, 2);
            
            stepCountModel.date = [NSString stringWithUTF8String:(const char *)date];
            stepCountModel.stepCount = [NSString stringWithUTF8String:(const char *)stepCount];
//            [resultArray addObject:step];
        }
    }
    // 销毁替身
    sqlite3_finalize(stmt);
    return stepCountModel;

}

- (BOOL)deleteStepCountWithDate:(NSString *)Date {
    // 删除
    // 删除表里所有数据 : delete from 表名
    // 如果删除固定条件数据需要使用where
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from StepCount where date = '%@'",Date];
    
    char *error = NULL;
    int result = sqlite3_exec(dbPointer, [deleteSQL UTF8String], NULL, NULL, &error);
    [self logErrorMessage:error];
    return [self isSuccessWithResult:result alert:@"删除"];

}

- (void)logErrorMessage:(char *)error {
    if (error != NULL) {
        NSLog(@"error : %s", error);
    }
}

- (BOOL)isSuccessWithResult:(int)result alert:(NSString *)alertString {
    if (result == SQLITE_OK) {
        NSLog(@"%@成功", alertString);
        return YES;
    }
    NSLog(@"%@失败", alertString);
    return NO;
    
}


@end
