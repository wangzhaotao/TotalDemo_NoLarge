//
//  HWGuidePageManager.h
//  TransparentGuidePage
//
//  Created by wangqibin on 2018/4/20.
//  Copyright © 2018年 sensmind. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height

#define KScreenRate (375 / KMainW)
#define KSuitFloat(float) (float / KScreenRate)
#define KSuitSize(width, height) CGSizeMake(width / KScreenRate, height / KScreenRate)
#define KSuitPoint(x, y) CGPointMake(x / KScreenRate, y / KScreenRate)
#define KSuitRect(x, y, width, heigth) CGRectMake(x / KScreenRate, y / KScreenRate, width / KScreenRate, heigth / KScreenRate)

typedef void(^FinishBlock)(void);

typedef NS_ENUM(NSInteger, HWGuidePageType) {
    HWGuidePageTypeHome = 0,
    HWGuidePageTypeMajor,
};

@interface HWGuidePageManager : NSObject

// 获取单例
+ (instancetype)shareManager;

/**
 显示方法

 @param type 指引页类型
 */
- (void)showGuidePageWithType:(HWGuidePageType)type maskView:(UIView*)maskView;

/**
 显示方法

 @param type 指引页类型
 @param completion 完成时回调
 */
- (void)showGuidePageWithType:(HWGuidePageType)type maskView:(UIView*)maskView completion:(FinishBlock)completion;

@end
