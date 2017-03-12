//
//  Location.h
//  NeverStop
//
//  Created by Jiang on 16/10/27.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double currentSpeed;
@property (nonatomic, assign) BOOL isStart;
@end
