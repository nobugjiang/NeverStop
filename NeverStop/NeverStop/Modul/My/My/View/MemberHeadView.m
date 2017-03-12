//
//  MemberHeadView.m
//  FindTraining
//
//  Created by Jiang on 16/10/8.
//  Copyright © 2016年 Yuxiao Jiang. All rights reserved.
//

#import "MemberHeadView.h"

@interface MemberHeadView ()
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UIView *memberView;
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UIView *headView;;
@property (nonatomic, retain) UILabel *nameLabel;

@end
@implementation MemberHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        
        self.backView = [[UIView alloc] init];
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = [UIColor clearColor];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        [self addSubview:_backView];
//        self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_headbg"]];
//        _backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);
//        _backImageView.userInteractionEnabled = YES;
//        [self addSubview:_backImageView];
        
        self.memberView = [[UIView alloc] init];
        _memberView.backgroundColor = [UIColor whiteColor];
        _memberView.frame = CGRectMake(0, _backView.y + _backView.height, SCREEN_WIDTH, self.frame.size.height - _backView.height);
        [self addSubview:_memberView];
        
        self.headView = [[UIView alloc] init];
        _headView.frame = CGRectMake(_memberView.centerX - 40, -40, 80, 80);
        _headView.layer.cornerRadius = 40;
        _headView.layer.borderWidth = 0.1f;
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _headView.layer.shadowColor = [UIColor blackColor].CGColor;
        _headView.layer.shadowOffset = CGSizeMake(2, 2);
        _headView.layer.shadowOpacity = 0.6;//阴影透明度，默认0
        _headView.layer.shadowRadius = 4;//阴影半径
        self.headView.userInteractionEnabled = YES;
        [_memberView addSubview:_headView];
        
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.frame = CGRectMake(5, 5, 70, 70);
        

        _headImageView.image = [UIImage imageNamed:@"icon"];
        [self addSubview:_headImageView];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.layer.cornerRadius = 35;
        _headImageView.clipsToBounds = YES;
      
        [_headView addSubview:_headImageView];
        

        
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFONT_SIZE_18_BOLD;
        _nameLabel.textColor = [UIColor blackColor];
        [_memberView addSubview:_nameLabel];
        CGFloat nameWidth = [UILabel getWidthWithTitle:_nameLabel.text font:_nameLabel.font];
        _nameLabel.frame = CGRectMake(_memberView.centerX - nameWidth / 2, 50, nameWidth, 25);

        
    }
    return self;
}





@end
