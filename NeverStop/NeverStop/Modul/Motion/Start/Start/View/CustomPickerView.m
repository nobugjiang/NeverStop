//
//  CustomPickerView.m
//  NeverStop
//
//  Created by Jiang on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "CustomPickerView.h"

@interface CustomPickerView ()
<
UIPickerViewDataSource,
UIPickerViewDelegate
>
@property (nonatomic, strong) NSArray *rootArray;
@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *minuteArray;

@property (nonatomic, strong) NSMutableArray *integerArray;
@property (nonatomic, strong) NSMutableArray *decimalsArray;

//@property (nonatomic, strong) NSString *selectedStr;
//@property (nonatomic, strong) NSString *childSelectedStr;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger childRow;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger onlyOnce;
@end


@implementation CustomPickerView
#pragma mark - --- init 视图初始化 ---




- (void)setupUI {
    self.font = kFONT_SIZE_18_BOLD;
    self.onlyOnce = 1;
    self.count = 0;
    self.integerArray = [NSMutableArray array];
    self.decimalsArray = [NSMutableArray array];
    self.hourArray = [NSMutableArray array];
    self.minuteArray = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        [_integerArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    for (int i = 0; i < 13; i++) {
        [_hourArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    for (int i = 0; i < 12; i++) {
        [_minuteArray addObject:[NSString stringWithFormat:@"%d", i * 5]];
    }
    for (int i = 0; i < 10; i++) {
        [_decimalsArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.row = 0;
    self.childRow = 1;

    
    // 2.设置视图的默认属性
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.heightPickerComponent = 32;
}

- (void)creatValuePointXs:(NSArray *)xArr withNames:(NSArray *)names
{
    for (int i=0; i<xArr.count; i++) {
        [self addLabelWithNames:names[i] withPointX:[xArr[i] intValue]];
    }
}

- (void)addLabelWithNames:(NSString *)name withPointX:(NSInteger)point_x
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point_x, SCREEN_HEIGHT - 120, 40, 44)];
    label.text = name;
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
    if (self.cus_ContentMode == CustomPickerContentModeDistance) {
        CGFloat pointX = SCREEN_WIDTH / 2 - _widthPickerComponent / 2 + 8;
        NSString *point = [NSString stringWithFormat:@"%f", pointX];
        CGFloat kmX = SCREEN_WIDTH / 2 + _widthPickerComponent / 2 + 10;
        NSString *km = [NSString stringWithFormat:@"%f", kmX];
            if (_count == 2) {
            [self creatValuePointXs:@[point, km] withNames:@[@".",@"公里"]];
                self.count = -1;
        }
        self.count++;
        return 2;
    } else {
        
        CGFloat hourX = SCREEN_WIDTH / 2 - _widthPickerComponent / 2 + 20;
        NSString *hour = [NSString stringWithFormat:@"%f", hourX];
        CGFloat minuteX = SCREEN_WIDTH / 2 + _widthPickerComponent / 2 - 23;
        NSString *minute = [NSString stringWithFormat:@"%f", minuteX];
        if (_count == 2) {
            [self creatValuePointXs:@[hour, minute] withNames:@[@"小时",@"分钟"]];
            self.count = -1;
        }
        self.count++;
        
       
        return 2;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.cus_ContentMode == CustomPickerContentModeDistance) {
        if (component == 0) {
            _widthPickerComponent = 30;
            return _widthPickerComponent;
        } else {
            _widthPickerComponent = 80;
            return _widthPickerComponent;
        }
    }
    
    if (component == 0) {
        _widthPickerComponent = 30;

        return _widthPickerComponent;
    } else {
        _widthPickerComponent = 140;
        return _widthPickerComponent;
    }

}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.cus_ContentMode == CustomPickerContentModeDistance) {
        if (component == 0) {
            return _integerArray.count;
            
        } else {
            return _decimalsArray.count;
        }
    }
    
        if (component == 0) {
            return _hourArray.count;
        } else {
            return _minuteArray.count;
        }

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (self.cus_ContentMode == CustomPickerContentModeDistance) {
        if (component == 0) {
            self.row = row;
            
        } else {
            if (self.row == 0 && row == 0) {
                [pickerView selectRow:1 inComponent:1 animated:YES];
            }
            self.childRow = row;

        }
        
    } else {
        if (component == 0) {
            
            self.row = row;

        } else {
            if (self.row == 0 && row == 0) {
                [pickerView selectRow:1 inComponent:1 animated:YES];
            }
            self.childRow = row;

        }

    }
//    [self reloadData];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    NSString *text;
    
    if (self.cus_ContentMode == CustomPickerContentModeDistance) {
        if (component == 0) {
            text = _integerArray[row];
        } else {
            text = _decimalsArray[row];
            if (self.onlyOnce <= 7) {
                [pickerView selectRow:1 inComponent:1 animated:YES];
                
            }
            self.onlyOnce++;
        }
    } else
    {
    if (component == 0) {
        text = _hourArray[row];
    } else {
        text = _minuteArray[row];
        if (self.onlyOnce <= 7) {
            [pickerView selectRow:1 inComponent:1 animated:YES];
            
        }
        self.onlyOnce++;
    }
    }
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:kFONT_SIZE_18_BOLD];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    NSString *selectedStr;
    NSString *childSelectedStr;
    if (self.cus_ContentMode == CustomPickerContentModeDistance) {
        selectedStr = _integerArray[_row];
        childSelectedStr = _decimalsArray[_childRow];

    } else {
        selectedStr = _integerArray[_row];
        childSelectedStr = _minuteArray[_childRow];
    }
    [self.delegate customPicker:self selected:selectedStr childSelected:childSelectedStr viewForRow:self.row forChildRow:self.childRow];
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

//- (void)reloadData
//{
//    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
//    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
//  
//    
//    
//    NSString *title = [NSString stringWithFormat:@"%@ %@", self.selectedStr, self.childSelectedStr];
//    [self setTitle:title];
//    
//}

#pragma mark - --- setters 属性 ---




#pragma mark - --- getters 属性 ---



@end
