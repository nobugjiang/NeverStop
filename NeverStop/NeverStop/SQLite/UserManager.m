//
//  UserManager.m
//  NeverStop
//
//  Created by DYQ on 16/10/31.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "UserManager.h"
#import <sqlite3.h>
#import "UserModel.h"

@implementation UserManager {
    sqlite3 *dbPointer;
}


+ (UserManager *)shareUserManager {
   static UserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserManager alloc] init];
    });
    return manager;
}

- (BOOL)openSQLite {
    if (dbPointer != nil) {
        return YES;
    }
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *stepDBPath = [documentsPath stringByAppendingPathComponent:@"User.db"];
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
    NSString *createTableSQL = @"create table if not exists User (user_id integer primary key autoincrement, name text not null unique, secret text not null, age text, tall text not null, weight text not null)";
        
    char *error = NULL;
    int result = sqlite3_exec(dbPointer, [createTableSQL UTF8String], NULL, NULL, &error);
    [self logErrorMessage:error];
    return [self isSuccessWithResult:result alert:@"创建表"];

}

- (BOOL)insertIntoWithUserName:(NSString *)name secret:(NSString *)secret age:(NSString *)age tall:(NSString *)tall weight:(NSString *)weight {
    NSString *insertSQL = [NSString stringWithFormat:@"insert into User values (null, '%@', '%@', '%@', '%@', '%@')", name, secret, age, tall, weight];
    char *error = NULL;
    
    int result = sqlite3_exec(dbPointer, [insertSQL UTF8String], NULL, NULL, &error);
    [self logErrorMessage:error];
    return [self isSuccessWithResult:result alert:@"插入"];

}

- (BOOL)deleteUserWithName:(NSString *)name {
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from User where name = '%@'",name];
    
    char *error = NULL;
    int result = sqlite3_exec(dbPointer, [deleteSQL UTF8String], NULL, NULL, &error);
    [self logErrorMessage:error];
    return [self isSuccessWithResult:result alert:@"删除"];

}

- (BOOL)updateUserInfoWithID:(NSInteger)ID name:(NSString *)name secret:(NSString *)secret age:(NSString *)age tall:(NSString *)tall weight:(NSString *)weight {
    NSString *updateSQL = [NSString stringWithFormat:@"update User set name = '%@', secret = '%@', age = '%@', tall = '%@', weight = '%@' where user_id = %ld", name, secret, age, tall, weight, ID];
    char *error = NULL;
    int result = sqlite3_exec(dbPointer, [updateSQL UTF8String], NULL, NULL, &error);
    [self logErrorMessage:error];
    return [self isSuccessWithResult:result alert:@"更新"];

}

- (UserModel *)selectUser {
    NSString *selectSQL = [NSString stringWithFormat:@"select * from User"];
    
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare(dbPointer, [selectSQL UTF8String], -1, &stmt, NULL);
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (result == SQLITE_OK) {
        // sqlite3_step(stmt) 等于 SQLITE_ROW 代表有数据  等于 SQLITE_DONE代表已经没有其他数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            // 获取第0列数据 (ID)
            NSInteger user_id = sqlite3_column_int(stmt, 0);
            // 获取第1列数据 (name)
            const unsigned char *name =  sqlite3_column_text(stmt, 1);
            // 获取第2列数据 (secret)
            const unsigned char *secret = sqlite3_column_text(stmt, 2);
            // 获取第3列数据 (age)
            const unsigned char *age = sqlite3_column_text(stmt, 3);
            // 获取第4列数据 (tall)
            const unsigned char *tall = sqlite3_column_text(stmt, 4);
            // 获取第5列数据 (weight)
            const unsigned char *weight = sqlite3_column_text(stmt, 5);
            
            UserModel *userModel = [[UserModel alloc] init];
            userModel.user_id = user_id;
            userModel.name = [NSString stringWithUTF8String:(const char *)name];
            userModel.secret = [NSString stringWithUTF8String:(const char *)secret];
            userModel.age = [NSString stringWithUTF8String:(const char *)age];
            userModel.tall = [NSString stringWithUTF8String:(const char *)tall];
            userModel.weight = [NSString stringWithUTF8String:(const char *)weight];
            [array addObject:userModel];
        }
    }
    // 销毁替身
    sqlite3_finalize(stmt);
    return [array lastObject];
    

}

- (void)logErrorMessage:(char *)error {
    if (error != NULL) {
        DDLogError(@"error : %s", error);
    }
}

- (BOOL)isSuccessWithResult:(int)result alert:(NSString *)alertString {
    if (result == SQLITE_OK) {
        DDLogInfo(@"%@成功", alertString);
        return YES;
    }
    DDLogInfo(@"%@失败", alertString);
    return NO;
    
}

@end
