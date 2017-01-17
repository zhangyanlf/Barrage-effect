//
//  BEModel.m
//  BarrageEffect
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 zhangyanlin. All rights reserved.
//

#import "BEModel.h"

@implementation BEModel
/**
 *  字典转模型方法
 */
+ (instancetype)danMuWithDict:(NSDictionary *)dict {
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
}
@end
