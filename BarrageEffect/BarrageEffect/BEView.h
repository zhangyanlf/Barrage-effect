//
//  BEView.h
//  BarrageEffect
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 zhangyanlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEModel.h"
@interface BEView : UIView
/**
 *  根据弹幕模型返回一张图文混排的图片
 */
+ (UIImage *)imageWithDanMu:(BEModel *)model;
/**
 *  添加图片
 */
- (void)addImage:(UIImage *)image;
/**
 * 是否关闭弹幕：YES:关闭  NO:不关闭
 */
- (void)closeDanMu:(BOOL)yes;
@end
