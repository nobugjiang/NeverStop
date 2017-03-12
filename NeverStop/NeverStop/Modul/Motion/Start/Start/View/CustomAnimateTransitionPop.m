//
//  CustomAnimateTransitionPop.m
//  NeverStop
//
//  Created by Jiang on 16/10/25.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "CustomAnimateTransitionPop.h"
#import "StartViewController.h"
#import "ExerciseViewController.h"
#import <QuartzCore/CALayer.h>
#import "MapViewController.h"

@interface CustomAnimateTransitionPop ()
<CAAnimationDelegate>
@end

@implementation CustomAnimateTransitionPop
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{

    self.transitionContext = transitionContext;
    
    // 获取动画的源控制器和目标控制器
    

    UIViewController *fromVC;
    UIViewController *toVC;
    if (self.contentMode == JiangContentModeBackToExercise) {
        MapViewController *mapVC = (MapViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        ExerciseViewController *exerciseVC = (ExerciseViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
      fromVC = mapVC;
       toVC  = exerciseVC;
    } else {
        ExerciseViewController *exerciseVC = (ExerciseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        StartViewController *startVC = (StartViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        fromVC = exerciseVC;
        toVC = startVC;
    }
    
    
    
    UIView *containerView = [transitionContext containerView];
    UIButton *button = self.button;
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:button.frame];
    
    CGPoint finalPoint;
    
    //判断触发点在哪个象限
    if(button.frame.origin.x > (toVC.view.bounds.size.width / 2)){
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第四象限
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
        }
    }else{
        if (button.frame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第三象限
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(toVC.view.bounds), button.center.y - 0);
        }
    }
    
    CGFloat radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(startPath.CGPath);
    pingAnimation.toValue   = (__bridge id)(finalPath.CGPath);
    pingAnimation.duration = [self transitionDuration:transitionContext];
    pingAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    pingAnimation.delegate = self;
    
    [maskLayer addAnimation:pingAnimation forKey:@"pingInvert"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}
@end
