//
//  CaloriePickerView.m
//  NeverStop
//
//  Created by Jiang on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "CaloriePickerView.h"

@interface CaloriePickerView ()
<
UIPickerViewDataSource,
UIPickerViewDelegate
>
/** 1.选中的字符串 */
@property (nonatomic, strong, nullable)NSString *selectedTitle;
@property (nonatomic, strong) UILabel *calorieLabel;

@end
@implementation CaloriePickerView
#pragma mark - --- init 视图初始化 ---
- (void)setupUI
{
    [super setupUI];
    self.font = kFONT_SIZE_18_BOLD;

    self.arrayData = [NSMutableArray array];
    _titleUnit = @"";
    for (int i = 1; i < 51; i++) {
        [_arrayData addObject:[NSString stringWithFormat:@"%d", i * 100]];
    }
    _heightPickerComponent = 44;
    self.widthPickerComponent = [@"5000" widthWithFont:[UIFont systemFontOfSize:17] constrainedToHeight:self.heightPickerComponent];    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.selectedTitle = _arrayData[0];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + _widthPickerComponent / 2 + 10, SCREEN_HEIGHT - 120, 40, 44)];
    label.text = @"大卡";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kFONT_SIZE_18_BOLD;
    label.textColor = [UIColor blackColor];
    label.layer.shadowColor = [[UIColor whiteColor] CGColor];
    label.layer.shadowOpacity = 0.5;
    label.layer.shadowRadius = 5;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    
}

#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

        return self.arrayData.count;

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
        return self.widthPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedTitle = self.arrayData[row];

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kFONT_SIZE_18_BOLD;
    label.text = self.arrayData[row];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    NSString *selectTitle = [NSString stringWithFormat:@"%@", self.selectedTitle];
    [self.delegate caloriePicker:self selected:selectTitle];
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

#pragma mark - --- setters 属性 ---

- (void)setArrayData:(NSMutableArray<NSString *> *)arrayData
{
    _arrayData = arrayData;
    _selectedTitle = arrayData.firstObject;
    [self.pickerView reloadAllComponents];
}

- (void)setTitleUnit:(NSString *)titleUnit
{
    _titleUnit = titleUnit;
    [self.pickerView reloadAllComponents];
}



@end
