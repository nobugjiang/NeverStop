//
//  AimSettingPickerView.h
//  NeverStop
//
//  Created by Jiang on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "JiangPickerView.h"
NS_ASSUME_NONNULL_BEGIN
@class AimSettingPickerView;
@protocol AimSettingPickerViewDelegate <NSObject>

- (void)aimSettingPicker:(AimSettingPickerView *)aimSettingPicker setting:(NSString *)setting viewForRow:(NSInteger)row forChildRow:(NSInteger)childRow;

@end


@interface AimSettingPickerView : JiangPickerView
@property (nonatomic, assign)CGFloat heightPickerComponent;
@property(nonatomic, weak)id <AimSettingPickerViewDelegate>delegate;

@end
NS_ASSUME_NONNULL_END