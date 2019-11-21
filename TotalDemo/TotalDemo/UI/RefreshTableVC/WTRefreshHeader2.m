//
//  WTRefreshHeader2.m
//  TotalDemo
//
//  Created by tyler on 11/16/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTRefreshHeader2.h"
#import "LOTAnimationView.h"

#define BALLOON_GIF_DURATION 0.15

@interface WTRefreshHeader2 ()
@property (nonatomic, strong) LOTAnimationView *animation;

@end

@implementation WTRefreshHeader2

#pragma mark - 懒加载
-(LOTAnimationView*)animation {
    
    if (!_animation) {
        LOTAnimationView *animation = [LOTAnimationView animationNamed:@"loading" inBundle:[NSBundle mainBundle]];
        animation.loopAnimation = YES;
        [self addSubview:animation];
        [animation playWithCompletion:^(BOOL animationFinished) {
        }];
        _animation = animation;
    }
    return _animation;
}

#pragma mark - 实现父类的方法
- (void)prepare {
    
    [super prepare];
    // 初始化间距
    self.labelLeftInset = 20;
    
}

- (void)placeSubviews{
    
    [super placeSubviews];
    self.stateLabel.hidden = NO;
    self.lastUpdatedTimeLabel.hidden = YES;
    
    //
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat widthRefresh = kScreenWidth/4;
    CGFloat heightRefresh = widthRefresh;
    CGFloat height = heightRefresh+30;
    self.bounds = CGRectMake(0, 0, kScreenWidth, height);
    [self.animation mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@5);
        make.width.equalTo(@(widthRefresh));
        make.height.equalTo(@(heightRefresh));
    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(self.animation.mas_bottom);
        make.height.equalTo(@(30));
    }];
}


#pragma mark - 开始动画



#pragma mark - 获取资源图片


@end
