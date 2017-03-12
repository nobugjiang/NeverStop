//
//  RegisterViewController.h
//  NeverStop
//
//  Created by DYQ on 16/11/7.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterVCDelegate <NSObject>

- (void)getName:(NSString *)name password:(NSString *)password;

@end

@interface RegisterViewController : UIViewController

@property (nonatomic, assign) id<RegisterVCDelegate>delegate;

@end
