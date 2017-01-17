//
//  BEModel.h
//  BarrageEffect
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 zhangyanlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    HMDanMuTypeOther, // 别人发的
    HMDanMuTypeMe, // 自己发的
} HMDanMuType;

@interface BEModel : NSObject
/**
 *  弹幕类型
 */
@property (nonatomic, assign) HMDanMuType type;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *username;
/**
 *  文本内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *  头像
 */
@property (nonatomic, copy) UIImage *icon;
/**
 *  表情图片名数组
 */
@property (nonatomic, strong) NSArray <NSString *> *emotions;
/**
 *  字典转模型方法
 */
+(instancetype)danMuWithDict:(NSDictionary *)dict;
@end
