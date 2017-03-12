//
//  CustomPickerView.h
//  NeverStop
//
//  Created by Jiang on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "JiangPickerView.h"
@class CustomPickerView;
@protocol CustomPickerViewDelegate <NSObject>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CustomPickerContentMode) {
    CustomPickerContentModeDistance, // 1.选择器在视图的下方
    CustomPickerContentModeTime  // 2.选择器在视图的中间
};

- (void)customPicker:(CustomPickerView *)customPicker selected:(NSString *)selected childSelected: (NSString *)childSelected viewForRow:(NSInteger)row forChildRow:(NSInteger)childRow;

@end

@interface CustomPickerView : JiangPickerView
@property (nonatomic, assign)CGFloat heightPickerComponent;
@property (nonatomic, assign)CGFloat widthPickerComponent;
@property(nonatomic, weak)id <CustomPickerViewDelegate>delegate;
@property (nonatomic, assign)CustomPickerContentMode cus_ContentMode;
@end
NS_ASSUME_NONNULL_END