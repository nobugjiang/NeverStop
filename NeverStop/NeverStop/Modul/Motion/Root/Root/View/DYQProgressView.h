//
//  DYQProgressView.h
//  NeverStop
//
//  Created by DYQ on 16/11/3.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYQProgressView : UIView

//进度线条宽度
@property (nonatomic,assign) CGFloat progressLineWidth;
//背景线条宽度
@property (nonatomic,assign) CGFloat backgourndLineWidth;
//进度百分比
@property (nonatomic,assign) CGFloat Percentage;
//背景填充颜色
@property (nonatomic,strong) UIColor *backgroundStrokeColor;
//进度条填充颜色
@property (nonatomic,strong) UIColor *progressStrokeColor;
//距离边框边距偏移量
@property (nonatomic,assign) CGFloat offset;
//步长
@property (nonatomic,assign) CGFloat step;
//格子之间的宽度
@property (nonatomic,assign) CGFloat GapWidth;
//设置线条宽度 （进度条宽度 = 背景线条宽度）
@property (nonatomic,assign) CGFloat lineWidth;
//动画持续时间。 单位：秒
@property (nonatomic) CGFloat timeDuration;


-(void)setProgress:(CGFloat)Percentage Animated:(BOOL)animated;



@end
