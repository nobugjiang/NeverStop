//
//  CategoriesTableViewCell.m
//  NeverStop
//
//  Created by DYQ on 16/11/1.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "CategoriesTableViewCell.h"
#import "CategoriesModel.h"

@interface CategoriesTableViewCell ()

@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;


@end

@implementation CategoriesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 70, 100)];
        [self.contentView addSubview:_typeImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeImageView.x + _typeImageView.width + 30, 70, 250, 30)];
        _titleLabel.font = kFONT_SIZE_18_BOLD;
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        
        self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.x, _titleLabel.y + _titleLabel.height + 5, _titleLabel.width, _titleLabel.height)];
        _subtitleLabel.font = kFONT_SIZE_13;
        _subtitleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_subtitleLabel];
        
        
    }
    return self;
}

- (void)setCategoriesModel:(CategoriesModel *)categoriesModel {
    if (_categoriesModel != categoriesModel) {
        _categoriesModel = categoriesModel;
        [_typeImageView sd_setImageWithURL:[NSURL URLWithString:categoriesModel.categoryImg] placeholderImage:nil];
        _titleLabel.text = categoriesModel.categoryName;
        _subtitleLabel.text = categoriesModel.categoryDesc;
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
