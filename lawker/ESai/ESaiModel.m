//
//  SXErtailModel.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "ESaiModel.h"

@implementation ESaiModel

+ (instancetype)ESwsModelWithDict:(NSDictionary *)dict
{
    ESaiModel *model2 = [[self alloc]init];
    
    [model2 setValuesForKeysWithDictionary:dict];
    
    return model2;
}

@end
