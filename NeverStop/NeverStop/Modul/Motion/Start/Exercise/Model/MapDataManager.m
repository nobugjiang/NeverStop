//
//  MapDataManager.m
//  NeverStop
//
//  Created by Jiang on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MapDataManager.h"
#import "ExerciseData.h"
#import "Location.h"
@interface MapDataManager ()
@property(nonatomic,strong)FMDatabaseQueue *myQueue;//保证线程安全的数据库

@end

@implementation MapDataManager
+ (MapDataManager *)shareDataManager {
    static MapDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MapDataManager alloc] init];
    });
    return manager;
}
//打开数据库
- (void)openDB{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSLog(@"%@",path);
    NSString *dataPath = [path stringByAppendingPathComponent:@"ExerciseData.sqlite"];
    
    
    //获取数据库的路径     //这是考虑钱的时候,如同时注册   不管几个线程访问他,他会自己安排顺序
    self.myQueue = [FMDatabaseQueue databaseQueueWithPath:dataPath];
    
    [self.myQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db open];
        if (result) {
            NSLog(@"数据库打开成功");
        }else{
            
            NSLog(@"数据库打开失败");
            
        }
        
    }];
    
}

//创建表
- (void)createTable{
    
    [self.myQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:@"create table if not exists ExerciseData (exercise_id integer primary key autoincrement, exerciseType text not null, count integer, distance real, duration real, speedPerHour real, averageSpeed real, maxSpeed real,calorie real, aim text not null, aimType integer, startTime text not null, isComplete integer,speedSetting real, averageSpeedSetting real)"];
        BOOL resultChild = [db executeUpdate:@"create table if not exists AllLocationArray (location_id integer primary key, longitude real, latitude real, currentSpeed real, isStart integer, exercise_id integer)"];
        if (result && resultChild) {
            
            NSLog(@"创建成功");
            
        }else{
            
            NSLog(@"创建失败");
        }
    }];
}


//插入数据
- (void)insertExerciseData:(ExerciseData *)exerciseData {
//    NSError *error = nil;
    NSString *sql = [NSString stringWithFormat:@"insert into ExerciseData values (null, '%@', %ld, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f, '%@', %ld, '%@', %d, %.2f, %.2f)", exerciseData.exerciseType, exerciseData.count, exerciseData.distance, exerciseData.duration, exerciseData.speedPerHour, exerciseData.averageSpeed, exerciseData.maxSpeed, exerciseData.calorie, exerciseData.aim, exerciseData.aimType, exerciseData.startTime, exerciseData.isComplete, exerciseData.speedSetting, exerciseData.averageSpeedSetting];
    

    [self.myQueue inDatabase:^(FMDatabase *db) {
        
        BOOL result = [db executeUpdate:sql];
        NSInteger ID = db.lastInsertRowId;
        
        for (int i = 0; i < exerciseData.count; i++ ) {
            Location *location = exerciseData.allLocationArray[i];
            NSString *sqlChild = [NSString stringWithFormat:@"insert into AllLocationArray values (null, %f, %f, %f,%d, %ld)", location.longitude, location.latitude, location.currentSpeed,location.isStart, ID];
            BOOL resultChild = [db executeUpdate:sqlChild];
            NSLog(@"++++++%d",resultChild);
        }
        NSLog(@"------%d",result);
        if (result) {
            
            NSLog(@"插入成功");
            
        }else{
            
            NSLog(@"插入失败");
        }
    }];
    
    
}
- (void)deleteExerciseData {
    
    NSString *sql = [NSString stringWithFormat:@"delete from ExerciseData"];
    NSString *sql1 = [NSString stringWithFormat:@"delete from AllLocationArray"];

    [self.myQueue inDatabase:^(FMDatabase *db) {
        
        BOOL result = [db executeUpdate:sql];
        BOOL result1 = [db executeUpdate:sql1];

        //        NSLog(@"------%d",result);
        
        if (result && result1) {
            
            NSLog(@"删除成功");
            
        }else{
            
            NSLog(@"删除失败");
        }
    }];
    
}


//查询
- (NSMutableArray *)selectAll {
    
    NSMutableArray *array = [NSMutableArray array];
    [self.myQueue inDatabase:^(FMDatabase *db) {
        int a = 1;
        
        NSString *sql = @"select* from ExerciseData";
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            
            
            
            ExerciseData *exerciseData = [[ExerciseData alloc] init];
            exerciseData.exerciseType = [result objectForColumnName:@"exerciseType"];
            
            exerciseData.count = [result intForColumn:@"count"];
            exerciseData.distance = [result doubleForColumn:@"distance"];
            exerciseData.duration = [result doubleForColumn:@"duration"];
            exerciseData.speedPerHour = [result doubleForColumn:@"speedPerHour"];
            exerciseData.averageSpeed = [result doubleForColumn:@"averageSpeed"];
            exerciseData.maxSpeed = [result doubleForColumn:@"maxSpeed"];
            exerciseData.calorie = [result doubleForColumn:@"calorie"];
            exerciseData.aim = [result objectForColumnName:@"aim"];
            exerciseData.aimType = [result intForColumn:@"aimType"];
            exerciseData.startTime = [result objectForColumnName:@"startTime"];
            exerciseData.isComplete = [result intForColumn:@"isComplete"];
            exerciseData.speedSetting = [result doubleForColumn:@"speedSetting"];
            exerciseData.averageSpeedSetting = [result doubleForColumn:@"averageSpeedSetting"];
            NSString *sqlChild = [NSString stringWithFormat:@"select *from AllLocationArray where exercise_id = %d", a];
            FMResultSet *resultChild = [db executeQuery:sqlChild];
            while ([resultChild next]) {
                Location *location = [[Location alloc] init];
                location.longitude = [resultChild doubleForColumn:@"longitude"];
                location.latitude = [resultChild doubleForColumn:@"latitude"];
                NSInteger yesOrNo = [resultChild intForColumn:@"isStart"];
                if (yesOrNo == 0) {
                    location.isStart = NO;
                } else {
                    location.isStart = YES;
                }
                [exerciseData.allLocationArray addObject:location];
            }
            a++;
            [array addObject:exerciseData];
        }
        [db close];
        
    }];
    
    return array;
}



@end
