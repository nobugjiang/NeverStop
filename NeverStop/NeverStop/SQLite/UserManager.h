//
//  UserManager.h
//  NeverStop
//
//  Created by DYQ on 16/10/31.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;

@interface UserManager : NSObject

// 单例方法
+ (UserManager *)shareUserManager;

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


- (BOOL)insertIntoWithUserName:(NSString *)name secret:(NSString *)secret age:(NSString *)age tall:(NSString *)tall weight:(NSString *)weight;


- (BOOL)updateUserInfoWithID:(NSInteger)ID name:(NSString *)name secret:(NSString *)secret age:(NSString *)age tall:(NSString *)tall weight:(NSString *)weight;


- (UserModel *)selectUser;


- (BOOL)deleteUserWithName:(NSString *)name;



@end
