//
//  RecommendTableViewCell.m
//  NeverStop
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "RecommendTableViewCell.h"

@implementation RecommendTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _titleImageView.contentMode = 2;
        _titleImageView.clipsToBounds = YES;
        [self.contentView addSubview:_titleImageView];
        
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        self.likeCountLabel = [[UILabel alloc] init];
        _likeCountLabel.textAlignment = NSTextAlignmentCenter;
        _likeCountLabel.textColor = [UIColor whiteColor];
        //_likeCountLabel.numberOfLines = 0;
        _likeCountLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_likeCountLabel];
    }
    return self;
}

- (void)setRecommend:(Recommend *)recommend {
    if (_recommend != recommend ) {
        _recommend = recommend;
    }
    self.titleLabel.text = recommend.title;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@人觉得行", recommend.like_count];
    NSURL *url = [NSURL URLWithString:recommend.pic];
    [_titleImageView sd_setImageWithURL:url];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, self.contentView.frame.size.height / 2 - 20, SCREEN_WIDTH, 20);
   
    self.likeCountLabel.frame = CGRectMake(0,_titleLabel.frame.origin.y + 25, SCREEN_WIDTH, 10);

    self.titleImageView.frame = self.contentView.bounds;
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
