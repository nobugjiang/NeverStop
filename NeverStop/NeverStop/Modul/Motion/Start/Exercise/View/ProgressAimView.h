//
//  ProgressAimView.h
//  NeverStop
//
//  Created by Jiang on 16/10/29.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProgressAimViewDelegate <NSObject>

- (void)aimIsCompleted;

@end

@interface ProgressAimView : UIView

@property (nonatomic, assign) CGFloat currentNumber;
- (instancetype)initWithFrame:(CGRect)frame aim:(NSString *)aim aimType:(NSInteger)aimType;
@property (nonatomic, weak) id<ProgressAimViewDelegate> delegate;
@end
