//
//  CustomAnimateTransitionPop.h
//  NeverStop
//
//  Created by Jiang on 16/10/25.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JiangContentModeBack) {
    JiangContentModeBackToStart, // 1.选择器在视图的下方
    JiangContentModeBackToExercise  // 2.选择器在视图的中间
};
@interface CustomAnimateTransitionPop : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) JiangContentModeBack contentMode;
@property (nonatomic, strong) UIButton *button;
@property(nonatomic,strong)id<UIViewControllerContextTransitioning>transitionContext;

@end
NS_ASSUME_NONNULL_END
