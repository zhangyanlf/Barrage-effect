//
//  UIImage+Extend.m
//  BarrageEffect
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 zhangyanlin. All rights reserved.
//

#import "UIImage+Extend.h"
#import <objc/runtime.h>
@implementation UIImage (Extend)

const char *HMImageX = "HMImageX";
const char *HMImageY = "HMImageY";
const char *HMImageSpeed = "HMImageSpeed";
- (void)setX:(CGFloat)x {
    objc_setAssociatedObject(self, HMImageX, @(x), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)x {
    return [objc_getAssociatedObject(self, HMImageX) floatValue];
}

- (void)setY:(CGFloat)y {
    objc_setAssociatedObject(self, HMImageY, @(y), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)y {
    return [objc_getAssociatedObject(self, HMImageY) floatValue];
}

- (void)setSpeed:(NSInteger)speed{
    objc_setAssociatedObject(self, HMImageSpeed, @(speed), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger) speed {
    return [objc_getAssociatedObject(self, HMImageSpeed) integerValue];
}


   

@end
