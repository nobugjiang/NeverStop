//
//  MapDataManager.h
//  NeverStop
//
//  Created by Jiang on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ExerciseData;
@interface MapDataManager : NSObject
+ (MapDataManager *)shareDataManager;

- (void)createTable;
- (void)openDB;

- (void)insertExerciseData:(ExerciseData *)exerciseData;


- (void)deleteExerciseData;

- (NSMutableArray *)selectAll;
@end
