//
//  CaloriePickerView.h
//  NeverStop
//
//  Created by Jiang on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "JiangPickerView.h"


@class CaloriePickerView;

@protocol CaloriePickerViewDelegate <NSObject>

- (void)caloriePicker:(CaloriePickerView *)caloriePicker selected:(NSString *)selected;

@end
@interface CaloriePickerView : JiangPickerView
/** 1.设置字符串数据数组 */
@property (nonatomic, strong)NSMutableArray<NSString *> *arrayData;
/** 2.设置单位标题 */
@property (nonatomic, strong)NSString *titleUnit;
/** 3.中间选择框的高度，default is 44*/
@property (nonatomic, assign)CGFloat heightPickerComponent;
/** 4.中间选择框的宽度，default is 32*/
@property (nonatomic, assign)CGFloat widthPickerComponent;
@property(nonatomic, weak)id <CaloriePickerViewDelegate>delegate;

@end
