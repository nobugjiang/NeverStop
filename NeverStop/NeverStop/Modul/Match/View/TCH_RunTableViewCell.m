//
//  TCH_RunTableViewCell.m
//  NeverStop
//
//  Created by dllo on 16/10/28.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "TCH_RunTableViewCell.h"

@implementation TCH_RunTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = [[UILabel alloc] init];
        self.sub = [[UILabel alloc] init];
        _sub.textColor = [UIColor grayColor];
        _sub.font = [UIFont systemFontOfSize:14];
        _sub.numberOfLines = 0;
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_sub];
        self.coverImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_coverImageView];
    }
    
    return self;
}
- (void)setTchRun:(TCH_Run *)tchRun {
    if (_tchRun != tchRun) {
        _tchRun = tchRun;
    }
    self.title.text = tchRun.title;
    self.sub.text = tchRun.sub_title;
    _sub.numberOfLines = 0;
    NSURL *image = [NSURL URLWithString:tchRun.cover_img];
    [_coverImageView sd_setImageWithURL:image];
    

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.title.frame = CGRectMake(155, 15, self.contentView.frame.size.width - 160, 20);
    self.sub.frame = CGRectMake(155, 35, _title.width, 20);
    _sub.numberOfLines = 0;
    self.coverImageView.frame = CGRectMake(15, 15, 120, 70);
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
