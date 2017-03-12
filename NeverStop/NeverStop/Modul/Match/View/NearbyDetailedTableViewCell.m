//
//  NearbyDetailedTableViewCell.m
//  NeverStop
//
//  Created by dllo on 16/10/28.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "NearbyDetailedTableViewCell.h"

@implementation NearbyDetailedTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userPic = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_userPic];
        self.nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        self.content = [[UILabel alloc] init];
        [self.contentView addSubview:_content];
    }
    return self;
}

- (void)setNearbyDetailed:(NearbyDatail *)nearbyDetailed {
    if (_nearbyDetailed != nearbyDetailed) {
        _nearbyDetailed = nearbyDetailed;
    }
    NSURL *url = [NSURL URLWithString:nearbyDetailed.user_pic];
        [_userPic sd_setImageWithURL:url];
        self.nameLabel.text = nearbyDetailed.user_name;
        self.content.text = nearbyDetailed.content;

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.userPic.frame = CGRectMake(10, 10, 30, 30);
    _userPic.layer.cornerRadius = 8;
    _userPic.clipsToBounds = YES;
    self.nameLabel.frame = CGRectMake(45, 10, 200, 20);
    self.content.frame = CGRectMake(45, 40, self.contentView.frame.size.width- 50, 50);
    
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
