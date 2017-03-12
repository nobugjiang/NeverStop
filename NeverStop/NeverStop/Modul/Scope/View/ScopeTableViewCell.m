//
//  ScopeTableViewCell.m
//  NeverStop
//
//  Created by dllo on 16/10/29.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ScopeTableViewCell.h"
#import "Scope.h"
#import "Info.h"
#import "LocationModel.h"

@implementation ScopeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = [[UILabel alloc] init];
        _title.textColor = [UIColor whiteColor];
        self.descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:13];
        _descriptionLabel.textColor = [UIColor lightGrayColor];
        self.userCount = [[UILabel alloc] init];
        _userCount.font = [UIFont systemFontOfSize:12];
        _userCount.textColor = [UIColor lightGrayColor];
        self.iconImageUrl = [[UIImageView alloc] init];
        [_iconImageUrl.layer setBorderWidth:2];
        //_iconImageUrl.contentMode = UIViewContentModeScaleAspectFit;
        self.disp = [[UILabel alloc] init];
        _disp.font = [UIFont systemFontOfSize:12];
        _disp.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_disp];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_descriptionLabel];
        [self.contentView addSubview:_userCount];
        [self.contentView  addSubview:_iconImageUrl];
        
        self.dw = [[UIImageView alloc] init];
        [self.contentView addSubview:_dw];
        self.mm = [[UIImageView alloc] init];
        [self.contentView addSubview:_mm];
        self.go = [[UIImageView alloc] init];
        [self.contentView addSubview:_go];
        
    }
    
    return self;
}
- (void)setScopeModel:(Scope *)scopeModel {
    if (_scopeModel != scopeModel) {
        _scopeModel = scopeModel;
    }
    self.title.text = scopeModel.info.display_name;
    self.descriptionLabel.text = scopeModel.info.content;
    self.userCount.text = [NSString stringWithFormat:@"%@", scopeModel.info.user_count];
    NSURL *url = [NSURL URLWithString:scopeModel.info.icon_image_url];
    [_iconImageUrl sd_setImageWithURL:url];
    _iconImageUrl.layer.cornerRadius = 30;
    [_iconImageUrl clipsToBounds];
    self.disp.text = scopeModel.location.display_name;
    self.dw.image = [UIImage imageNamed:@"dw"];
    self.mm.image = [UIImage imageNamed:@"mmm"];
    self.go.image = [UIImage imageNamed:@"go"];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconImageUrl.frame = CGRectMake(15, 15, 70, 70);
    _iconImageUrl.layer.cornerRadius = 8;
    _iconImageUrl.clipsToBounds = YES;

    self.title.frame = CGRectMake(100,15, 600, 20);
    self.dw.frame = CGRectMake(140, 45, 8, 10);
    self.mm.frame = CGRectMake(100, 45, 10, 10);
    self.userCount.frame = CGRectMake(115, 40, 600, 20);
    self.disp.frame = CGRectMake(150, 40, 600, 20);
    self.descriptionLabel.frame = CGRectMake(100, 65, SCREEN_WIDTH - 100 - 40, 20);
    self.go.frame = CGRectMake(SCREEN_WIDTH - 30, 45, 5, 10);



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
