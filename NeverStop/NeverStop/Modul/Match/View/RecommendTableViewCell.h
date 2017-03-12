//
//  RecommendTableViewCell.h
//  NeverStop
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recommend.h"
@interface RecommendTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *likeCountLabel;
@property (nonatomic, retain) Recommend *recommend;
@property (nonatomic, retain) UIImageView *titleImageView;
@end
