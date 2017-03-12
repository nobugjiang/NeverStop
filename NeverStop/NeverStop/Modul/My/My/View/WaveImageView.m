//
//  WaveImageView.m
//  FindTraining
//
//  Created by Jiang on 16/10/8.
//  Copyright © 2016年 Yuxiao Jiang. All rights reserved.
//

#import "WaveImageView.h"


@interface WaveImageView ()
/**
 *  波纹的振幅   amplitude （振幅）
 */
@property (nonatomic, assign) CGFloat waveAmplitude;

/**
 *  波纹的传播周期  单位s    period (周期)
 */
@property (nonatomic, assign) CGFloat wavePeriod;

/**
 *  波纹的长度
 */
@property (nonatomic, assign) CGFloat waveLength;

/** 偏移量 */
@property (nonatomic, assign) CGFloat offsetX;
/** 定时器 */
@property (nonatomic, strong) CADisplayLink *link;
/** 形状视图 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
/** 头像 */
@property (nonatomic, assign) UIImageView *icon;

@property (nonatomic, weak) UILabel *nameLabel;


@end
@implementation WaveImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.image = [UIImage imageNamed:@"me_headbg"];

        self.wavePeriod = 1;
        self.waveLength = SCREEN_WIDTH;
    }
    return self;
}
- (void)starWave {
    
    self.waveAmplitude = 6.0;
    self.shapeLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.shapeLayer];
    self.shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    //【**波动画关键**】 一秒执行60次（算是CADisplayLink特性），即每一秒执行 setShapeLayerPath 方法60次
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setShapeLayerPath)];
    
    
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)setShapeLayerPath {
    
    // 振幅不断减小，波执行完后为0 （使波浪更逼真些）
    self.waveAmplitude -= 0.02; // 2s 后为0
    
    if (self.waveAmplitude < 0.1) {
        [self stopWave];
    }
    
    // 每次执行画的正玄线平移一小段距离 （SCREEN_W / 60 / wavePeriod，1s执行60次，传播周期为wavePeriod,所以每个波传播一个屏幕的距离） 从而形成波在传播的效果
    
    self.offsetX += (SCREEN_WIDTH / 60 / self.wavePeriod);
    _shapeLayer.path = [[self currentWavePath] CGPath];
}


// UIBezierPath 画线
- (UIBezierPath *)currentWavePath {
    
    UIBezierPath *p = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 设置线宽
    p.lineWidth = 2.0;
    
    CGPathMoveToPoint(path, nil, 0, self.height);
    CGFloat y = 0.0f;
    
    for (float x = 0.0f; x <= SCREEN_WIDTH; x++) {
        
        /**
         * *** 正玄波的基础知识  ***
         *
         *  f(x) = Asin(ωx+φ)+k
         *
         *  A    为振幅, 波在上下振动时的最大偏移
         *
         *  φ/w  为在x方向平移距离
         *
         *  k    y轴偏移，即波的振动中心线y坐标与x轴的偏移距离
         *
         *  2π/ω 即为波长，若波长为屏幕宽度即， SCREEN_W = 2π/ω, ω = 2π/SCREEN_W
         */
        
        y = _waveAmplitude * sinf((2 * M_PI / _waveLength) * (x + _offsetX + _waveLength / 12)) + self.height - _waveAmplitude;
        
        // A = waveAmplitude  w = (2 * M_PI / waveLength) φ = (waveLength / 12) / (2 * M_PI / waveLength) k = headHeight - waveAmplitude （注意：坐标轴是一左上角为原点的）
        CGPathAddLineToPoint(path, nil, x, y);
        
    }
    
    CGPathAddLineToPoint(path, nil, SCREEN_WIDTH, self.height);
    CGPathCloseSubpath(path);
    p.CGPath = path;
    CGPathRelease(path);
    return p;
}

- (void)stopWave {
    
    [self.shapeLayer removeFromSuperlayer];
    [self.link invalidate];
    self.link = nil;
}

@end
