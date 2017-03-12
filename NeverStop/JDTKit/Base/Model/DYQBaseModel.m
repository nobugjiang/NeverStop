//
//  DYQBaseModel.m
//  DYQ_One
//
//  Created by dllo on 16/9/20.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "DYQBaseModel.h"

@implementation DYQBaseModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (DYQBaseModel *)modelWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}


@end
