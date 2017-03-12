//
//  NearbyTableViewCell.h
//  NeverStop
//
//  Created by dllo on 16/10/25.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Nearby.h"
@interface NearbyTableViewCell : UITableViewCell
@property (nonatomic, strong) Nearby *nearby;
@property (nonatomic, retain) UILabel *titleLabel;
// 评论人数
@property (nonatomic, retain) UILabel *commentLabel;
// 地图
@property (nonatomic, retain) UIImageView *imageViewD;
// 楼主头像
@property (nonatomic, retain) UIImageView *userImabeView;
// 距离
@property (nonatomic, retain) UILabel *distance;
@property (nonatomic, retain) UIView *routeView;
@property (nonatomic, retain) UIImageView *commentImageView;
// 没有图片时候显示的图片
@property (nonatomic, retain) UIImageView *noPic;

@end
