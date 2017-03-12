//
//  ScopeTableViewCell.h
//  NeverStop
//
//  Created by dllo on 16/10/29.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Scope;
@interface ScopeTableViewCell : UITableViewCell
@property (nonatomic, strong) Scope *scopeModel;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *userCount;
@property (nonatomic, strong) UIImageView *iconImageUrl;
@property (nonatomic, strong) UILabel *disp;
@property (nonatomic, strong) UIImageView *dw;
@property (nonatomic, strong) UIImageView *mm;
@property (nonatomic, strong) UIImageView *go;
@end
