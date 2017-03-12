//
//  UserModel.h
//  NeverStop
//
//  Created by DYQ on 16/10/31.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *tall;
@property (nonatomic, strong) NSString *weight;

@end
