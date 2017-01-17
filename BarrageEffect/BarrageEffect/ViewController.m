//
//  ViewController.m
//  BarrageEffect
//
//  Created by apple on 17/1/17.
//  Copyright © 2017年 zhangyanlin. All rights reserved.
//

#import "ViewController.h"
#import "BEView.h"
#import "BEModel.h"
@interface ViewController ()
/**弹幕View*/
@property (weak, nonatomic) IBOutlet BEView *beView;

/**
 *  弹幕模型数组
 */
@property (nonatomic, strong) NSArray *danMus;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载数据
    [self loadData];
}

#pragma mark - 加载弹幕数据
- (void)loadData {
    // 获得plist全路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"danMu.plist" ofType:nil];
    // 根据路径加载数据
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    
    // 创建模型数组
    NSMutableArray *danMus = [NSMutableArray array];
    // 遍历数组，字典转模型
    for (NSDictionary *dict in array) {
        // 字典转模型
        BEModel *beModel = [BEModel danMuWithDict:dict];
        // 将模型添加到数组中
        [danMus addObject:beModel];
    }
    // 记录属性
    self.danMus = danMus.copy;
}

/**
 *  监听开关值改变事件
 */
- (IBAction)st:(UISwitch *)sender {
    [self.beView closeDanMu:!sender.on];
    if (sender.on == YES) {
        self.beView.hidden = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获得一个随机整数值
    NSInteger index =  arc4random_uniform((u_int32_t)self.danMus.count);
     //根据随机数获得弹幕模型
    BEModel *beModel = self.danMus[index];
    // 根据弹幕类型设置用户头像
    beModel.icon = beModel.type == HMDanMuTypeMe ? [UIImage imageNamed:@"me"]:[UIImage imageNamed:@"other"];
    
    // 根据弹幕模型生成一张图文混批的图片
    UIImage *image =  [BEView imageWithDanMu:beModel];
    // 添加图片到弹幕view上
    [self.beView addImage:image];
}


@end
