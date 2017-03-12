//
//  JiangSegmentScrollView.m
//  NeverStop
//
//  Created by Jiang on 16/11/7.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "JiangSegmentScrollView.h"
#import "JiangSegmentView.h"

@interface JiangSegmentScrollView ()
<
UIScrollViewDelegate
>
@property (strong, nonatomic) UIScrollView *bgScrollView;
@property (strong, nonatomic) JiangSegmentView *segmentToolView;
@end
@implementation JiangSegmentScrollView

- (instancetype)initWithFrame:(CGRect)frame
                  titleArray:(NSArray *)titleArray
            contentViewArray:(NSArray *)contentViewArray{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.bgScrollView];
        
        
        _segmentToolView = [[JiangSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) titles:titleArray clickBlick:^void(NSInteger index ) {
            NSLog(@"-----%ld", index);
            [_bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (index - 1051), 0)];
        }];
        [self addSubview:_segmentToolView];
        
        
        for (int i = 0; i < contentViewArray.count; i++) {
            UIView *contentView = (UIView *)contentViewArray[i];
            contentView.frame = CGRectMake(SCREEN_WIDTH * i, _segmentToolView.bounds.size.height, SCREEN_WIDTH, _bgScrollView.frame.size.height - _segmentToolView.bounds.size.height);
            [_bgScrollView addSubview:contentView];
        }
    }
    return self;
}






- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentToolView.frame.size.height, SCREEN_WIDTH, self.bounds.size.height - _segmentToolView.bounds.size.height)];
        _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, self.bounds.size.height - _segmentToolView.bounds.size.height);
        _bgScrollView.backgroundColor = [UIColor brownColor];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.delegate = self;
        _bgScrollView.bounces = NO;
        _bgScrollView.pagingEnabled = YES;
    }
    return _bgScrollView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    
    [_segmentToolView updateselectLineFrameWithoffset:point.x];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_bgScrollView)
    {
        NSInteger p = _bgScrollView.contentOffset.x / SCREEN_WIDTH;
        _segmentToolView.defaultIndex=p+1;
        
        
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
