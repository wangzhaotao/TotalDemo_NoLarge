//
//  HWGuidePageManager.m
//  TransparentGuidePage
//
//  Created by wangqibin on 2018/4/20.
//  Copyright © 2018年 sensmind. All rights reserved.
//

#import "HWGuidePageManager.h"
#import <CoreGraphics/CoreGraphics.h>

@interface HWGuidePageManager ()

@property (nonatomic, copy) FinishBlock finish;
@property (nonatomic, copy) NSString *guidePageKey;
@property (nonatomic, assign) HWGuidePageType guidePageType;



@end

@implementation HWGuidePageManager

+ (instancetype)shareManager
{
    static HWGuidePageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)showGuidePageWithType:(HWGuidePageType)type maskView:(UIView*)maskView
{
    [self creatControlWithType:type maskView:maskView completion:NULL];
}

- (void)showGuidePageWithType:(HWGuidePageType)type maskView:(UIView*)maskView completion:(FinishBlock)completion
{
    [self creatControlWithType:type maskView:maskView completion:completion];
}

- (void)creatControlWithType:(HWGuidePageType)type maskView:(UIView*)maskView completion:(FinishBlock)completion
{
    _finish = completion;

    // 遮盖视图
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] init]; //WithFrame:frame
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(@0);
    }];
    
    // 信息提示视图
    UIImageView *imgView = [[UIImageView alloc] init];
    [bgView addSubview:imgView];
    
    // 第一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    switch (type) {
        case HWGuidePageTypeHome:
        {
            // 下一个路径，圆形
            //maskView?KSuitRect(maskView.frame.origin.x, maskView.frame.origin.y, maskView.frame.size.width, maskView.frame.size.height):
            CGRect maskRect = maskView.frame;
            CGFloat maskR = maskRect.size.width>maskRect.size.height?maskRect.size.width:maskRect.size.height;
            [path appendPath:[UIBezierPath bezierPathWithArcCenter:KSuitPoint(maskRect.origin.x, maskRect.origin.y) radius:KSuitFloat(maskR) startAngle:0 endAngle:2 * M_PI clockwise:NO]];
            imgView.frame = KSuitRect(maskRect.origin.x+maskR/2, maskRect.origin.y-100, 100, 100);
            imgView.image = [UIImage imageNamed:@"hi"];
            //_guidePageKey = HWGuidePageHomeKey;
        }
            break;
            
        case HWGuidePageTypeMajor:
        {
            // 下一个路径，矩形
            CGRect maskRect = maskView.frame;
            [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:KSuitRect(maskRect.origin.x, maskRect.origin.y, 90, 40) cornerRadius:5] bezierPathByReversingPath]];
            imgView.frame = KSuitRect(maskRect.origin.x, maskRect.origin.y-120, 120, 120);
            imgView.image = [UIImage imageNamed:@"ly"];
            //_guidePageKey = HWGuidePageMajorKey;
        }
            break;
            
        default:
            break;
    }
    
    // 绘制透明区域
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [bgView.layer setMask:shapeLayer];
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    UIView *bgView = recognizer.view;
    [bgView removeFromSuperview];
    [bgView removeGestureRecognizer:recognizer];
    [[bgView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    bgView = nil;
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:_guidePageKey];
    
    if (_finish) _finish();
}

@end
