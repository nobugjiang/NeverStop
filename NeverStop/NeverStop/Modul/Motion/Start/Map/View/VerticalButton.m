//
//  VerticalButton.m
//  NeverStop
//
//  Created by Jiang on 16/10/28.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "VerticalButton.h"

@implementation VerticalButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height * 0.8;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = CGRectGetWidth(contentRect);
    CGFloat imageH = contentRect.size.height * 0.8;
    return CGRectMake(0, 0, imageW, imageH);
}

@end
