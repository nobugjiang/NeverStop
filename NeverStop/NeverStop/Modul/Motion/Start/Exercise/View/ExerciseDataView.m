//
//  ExerciseDataView.m
//  NeverStop
//
//  Created by Jiang on 16/10/25.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ExerciseDataView.h"

@interface ExerciseDataView ()
@end
@implementation ExerciseDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataLabel = [[UILabel alloc] init];
       
        _dataLabel.textColor = [UIColor whiteColor];
        _dataLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dataLabel];
        self.titleLabel = [[UILabel alloc] init];
      

        _titleLabel.textColor = [UIColor colorWithRed:0.8045 green:0.8045 blue:0.8045 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
    }
    return self;
}
- (void)setDataLabel:(UILabel *)dataLabel {
    if (_dataLabel != dataLabel) {
        _dataLabel = dataLabel;
    }
   }

- (void)setTitleLabel:(UILabel *)titleLabel {
    if (_titleLabel != titleLabel) {
        _titleLabel = titleLabel;
    }
  }

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = [_dataLabel.text heightWithFont:_dataLabel.font constrainedToWidth:self.width];
    _dataLabel.frame = CGRectMake(0, 0, self.width, height * 1.2);
    CGFloat titleHeight = [_titleLabel.text heightWithFont:_titleLabel.font constrainedToWidth:self.width];
    _titleLabel.frame = CGRectMake(0, self.height - titleHeight, self.width, titleHeight);


}
@end
