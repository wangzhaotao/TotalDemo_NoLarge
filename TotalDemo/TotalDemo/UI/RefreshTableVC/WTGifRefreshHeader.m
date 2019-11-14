//
//  WTGifRefreshHeader.m
//  TotalDemo
//
//  Created by tyler on 11/14/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTGifRefreshHeader.h"

@implementation WTGifRefreshHeader


#pragma mark - 实现父类的方法
- (void)prepare {
    
    [super prepare];
    // 初始化间距
    self.labelLeftInset = 20;
    // 资源数据（GIF每一帧）
    NSArray *idleImages = [self getRefreshingImageArrayWithStartIndex:0 endIndex:10];
    NSArray *refreshingImages = [self getRefreshingImageArrayWithStartIndex:11 endIndex:20];
    NSArray *endImages = [self getRefreshingImageArrayWithStartIndex:21 endIndex:39];
    // 普通状态
    [self setImages:idleImages forState:MJRefreshStateIdle];
    // 即将刷新状态
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    // 正在刷新状态
    [self setImages:endImages forState:MJRefreshStateRefreshing];
    
}


#pragma mark - 获取资源图片
- (NSArray *)getRefreshingImageArrayWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animation-%zd", i]];
        if (image) {
            [result addObject:image];
        }
    }
    return result;
    
}


@end
