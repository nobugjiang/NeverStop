//
//  RouteTableViewCell.h
//  NeverStop
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"
@interface RouteTableViewCell : UITableViewCell
@property (nonatomic, retain) UILabel *titleLabel;
// 评论人数
@property (nonatomic, retain) UILabel *commentLabel;
// 地图
@property (nonatomic, retain) UIImageView *imageViewD;
// 楼主头像
@property (nonatomic, retain) UIImageView *userImabeView;
// 距离
@property (nonatomic, retain) UILabel *distance;
@property (nonatomic, retain) Route *route;
@property (nonatomic, retain) UIView *routeView;
@property (nonatomic, retain) UIImageView *commentImageView;
@end
