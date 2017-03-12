//
//  ProgressAimView.m
//  NeverStop
//
//  Created by Jiang on 16/10/29.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ProgressAimView.h"

@interface ProgressAimView ()

@property (nonatomic, strong) UIView *rectView;
@property (nonatomic, strong) UIView *changingView;
@property (nonatomic, strong) UILabel *aimLabel;
@property (nonatomic, strong) NSString *aim;
@property (nonatomic, assign) CGFloat aimCount;
@property (nonatomic, assign) BOOL isCompleted;
@end
@implementation ProgressAimView


- (instancetype)initWithFrame:(CGRect)frame aim:(NSString *)aim aimType:(NSInteger)aimType
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isCompleted = NO;
        self.rectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 5)];
        _rectView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        _rectView.layer.cornerRadius = _rectView.height / 2;
        _rectView.clipsToBounds = YES;
        [self addSubview:_rectView];
        
        self.changingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 5)];
        _changingView.backgroundColor = [UIColor colorWithRed:0.502 green:1.0 blue:0.0 alpha:1.0];
        _changingView.layer.cornerRadius = _changingView.height / 2;
        _changingView.clipsToBounds = YES;
        [self.rectView addSubview:_changingView];
       
       
        self.aimLabel = [[UILabel alloc] init];
        self.aimLabel.text = aim;
        _aimLabel.backgroundColor = [UIColor clearColor];
        _aimLabel.font = kFONT_SIZE_15_BOLD;
        CGFloat width = [aim widthWithFont:_aimLabel.font constrainedToHeight:20];
        _aimLabel.frame = CGRectMake(self.width / 2 - width / 2, _rectView.y + _rectView.height + 3, width, 20);
        
        _aimLabel.textAlignment = NSTextAlignmentCenter;
        _aimLabel.textColor = [UIColor whiteColor];
        [self addSubview:_aimLabel];
           }
    NSMutableString *str = [aim copy];
    switch (aimType) {
        case 0:
            [self removeFromSuperview];
            break;
        case 1:
            
            break;
        case 2:
           self.aimCount = [[[str stringByReplacingOccurrencesOfString:@"距离目标: " withString:@""] stringByReplacingOccurrencesOfString:@"公里" withString:@""] floatValue];
            break;
        case 3:
             self.aimCount = [[[str stringByReplacingOccurrencesOfString:@"时间目标: " withString:@""] stringByReplacingOccurrencesOfString:@"分钟" withString:@""] floatValue] * 60;
            break;
        case 4:
            self.aimCount = [[[str stringByReplacingOccurrencesOfString:@"卡路里目标: " withString:@""] stringByReplacingOccurrencesOfString:@"大卡" withString:@""] floatValue];
            break;
        default:
            break;
    }
 
    return self;
}
- (void)setCurrentNumber:(CGFloat)currentNumber {
    if (_currentNumber != currentNumber) {
        _currentNumber = currentNumber;
    }
    if (!_isCompleted) {
        if (currentNumber <= _aimCount) {
            
            CGRect frame = self.changingView.frame;
            
            frame.size.width = currentNumber / self.aimCount * _rectView.width;
//            NSLog(@"%.f", _changingView.width);
            if (frame.size.width == 0) {
                NSLog(@"%f", frame.size.width);
            }
            self.changingView.frame = frame;
        } else {
            CGRect frame = self.changingView.frame;
            
            frame.size.width = self.width;
            self.changingView.frame = frame;
            self.aimLabel.text = [_aimLabel.text stringByAppendingString:@" 已完成"];
            [self.delegate aimIsCompleted];
            CGFloat width = [_aimLabel.text widthWithFont:_aimLabel.font constrainedToHeight:20];
            
            _aimLabel.frame = CGRectMake(self.width / 2 - width / 2, _rectView.y + _rectView.height + 3, width, 20);
            _isCompleted = YES;
        }
    }
  
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
