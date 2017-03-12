//
//  JiangPickerView.m
//  NeverStop
//
//  Created by Jiang on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "JiangPickerView.h"

@implementation JiangPickerView

#pragma mark - --- init 视图初始化 ---
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupDefault];
        [self setupUI];
    }
    return self;
}

- (void)setupDefault
{
    // 1.设置数据的默认值
    _title = nil;
    _font = [UIFont systemFontOfSize:15];
    _titleColor = [UIColor blackColor];
    _borderButtonColor = [UIColor colorWithRed:205 / 255.f green:205 / 255.f blue:205 / 255.f alpha:1];
    _heightPicker = 240;
    _contentMode = JiangPickerContentModeBottom;
    
    // 2.设置自身的属性
    self.bounds = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:102.0 / 255.0f];
    self.layer.opacity = 0.0;
    [self addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.添加子视图
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.pickerView];
    [self.contentView addSubview:self.buttonLeft];
    [self.contentView addSubview:self.buttonRight];
    [self.contentView addSubview:self.labelTitle];
    [self.contentView addSubview:self.lineViewDown];
}

- (void)setupUI
{}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.contentMode == JiangPickerContentModeBottom) {
    }else {
        self.buttonLeft.y = self.lineViewDown.y + self.lineViewDown.height + 5;
        self.buttonRight.y = self.lineViewDown.y + self.lineViewDown.height + 5;
    }
}

#pragma mark - --- delegate 视图委托 ---

#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    [self remove];
}

- (void)selectedCancel
{
    [self remove];
}

#pragma mark - --- private methods 私有方法 ---


- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    if (self.contentMode == JiangPickerContentModeBottom) {
        CGRect frameContent =  self.contentView.frame;
        frameContent.origin.y -= self.contentView.height;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setOpacity:1.0];
            self.contentView.frame = frameContent;
        } completion:^(BOOL finished) {
        }];
    }else {
        CGRect frameContent =  self.contentView.frame;
        frameContent.origin.y -= (SCREEN_HEIGHT + self.contentView.height) / 2;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setOpacity:1.0];
            self.contentView.frame = frameContent;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)remove
{
    if (self.contentMode == JiangPickerContentModeBottom) {
        CGRect frameContent =  self.contentView.frame;
        frameContent.origin.y += self.contentView.height;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setOpacity:0.0];
            self.contentView.frame = frameContent;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        CGRect frameContent =  self.contentView.frame;
        frameContent.origin.y += (SCREEN_HEIGHT + self.contentView.height) / 2;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setOpacity:0.0];
            self.contentView.frame = frameContent;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - --- setters 属性 ---

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
    }
    [self.labelTitle setText:title];
}

