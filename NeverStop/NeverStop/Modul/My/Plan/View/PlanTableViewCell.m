//
//  PlanTableViewCell.m
//  NeverStop
//
//  Created by DYQ on 16/10/31.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "PlanTableViewCell.h"
#import "PlanModel.h"

@interface PlanTableViewCell ()

@property (nonatomic, strong) UIImageView *cellImageView;

@end

@implementation PlanTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 201)];
        [self.contentView addSubview:_cellImageView];
    }
    return self;
}

- (void)setPlanModel:(PlanModel *)planModel {
    if (_planModel != planModel) {
        _planModel = planModel;
        [_cellImageView sd_setImageWithURL:[NSURL URLWithString:planModel.cover] placeholderImage:[UIImage imageNamed:@"w2.jpg"]];
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
