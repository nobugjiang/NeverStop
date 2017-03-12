//
//  MyInfoTableViewCell.m
//  NeverStop
//
//  Created by DYQ on 16/10/29.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "MyInfoTableViewCell.h"

@interface MyInfoTableViewCell ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end

@implementation MyInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
        [self.contentView addSubview:_logoImageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_logoImageView.x + _logoImageView.width + 10, _logoImageView.y, 200, 30)];
        _titleLabel.font = kFONT_SIZE_18_BOLD;
        [self.contentView addSubview:_titleLabel];
        
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.x, _titleLabel.y + _titleLabel.height, _titleLabel.width, _titleLabel.height)];
        _subtitleLabel.textColor = [UIColor grayColor];
        _subtitleLabel.font = kFONT_SIZE_15_BOLD;
        [self.contentView addSubview:_subtitleLabel];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        _imageName = imageName;
        _logoImageView.image = [UIImage imageNamed:imageName];
    }
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        _titleLabel.text = title;
    }
}
- (void)setSubtitle:(NSString *)subtitle {
    if (_subtitle != subtitle) {
        _subtitle = subtitle;
        _subtitleLabel.text = _subtitle;
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
