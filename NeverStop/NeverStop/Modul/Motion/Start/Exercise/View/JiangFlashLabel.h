//
//  JiangFlashLabel.h
//  NeverStop
//
//  Created by Jiang on 16/10/26.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiangFlashLabel : UILabel
@property (nonatomic, strong) UIColor *spotlightColor;

- (void)startAnimating;

- (void)stopAnimating;
@end
