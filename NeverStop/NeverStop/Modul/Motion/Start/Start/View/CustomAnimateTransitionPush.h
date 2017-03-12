//
//  CustomAnimateTransitionPush.h
//  NeverStop
//
//  Created by Jiang on 16/10/25.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JiangContentMode) {
    JiangContentModeToExercise, // 1.选择器在视图的下方
    JiangContentModeToMap  // 2.选择器在视图的中间
};

@interface CustomAnimateTransitionPush : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) JiangContentMode contentMode;
@property (nonatomic, strong) UIButton *button;
@end
NS_ASSUME_NONNULL_END