- (void)setFont:(UIFont *)font
{
    if (_font != font) {
        _font = font;
    }
    [self.buttonLeft.titleLabel setFont:font];
    [self.buttonRight.titleLabel setFont:font];
    [self.labelTitle setFont:font];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor != titleColor) {
        _titleColor = titleColor;
    }
    [self.labelTitle setTextColor:titleColor];
    [self.buttonLeft setTitleColor:titleColor forState:UIControlStateNormal];
    [self.buttonRight setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setBorderButtonColor:(UIColor *)borderButtonColor
{
    if (_borderButtonColor != borderButtonColor) {
        _borderButtonColor = borderButtonColor;
    }
    [self.buttonLeft.layer setBorderColor:borderButtonColor.CGColor];
    [self.buttonLeft.layer setBorderWidth:0.5];
    [self.buttonLeft.layer setCornerRadius:4];
    [self.buttonRight.layer setBorderColor:borderButtonColor.CGColor];
    [self.buttonRight.layer setBorderWidth:0.5];
    [self.buttonRight.layer setCornerRadius:4];
}

- (void)setHeightPicker:(CGFloat)heightPicker
{
    if (_heightPicker != heightPicker) {
        _heightPicker = heightPicker;
    }
    self.contentView.height = heightPicker;
}

- (void)setContentMode:(JiangPickerContentMode)contentMode
{
    if (_contentMode != contentMode) {
        _contentMode = contentMode;
    }
    if (contentMode == JiangPickerContentModeCenter) {
        self.contentView.height += 44;
    }
}
#pragma mark - --- getters 属性 ---
- (UIView *)contentView
{
    if (!_contentView) {
        CGFloat contentX = 0;
        CGFloat contentY = SCREEN_HEIGHT;
        CGFloat contentW = SCREEN_WIDTH;
        CGFloat contentH = self.heightPicker;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(contentX, contentY, contentW, contentH)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return _contentView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        CGFloat lineX = 0;
        CGFloat lineY = 44;
        CGFloat lineW = _contentView.width;
        CGFloat lineH = 0.5;
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        [_lineView setBackgroundColor:self.borderButtonColor];
    }
    return _lineView;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        CGFloat pickerW = _contentView.width;
        CGFloat pickerH = _contentView.height - _lineView.y - _lineView.height;
        CGFloat pickerX = 0;
        CGFloat pickerY = _lineView.y + _lineView.height;
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(pickerX, pickerY, pickerW, pickerH)];
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (UIButton *)buttonLeft
{
    if (!_buttonLeft) {
        CGFloat leftW = 44;
        CGFloat leftH = _lineView.y - 10;
        CGFloat leftX = 16;
        CGFloat leftY = (_lineView.y - leftH) / 2;
        _buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(leftX, leftY, leftW, leftH)];
        [_buttonLeft setTitle:@"取消" forState:UIControlStateNormal];
        [_buttonLeft setTitleColor:self.titleColor forState:UIControlStateNormal];
        [_buttonLeft.layer setBorderColor:self.borderButtonColor.CGColor];
        [_buttonLeft.layer setBorderWidth:0.5];
        [_buttonLeft.layer setCornerRadius:4];

        [_buttonLeft.titleLabel setFont:self.font];
        [_buttonLeft addTarget:self action:@selector(selectedCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonLeft;
}

- (UIButton *)buttonRight
{
    if (!_buttonRight) {
        CGFloat rightW = self.buttonLeft.width;
        CGFloat rightH = self.buttonLeft.height;
        CGFloat rightX = self.contentView.width - rightW - self.buttonLeft.x;
        CGFloat rightY = self.buttonLeft.y;
        _buttonRight = [[UIButton alloc]initWithFrame:CGRectMake(rightX, rightY, rightW, rightH)];
        [_buttonRight setTitle:@"确定" forState:UIControlStateNormal];
        [_buttonRight setTitleColor:self.titleColor forState:UIControlStateNormal];
        [_buttonRight.layer setBorderColor:self.borderButtonColor.CGColor];
        [_buttonRight.layer setBorderWidth:0.5];
        [_buttonRight.layer setCornerRadius:4];

        [_buttonRight.titleLabel setFont:self.font];
        [_buttonRight addTarget:self action:@selector(selectedOk) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonRight;
}

- (UILabel *)labelTitle
{
    if (!_labelTitle) {
        CGFloat titleX = _buttonLeft.x + _buttonLeft.width + 5;
        CGFloat titleY = 0;
        CGFloat titleW = _contentView.width - titleX * 2;
        CGFloat titleH = _lineView.y;
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
        [_labelTitle setTextAlignment:NSTextAlignmentCenter];
        [_labelTitle setTextColor:self.titleColor];
        [_labelTitle setFont:self.font];
        _labelTitle.adjustsFontSizeToFitWidth = YES;
    }
    return _labelTitle;
}

- (UIView *)lineViewDown
{
    if (!_lineViewDown) {
        CGFloat lineX = 0;
        CGFloat lineY = _pickerView.y + _pickerView.height;
        CGFloat lineW = _contentView.width;
        CGFloat lineH = 0.5;
        _lineViewDown = [[UIView alloc]initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        [_lineViewDown setBackgroundColor:self.borderButtonColor];
    }
    return _lineViewDown;
}

@end
