//
//  Group.h
//  NeverStop
//
//  Created by dllo on 16/11/7.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "DYQBaseModel.h"
@class GroupInfo;
@class GroupAccount;
@class GroupLocation;
@interface Group : DYQBaseModel
@property (nonatomic, strong) GroupInfo *groupInfo;
@property (nonatomic, strong) GroupAccount *groupAccount;
@property (nonatomic, strong) GroupLocation *groupLocation;
@end
