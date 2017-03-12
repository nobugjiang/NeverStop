//
//  ScoreTableViewCell.m
//  NeverStop
//
//  Created by DYQ on 16/10/31.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ScoreTableViewCell.h"

@interface ScoreTableViewCell ()

@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *finishLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
        _typeImageView.backgroundColor = [UIColor lightGrayColor];
        _typeImageView.layer.cornerRadius = 25;
        _typeImageView.layer.borderColor = [UIColor grayColor].CGColor;
        _typeImageView.layer.borderWidth = 2.f;
        [self.contentView addSubview:_typeImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeImageView.x + _typeImageView.width + 10, _typeImageView.y + 5, 200, 20)];
        [self.contentView addSubview:_titleLabel];
        
        self.finishLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.x, _titleLabel.y + _titleLabel.height + 5, _titleLabel.width, _titleLabel.height)];
        _finishLabel.text = @"未完成";
        _finishLabel.textColor = [UIColor grayColor];
        _finishLabel.font = kFONT_SIZE_15;
        [self addSubview:_finishLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 25, 90, 30)];
        _timeLabel.text = @"--:--:--";
        _timeLabel.font = kFONT_SIZE_24_BOLD;
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)setType:(NSString *)type {
    if (_type != type) {
        _type = type;
        
        switch ([type integerValue]) {
            case 0:
//                _typeImageView.image = [UIImage imageNamed:@""];
                _titleLabel.text = @"3公里跑";
                break;
            case 1:
                //                _typeImageView.image = [UIImage imageNamed:@""];
                _titleLabel.text = @"5公里跑";
                break;
            case 2:
                //                _typeImageView.image = [UIImage imageNamed:@""];
                _titleLabel.text = @"10公里跑";
                break;
            case 3:
                //                _typeImageView.image = [UIImage imageNamed:@""];
                _titleLabel.text = @"半程马拉松";
                break;
            case 4:
                //                _typeImageView.image = [UIImage imageNamed:@""];
                _titleLabel.text = @"全程马拉松";
                break;
            case 5:
                //                _typeImageView.image = [UIImage imageNamed:@""];
                _titleLabel.text = @"最远跑步距离";
                break;
            case 6:
                //                _typeImageView.image = [UIImage imageNamed:@""];
                _titleLabel.text = @"最远健走距离";
                break;

            default:
                break;
        }
    }
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
