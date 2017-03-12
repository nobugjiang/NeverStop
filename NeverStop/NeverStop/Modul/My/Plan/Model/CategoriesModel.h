//
//  CategoriesModel.h
//  NeverStop
//
//  Created by DYQ on 16/11/1.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "DYQBaseModel.h"

@interface CategoriesModel : DYQBaseModel

@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *categoryDesc;
@property (nonatomic, strong) NSString *categoryImg;

@end
