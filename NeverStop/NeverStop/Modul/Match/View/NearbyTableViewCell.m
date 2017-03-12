//
//  NearbyTableViewCell.m
//  NeverStop
//
//  Created by dllo on 16/10/25.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "NearbyTableViewCell.h"

@implementation NearbyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.noPic = [[UIImageView alloc] init];
        [self.contentView addSubview:_noPic];
        self.imageViewD = [[UIImageView alloc] init];
        [self.noPic addSubview:_imageViewD];
        self.routeView = [[UIView alloc] init];
        _routeView.backgroundColor = [UIColor whiteColor];
        _routeView.alpha = 0.8;
        [self.contentView addSubview:_routeView];
        
        self.userImabeView = [[UIImageView alloc] init];
        [self.routeView addSubview:_userImabeView];
        self.titleLabel = [[UILabel alloc] init];
        [self.routeView addSubview:_titleLabel];
        self.commentLabel = [[UILabel alloc] init];
        _commentLabel.font = [UIFont systemFontOfSize:10];
        [self.routeView addSubview:_commentLabel];
        self.distance = [[UILabel alloc] init];
        _distance.textAlignment = 2;
        [self.routeView addSubview:_distance];
        
        
        self.commentImageView = [[UIImageView alloc] init];
        [self.routeView addSubview:_commentImageView];
    }
    return self;
}

- (void)setNearby:(Nearby *)nearby {
    if (_nearby != nearby) {
        _nearby = nearby;
    }
    NSURL *url = [NSURL URLWithString:nearby.image];
    [_imageViewD sd_setImageWithURL:url];
    
    
        NSURL *userurl = [NSURL URLWithString:nearby.user_pic];
        [_userImabeView sd_setImageWithURL:userurl];
        self.titleLabel.text = nearby.title;
        self.commentLabel.text = [NSString stringWithFormat:@"%@",nearby.comment_num];
        self.distance.text = [NSString stringWithFormat:@"%@m", nearby.distance];
        self.commentImageView.image = [UIImage imageNamed:@"pl"];
        self.noPic.image = [UIImage imageNamed:@"w2.jpg"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(32, 5, 500, 20);
    self.commentLabel.frame = CGRectMake(22, 35, 15, 10);
    self.commentImageView.frame = CGRectMake(5, 35, 10, 10);
    self.imageViewD.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.frame.size.height *0.9);
    self.userImabeView.frame = CGRectMake(5, 5, 25, 25);
    self.routeView.frame = CGRectMake(0, self.contentView.height - 50 , self.imageViewD.width, 45);
    self.distance.frame = CGRectMake(0, 5, SCREEN_WIDTH - 10, 20);
    
    self.noPic.frame = CGRectMake(0, 5, self.contentView.width, self.contentView.frame.size.height *0.9);
    
    
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
