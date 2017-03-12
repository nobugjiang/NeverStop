//
//  DYQProgressView.m
//  NeverStop
//
//  Created by DYQ on 16/11/3.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "DYQProgressView.h"

#define DefaultLineWidth 5

@interface DYQProgressView ()

@property (nonatomic,strong) CAShapeLayer *backgroundLayer;
@property (nonatomic,strong) CAShapeLayer *progressLayer;
@property (nonatomic,assign) CGFloat sumSteps;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation DYQProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self layoutViews];
        
        self.GapWidth = 10.0;
        
        self.backgourndLineWidth = DefaultLineWidth;
        self.progressLineWidth = DefaultLineWidth;
        
        self.Percentage = 0;
        self.offset = 0;
        self.sumSteps = 0;
        self.step = 0.1;
        self.timeDuration = 3.0;
    }
    return self;
}

-(void) layoutViews {
    
    if (!_backgroundLayer) {
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.frame = self.bounds;
        _backgroundLayer.fillColor = nil;
        _backgroundLayer.strokeColor = [UIColor brownColor].CGColor;
    }
    
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor = nil;
        _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    
    _backgroundLayer.lineCap = kCALineCapRound;
    _backgroundLayer.lineJoin = kCALineCapRound;
    
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineJoin = kCALineCapRound;
    
    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_progressLayer];
    
    
}

-(void) setBackgroundCircleLine {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    static float minAngle = 0.0081;
    
    for (int i = 0; i < ceil(360 / _GapWidth)+1; i++) {
        CGFloat angle = (i * (_GapWidth + minAngle) * M_PI / 180.0);
        
        if (i == 0) {
            angle = minAngle * M_PI/180.0;
        }
        
        if (angle >= M_PI *2) {
            angle = M_PI *2;
        }
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y) radius:(self.bounds.size.width - _backgourndLineWidth)/ 2 - _offset startAngle:-M_PI_2 +(i *_GapWidth * M_PI / 180.0) endAngle:-M_PI_2 + angle clockwise:YES];
        
        [path appendPath:path1];
        
    }
    
    _backgroundLayer.path = path.CGPath;
}

-(void)setProgressCircleLine {
    UIBezierPath *path = [UIBezierPath bezierPath];
    static float minAngle = 0.0081;
    for (int i = 0; i < ceil(360 / _GapWidth * _Percentage)+1; i++) {
        CGFloat angle = (i * (_GapWidth + minAngle) * M_PI / 180.0);
        
        if (i == 0) {
            angle = minAngle * M_PI/180.0;
        }
        
        if (angle >= M_PI *2) {
            angle = M_PI *2;
        }
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y) radius:(self.bounds.size.width - _progressLineWidth)/ 2 - _offset startAngle:-M_PI_2 + (i * _GapWidth * M_PI / 180.0) endAngle:-M_PI_2 + angle clockwise:YES];
        
        [path appendPath:path1];
        NSLog(@"%d", i);
    }
    _progressLayer.path = path.CGPath;
}

#pragma mark - setter and getter methond

-(void)setBackgourndLineWidth:(CGFloat)backgourndLineWidth {
    _backgourndLineWidth = backgourndLineWidth;
    _backgroundLayer.lineWidth = backgourndLineWidth;
}

-(void)setProgressLineWidth:(CGFloat)progressLineWidth {
    _progressLineWidth = progressLineWidth;
    _progressLayer.lineWidth = progressLineWidth;
    [self setBackgroundCircleLine];
    [self setProgressCircleLine];
}

-(void)setPercentage:(CGFloat)Percentage {
    _Percentage = Percentage;
    [self setProgressCircleLine];
    [self setBackgroundCircleLine];
    ;
}

-(void)setBackgroundStrokeColor:(UIColor *)backgroundStrokeColor {
    _backgroundStrokeColor = backgroundStrokeColor;
    _backgroundLayer.strokeColor = backgroundStrokeColor.CGColor;
}

-(void)setProgressStrokeColor:(UIColor *)progressStrokeColor {
    _progressStrokeColor = progressStrokeColor;
    _progressLayer.strokeColor = progressStrokeColor.CGColor;
    
}

-(void)setGapWidth:(CGFloat)GapWidth {
    _GapWidth = GapWidth;
    [self setBackgroundCircleLine];
    [self setProgressCircleLine];
    
}

-(void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    _progressLineWidth = lineWidth;
    _progressLayer.lineWidth = lineWidth;
    
    _backgourndLineWidth = lineWidth;
    _backgroundLayer.lineWidth = lineWidth;
}


-(void)setTimeDuration:(CGFloat)timeDuration {
    _timeDuration = timeDuration;
    [self setProgress:1.0 Animated:YES];
}

#pragma mark - progress animated YES or NO
-(void)setProgress:(CGFloat)Percentage Animated:(BOOL)animated {
    self.Percentage = Percentage;
    if (animated) {
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = [NSNumber numberWithFloat:0.0];
        
        animation.toValue = [NSNumber numberWithFloat:1.0];
        
        
        animation.duration = self.timeDuration;
        
        //start timer
        _timer = [NSTimer scheduledTimerWithTimeInterval:_step
                                                  target:self
                                                selector:@selector(numberAnimation)
                                                userInfo:nil
                                                 repeats:YES];
        [_progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
        
    } else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction commit];
    }
}

-(void)numberAnimation {
    //Duration 动画持续时长
    _sumSteps += _step;
    if (_sumSteps >= self.timeDuration) {
        //close timer
        [_timer invalidate];
        _timer = nil;
        return;
    }
}

@end
