//
//  BEView.m
//  BarrageEffect
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 zhangyanlin. All rights reserved.
//

#import "BEView.h"
#import "UIImage+Extend.h"
@interface BEView ()

/**
 *  要删除的图片数组
 */
@property (nonatomic, strong) NSMutableArray *deleteImages;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *images;
/**
 *  定时器
 */
@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation BEView

/**
 * 是否关闭弹幕：YES:关闭  NO:不关闭
 */
- (void)closeDanMu:(BOOL)yes {
    self.hidden = YES;
}

/**
 *  添加弹幕图片
 */
- (void)addImage:(UIImage *)image {
    if (image == nil || self.hidden) return;
    // 设置图片的初始位置
    [self setupImageFrame:image];
    // 将图片添加到数组中
    [self.images addObject:image];
    // 添加定时器
    [self addTimer];
}

/**
 *  设置图片的位置和尺寸
 *
 *  @param image 目标图片
 */
- (void)setupImageFrame:(UIImage *)image{
    // 设置图片的x值等于当前视图的宽度
    image.x = self.frame.size.width;
    // 随机获得一个y值
    image.y = arc4random_uniform(self.frame.size.height - image.size.height);
    // 随机设置速度
    image.speed = arc4random_uniform(3) + 2;
}

/**
 *  绘制图片
 */
- (void)drawRect:(CGRect)rect {
    if (self.images.count == 0) {
        // 销毁定时器
        [self removeTimer];
        return;
    }
    // 遍历图片数组
    for (UIImage * image in self.images) {
        // 图片x值--
        image.x -= image.speed;
        // 绘制图片
        [image drawAtPoint:CGPointMake(image.x, image.y)];
        
        // 判断图片是否超出当前视图
        if(image.x < -image.size.width) {
            [self.deleteImages addObject:image];
        }
    }
    // 删除图片
    for (UIImage *image in self.deleteImages) {
        [self.images removeObject:image];
    }
    [self.deleteImages removeAllObjects];
}

#pragma mark - 定时器相关方法
/**
 *  添加定时器
 */
-(void)addTimer {
    if(self.link) return;
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer {
    [self.link invalidate];
    self.link = nil;
}
/**
 *  根据弹幕模型返回一张图文混排的图片
 */
+ (UIImage *)imageWithDanMu:(BEModel *)beModel{
    // 文本字体大小
    UIFont *font = [UIFont systemFontOfSize:13];
    
    // 计算用户名实际的尺寸
    CGSize nameSize = [beModel.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGFloat nameWidth = nameSize.width;
    CGFloat nameHeight = nameSize.height;
    
    // 计算文本内容实际的尺寸
    CGSize textSize = [beModel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGFloat textWidth = textSize.width;
    CGFloat textHeight = textSize.height;
    
    // 头像的宽高
    CGFloat iconH = 30;
    CGFloat iconW = iconH;
    
    // 头像和文字背景之间的间隙
    CGFloat marginX = 5;
    // 表情之间的间隙
    CGFloat emotionPadding = 0;
    // 表情图片宽高
    CGFloat emotionH = textHeight + marginX;
    CGFloat emotionW = emotionH;
    
    // 位图上下文的尺寸
    // 位图上下文的宽度 = 头像的宽度 + 间距(marginX) + 文本内容的宽度 + 表情的宽度 * 表情个数 + 每一个表情之间的间隙
    CGFloat contextWidth = iconW + 4 * marginX + textWidth + nameWidth + beModel.emotions.count * (emotionW + emotionPadding);
    CGFloat contextHeight = iconH;
    CGSize contextSize = CGSizeMake(contextWidth, contextHeight);
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, 0.0);
    // 获得位图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 保存位图上下文到栈中
    CGContextSaveGState(ctx);
    
    //---------- 绘制头像 ---------- //
    // 绘制头像圆
    CGRect iconFrame = CGRectMake(0, 0, iconW, iconH);
    CGContextAddEllipseInRect(ctx, iconFrame);
    // 裁剪圆形区域
    CGContextClip(ctx);
    // 绘制头像
    [beModel.icon drawInRect:iconFrame];
    // 渲染
    CGContextFillPath(ctx);
    
    // 将位图上下文出栈
    CGContextRestoreGState(ctx);
    
    //---------- 绘制文本背景颜色 ---------- //
    // 绘制文本背景颜色
    if (beModel.type == HMDanMuTypeMe) {
        // 本人发的为红色
        [[UIColor colorWithRed:248 / 255.0 green:100 / 255.0 blue:66/255.0 alpha:0.9] set];
    } else {
        // 其他人发的为白色
        [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9] set];
    }
    
    // 绘制文本背景
    CGFloat textBackgroundX = iconW + marginX;
    CGFloat textBackgroundY = 0;
    CGFloat textBackgroundW = contextWidth - textBackgroundX;
    CGFloat textBackgroundH = contextHeight;
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(textBackgroundX, textBackgroundY,textBackgroundW , textBackgroundH) cornerRadius:20] fill];
    
    //---------- 绘制文本 ---------- //
    // 绘制用户名区域
    CGFloat nameX = textBackgroundX + marginX;
    CGFloat nameY = (contextHeight - textHeight) * 0.5;
    CGRect nameRect = CGRectMake(nameX, nameY, nameWidth, nameHeight);
    // 绘制用户名
    [beModel.username drawInRect:nameRect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:(beModel.type == HMDanMuTypeMe) ? [UIColor blackColor]:[UIColor orangeColor]}];
    
    // 绘制文本区域
    CGFloat textX = nameX + nameWidth + marginX;
    CGFloat textY = (contextHeight - textHeight) * 0.5;
    CGRect textRect = CGRectMake(textX, textY, textWidth, textHeight);
    // 绘制文本
    [beModel.text drawInRect:textRect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:(beModel.type == HMDanMuTypeMe) ? [UIColor whiteColor]:[UIColor blackColor]}];
    
    //---------- 绘制表情图片 ---------- //
    __block CGFloat emotionX = textX + textWidth + emotionPadding;
    CGFloat emotionY = (contextHeight - emotionH) * 0.5 ;
    [beModel.emotions enumerateObjectsUsingBlock:^(NSString * _Nonnull emotionName, NSUInteger idx, BOOL * _Nonnull stop) {
        // 加载表情图片
        UIImage *emotion = [UIImage imageNamed:emotionName];
        // 绘制表情图片
        [emotion drawInRect:CGRectMake(emotionX, emotionY, emotionW, emotionH)];
        // 修改emotionX
        emotionX += emotionW + emotionPadding;
    }];
    
    // 从上下文中获得图片
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    // 关闭位图上下文
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 懒加载数组
- (NSMutableArray *)images {
    if (_images == nil) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}

- (NSMutableArray *)deleteImages {
    if (_deleteImages == nil) {
        _deleteImages = [[NSMutableArray alloc] init];
    }
    return _deleteImages;
}



@end
