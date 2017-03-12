//
//  TargetManager.m
//  NeverStop
//
//  Created by DYQ on 16/11/2.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "TargetManager.h"
#import <sqlite3.h>
#import "TargetModel.h"

@interface TargetManager () {
    sqlite3 *dbPointer;
}


@end

@implementation TargetManager

+ (TargetManager *)shareTargetManager {
    static TargetManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TargetManager alloc] init];
    });
    return manager;
}

- (BOOL)openSQLite {
    if (dbPointer != nil) {
        return YES;
    }
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *stepDBPath = [documentsPath stringByAppendingPathComponent:@"Target.db"];
    NSLog(@"path : %@", stepDBPath);
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
    NSString *createTableSQL = @"create table if not exists Target (id integer primary key autoincrement, target text not null, row integer not null)";
    
    char *error = NULL;
    int result = sqlite3_exec(dbPointer, [createTableSQL UTF8String], NULL, NULL, &error);
    [self logErrorMessage:error];
    return [self isSuccessWithResult:result alert:@"创建表"];
}

- (BOOL)insertIntoTarget:(NSString *)target row:(NSInteger)row {
    NSString *insertSQL = [NSString stringWithFormat:@"insert into Target values (null, '%@', %ld)", target, row];
    char *error = NULL;
    
    int result = sqlite3_exec(dbPointer, [insertSQL UTF8String], NULL, NULL, &error);
    [self logErrorMessage:error];
    return [self isSuccessWithResult:result alert:@"运动目标插入"];
}

//- (BOOL)updateTarget:(NSString *)target row:(NSInteger)row {
//
//
//}

- (NSArray *)selectTarget {
    NSString *selectSQL = @"select * from Target";
    
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare(dbPointer, [selectSQL UTF8String], -1, &stmt, NULL);
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    if (result == SQLITE_OK) {

        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            // 获取第1列数据 (target)
            const unsigned char *target =  sqlite3_column_text(stmt, 1);
            // 获取第2列数据 (row)
            NSInteger row = sqlite3_column_int(stmt, 2);
            
            TargetModel *targetModel = [[TargetModel alloc] init];
            targetModel.target = [NSString stringWithUTF8String:(const char *)target];
            targetModel.row = row;
            
            [resultArray addObject:targetModel];
        }
    }
    // 销毁替身
    sqlite3_finalize(stmt);
    return resultArray;
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
