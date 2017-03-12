//
//  RecordTableViewCell.m
//  NeverStop
//
//  Created by Jiang on 16/11/8.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "ExerciseDataView.h"
@implementation RecordTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(self.width / 4 - 20, 20, 140, 60)];
        _leftDataView.titleLabel.textColor = [UIColor lightGrayColor];
        _leftDataView.dataLabel.textColor = [UIColor blackColor];
        _leftDataView.titleLabel.font = kFONT_SIZE_15_BOLD;
        _leftDataView.dataLabel.font = kFONT_SIZE_24_BOLD;
        [self addSubview:_leftDataView];
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.leftDataView.x - 25, _leftDataView.y + _leftDataView.height / 2 - 12, 24, 24)];
        _leftImageView.layer.cornerRadius = _leftImageView.height / 2;
        _leftImageView.clipsToBounds = YES;
        [self addSubview:_leftImageView];
        self.rightDataView = [[ExerciseDataView alloc] initWithFrame:CGRectMake(self.width / 4 * 3 - 20, 20, 140, 60)];
        [self addSubview:_leftDataView];
        _rightDataView.titleLabel.textColor = [UIColor lightGrayColor];
        _rightDataView.dataLabel.textColor = [UIColor blackColor];
        _rightDataView.titleLabel.font = kFONT_SIZE_15_BOLD;
        _rightDataView.dataLabel.font = kFONT_SIZE_24_BOLD;

        [self addSubview:_rightDataView];
        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.rightDataView.x - 25, _rightDataView.y + _rightDataView.height / 2 - 12, 24, 24)];
        _rightImageView.layer.cornerRadius = _rightImageView.height / 2;
        _rightImageView.clipsToBounds = YES;
        [self addSubview:_rightImageView];
    }
    return self;
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
