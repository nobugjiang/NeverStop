//
//  AimSettingPickerView.m
//  NeverStop
//
//  Created by Jiang on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "AimSettingPickerView.h"
#import "AimModel.h"

@interface AimSettingPickerView ()
<
UIPickerViewDataSource,
UIPickerViewDelegate
>
@property (nonatomic, strong) NSArray *rootArray;
@property (nonatomic, strong) NSMutableArray *aimArray;
@property (nonatomic, strong) NSMutableArray *settingArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSString *aim;
@property (nonatomic, strong) NSString *setting;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger childRow;
@end
@implementation AimSettingPickerView
#pragma mark - --- init 视图初始化 ---




- (void)setupUI {
    [self.rootArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.aimArray addObject:obj[@"aimName"]];
    }];
    self.font = kFONT_SIZE_18_BOLD;
    
    self.settingArray = [self.rootArray firstObject][@"aimSetting"];
    
    self.aim = self.aimArray[0];
    self.setting = self.settingArray[0];
    
    
    // 2.设置视图的默认属性
    _heightPickerComponent = 32;
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}
#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _aimArray.count;
    }else {
        return _settingArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.settingArray = self.rootArray[row][@"aimSetting"];
        
        [pickerView reloadComponent:1];
        
        self.row = row;
        [pickerView selectRow:1 inComponent:1 animated:YES];
        
    } else {
        self.childRow = row;
    }
    [self reloadData];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    NSString *text;
    if (component == 0) {
        text = _aimArray[row];
    } else {
        self.childRow = 1;
        text = self.settingArray[row];;
    }
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kFONT_SIZE_18_BOLD;
    label.text = text;
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    [self.delegate aimSettingPicker:self setting:self.setting viewForRow:self.row forChildRow:self.childRow];
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
    self.aim = self.aimArray[index0];
    self.setting = self.settingArray[index1];
    
    
    NSString *title = [NSString stringWithFormat:@"%@ %@", self.aim, self.setting];
    [self setTitle:title];
    
}

#pragma mark - --- setters 属性 ---




#pragma mark - --- getters 属性 ---

- (NSArray *)rootArray {
    if (!_rootArray) {
        _rootArray  = [AimModel creatAimData];
        
    }
    return _rootArray;
}
- (NSMutableArray *)aimArray {
    if (!_aimArray) {
        _aimArray = [NSMutableArray array];
    }
    return _aimArray;
}
- (NSMutableArray *)settingArray {
    if (!_settingArray) {
        _settingArray = [NSMutableArray array];
        
    }
    return _settingArray;
}
- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

@end
