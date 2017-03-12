//
//  JiangSegmentScrollView.h
//  NeverStop
//
//  Created by Jiang on 16/11/7.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiangSegmentScrollView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                  titleArray:(NSArray *)titleArray
            contentViewArray:(NSArray *)contentViewArray;

@end
