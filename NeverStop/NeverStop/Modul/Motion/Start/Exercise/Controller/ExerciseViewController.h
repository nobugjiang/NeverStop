//
//  ExerciseViewController.h
//  NeverStop
//
//  Created by Jiang on 16/10/24.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "BaseViewController.h"

@interface ExerciseViewController : BaseViewController
@property (nonatomic, strong) NSString *aim;
@property (nonatomic, assign) NSInteger aimType;
@property (nonatomic, strong) UIButton *endButton;
@property (nonatomic, strong) NSString *exerciseType;
@end
