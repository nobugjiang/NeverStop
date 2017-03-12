//
//  RecordTableViewCell.h
//  NeverStop
//
//  Created by Jiang on 16/11/8.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExerciseDataView;
@interface RecordTableViewCell : UITableViewCell
@property (nonatomic, strong) ExerciseDataView *leftDataView;
@property (nonatomic, strong) ExerciseDataView *rightDataView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@end
