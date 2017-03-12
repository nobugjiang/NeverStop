//
//  GlideView.m
//  NeverStop
//
//  Created by Jiang on 16/10/26.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "GlideView.h"
#import "JiangFlashLabel.h"
@interface GlideView ()
@property (nonatomic, strong) JiangFlashLabel *flashLabel;
@end
@implementation GlideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *str = @"下滑以解锁";
        CGFloat width = [str widthWithFont:[UIFont boldSystemFontOfSize:20] constrainedToHeight:25];
        self.flashLabel = [[JiangFlashLabel alloc] initWithFrame:CGRectMake(self.width / 2 - width / 2, 0, width, 25)];
        _flashLabel.text = str;
        _flashLabel.font = [UIFont boldSystemFontOfSize:20];
        [_flashLabel startAnimating];
        [self addSubview:_flashLabel];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 10, _flashLabel.y + _flashLabel.height + 10, 20, 32)];
        imageView.image = [UIImage imageNamed:@"glide"];
        [self addSubview:imageView];
    }
    return self;
}





@end
