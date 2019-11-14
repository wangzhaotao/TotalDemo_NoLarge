//
//  BCNewGuidePageManager.m
//  BatteryCam
//
//  Created by ocean on 2019/1/7.
//  Copyright © 2019年 oceanwing. All rights reserved.
//

#import "BCNewGuidePageManager.h"
#import "WTGuidePage1VC.h"
#import "WTGuidePage2VC.h"
#import "WTGuidePage3VC.h"
#import "WTGuidePage4VC.h"
#import "WTGuidePage5VC.h"
//#import "BCSecuritySettingsVC_.h"
//#import "BCDeviceArmedSettingVC.h"
//#import "BCCameraList.h"
//#import "BCCamerasVM.h"
//#import "BCNotiTipsUtil.h"


#define kNewGuideDrawMaskPath_Open YES

static CGFloat r_size_arc = 55/2;



static NSString *const kNewGuidePageShowLocalKey = @"kNewGuidePageShowLocalKey";
static NSString *const kOneWeekLongerToShowNewGuideId = @"kOneWeekLongerToShowNewGuideId";
static NSString *const kIngoreToShowNewGuideId = @"kIngoreToShowNewGuideId";
static NSString *const kNewUserFirstToAddDeviceId = @"kNewUserFirstToAddDeviceId";
static NSString *const kShowedFirstGuidePageId = @"kShowedFirstGuidePageId";

static BCNewGuidePageManager *instance = nil;

@interface BCNewGuidePageManager ()
@property (nonatomic, strong) UIView *backTranslucentView;
@property (nonatomic, strong) UIImageView *right_arrow_imgView;

@property (nonatomic, assign) BOOL shouldShowNewGuideView;
@property (nonatomic, assign) GuidePageType type;

@end

@implementation BCNewGuidePageManager

+(instancetype)share {
    
    @synchronized (self) {
        if (!instance) {
            instance = [[BCNewGuidePageManager alloc]init];
            //[BCNewGuidePageManager saveNewUserFirstToAddDevice:NO];
        }
    }
    return instance;
}
-(instancetype)init {
    if (self = [super init]) {
        [iNotiCenter addObserver:self selector:@selector(logoutToResetParams) name:LOGOUT_NOTI object:nil];
    }
    return self;
}
-(void)removeAllMask {
    if (self.backTranslucentView) {
        [self.backTranslucentView removeFromSuperview];
        self.backTranslucentView = nil;
    }
    if (self.right_arrow_imgView) {
        [self.right_arrow_imgView removeFromSuperview];
        self.right_arrow_imgView = nil;
    }
}
-(void)destroyInstance {
    [self removeAllMask];
    instance = nil;
}
-(void)logoutToResetParams {
    [BCNewGuidePageManager saveShowedFirstGuidePage:NO];
}
-(void)dealloc {
    [iNotiCenter removeObserver:self name:LOGOUT_NOTI object:nil];
}

//最小时间间隔为一周
+(BOOL)isOneWeekLongerToShowNewGuide:(GuidePageType)type {
    
    //return YES;
    
    
    //两个时间间隔
    NSString *oneWeekLongerToShowNewGuideKey = [NSString stringWithFormat:@"%@%ld", kOneWeekLongerToShowNewGuideId, type];
    NSUserDefaults *usrDefault = [NSUserDefaults standardUserDefaults];
    NSDate *preDate = [usrDefault objectForKey:oneWeekLongerToShowNewGuideKey];
    NSDate *nowDate = [NSDate date];
    
    //时间间隔: 间隔 分钟
    NSTimeInterval timeInterval = [preDate timeIntervalSinceDate:nowDate];
    BOOL isLongerEnough = fabs(timeInterval/(60*1.0))>=0.01; // *60*24.0  7
#ifdef DEBUG
    //isLongerEnough = fabs(timeInterval/(60*1.0))>=1;
#endif

    
    //是否第一次弹窗
    isLongerEnough = isLongerEnough || !preDate;
    
    if (isLongerEnough) {
        [usrDefault setObject:nowDate forKey:oneWeekLongerToShowNewGuideKey];
        [usrDefault synchronize];
        return YES;
    }
    return NO;
}
+(BOOL)isNewUserFirstToAddDevice {
    NSUserDefaults *usrDefault = [NSUserDefaults standardUserDefaults];
    BOOL isNew = [usrDefault boolForKey:kNewUserFirstToAddDeviceId];
    return isNew;
}
+(void)saveNewUserFirstToAddDevice:(BOOL)firstAdd {
    NSUserDefaults *usrDefault = [NSUserDefaults standardUserDefaults];
    [usrDefault setBool:firstAdd forKey:kNewUserFirstToAddDeviceId];
    [usrDefault synchronize];
}
+(void)saveShowedFirstGuidePage:(BOOL)showedFirst {
    NSUserDefaults *usrDefault = [NSUserDefaults standardUserDefaults];
    [usrDefault setBool:showedFirst forKey:kShowedFirstGuidePageId];
    [usrDefault synchronize];
}
+(BOOL)showedFirstGuidePage {
    NSUserDefaults *usrDefault = [NSUserDefaults standardUserDefaults];
    return [usrDefault boolForKey:kShowedFirstGuidePageId];
}

//正在升级 离线状态，不显示新手指引。
-(void)updateShouldShowNewGuideView {
    //新手指引
    //正在升级、离线 不显示
    BOOL shouldShowNewGuide = YES;
    
    self.shouldShowNewGuideView = shouldShowNewGuide;
}

-(void)dismissBy:(GuidePageType)type{
    if(type == self.type){
        [self removeAllMask];
        [BCNewGuidePageManager saveNewUserFirstToAddDevice:NO];
    }
}



-(void)showWithFrame:(CGRect)frame type:(GuidePageType)type{
    _type = type;
    switch (type) {
        case GuidePageType_None:
            
            break;
        case GuidePageType_Device:
            [self showDeviceGuideWithFrame:frame];
            break;
            
        case GuidePageType_Event:
            [self showEventGuideWithFrame:frame];

            break;
        case GuidePageType_Mode:
            [self showModeGuideWithFrame:frame];

            break;
        case GuidePageType_ModeSetting1:
            [self showModeSettingGuide1WithFrame:frame];

            break;
        case GuidePageType_ModeSetting2:
            [self showModeSettingGuide2WithFrame:frame];

            break;
        case GuidePageType_End:
            
            break;
    }
}

-(void)showDeviceGuideWithFrame:(CGRect)frame {
    [self updateShouldShowNewGuideView];
    
#ifdef DEBUG
    //[BCNewGuidePageManager saveNewUserFirstToAddDevice:YES];
#endif
    
    if (!self.shouldShowNewGuideView || ![BCNewGuidePageManager isNewUserFirstToAddDevice] || ![BCNewGuidePageManager isOneWeekLongerToShowNewGuide:GuidePageType_Device]) {
        return;
    }


    
    //首页的新手指引界面已显示
    [BCNewGuidePageManager saveShowedFirstGuidePage:YES];
    //添加半透明视图
    [self addBackTransLucentView];
    
    //iPhoneX
    CGFloat toolBarHeight = iAppDele->toolBarHeightMax-49;
    if (kNewGuideDrawMaskPath_Open) {
        //绘制遮障层路径
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:screenFrame];
        
        //下方圆
        /*
         当item有三个的时候，每一个item的宽度是屏幕的1/9。
         第一个item的起始位置是1/9*Width，第二个item的起始位置是4/9*Width，第三个item的起始位置是7/9*Width
         */
        CGFloat x_offset = 5;
        if (iScreenW<=320) {
            x_offset = 7;
        }
        CGPoint point = CGPointMake(iScreenW/9+r_size_arc-x_offset, iScreenH-(r_size_arc+toolBarHeight));
        [path appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:r_size_arc startAngle:0 endAngle:2 * M_PI clockwise:NO]];
        
        // 绘制透明区域
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        [self.backTranslucentView.layer setMask:shapeLayer];
    }else {
        
        //切图 icon
        CGFloat w_icon = iScreenW/9;
        UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"device_guide_icon"]];
        [self.backTranslucentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(dp2po(w_icon)));
            make.bottom.equalTo(@(-dp2po(5)-toolBarHeight));
        }];
    }
    
    //imgView
    CGFloat y_origin = 135;
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tap_slide_icon"]];
    [self.backTranslucentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(dp2po(30)));
        make.top.equalTo(@(dp2po(y_origin)));
    }];
    
    //tipLabel
    UILabel *tipLabel = [self addTipLabelWithTip:NSLocalizedString(@"bc.newguidepage.tap_refresh_devices", 0)];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(dp2po(10));
        make.leading.equalTo(@(dp2po(50)));
        make.trailing.equalTo(@(-dp2po(50)));
    }];
    
    //next button
    UIButton *nextButton = [self addNextButtonWithText:NSLocalizedString(@"bc.common.next", 0)];
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(dp2po(30));
        make.centerX.equalTo(@0);
        make.width.equalTo(@(dp2po(150)));
    }];
}

-(void)showEventGuideWithFrame:(CGRect)frame {
    if (![BCNewGuidePageManager showedFirstGuidePage] || !self.shouldShowNewGuideView || ![BCNewGuidePageManager isNewUserFirstToAddDevice] || ![BCNewGuidePageManager isOneWeekLongerToShowNewGuide:_type]) {
        return;
    }
    //添加半透明视图
    [self addBackTransLucentView];
    
    //iPhoneX
    CGFloat toolBarHeight = iAppDele->toolBarHeightMax-49;
    if (kNewGuideDrawMaskPath_Open) {
        //绘制遮障层路径
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        CGFloat maskHeight = 45;
        CGFloat statusBarHeight = iAppDele->statusBarHeightMax;
        CGFloat mask_y = statusBarHeight;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:screenFrame];
        //方框
        CGRect targetRect = frame ;//CGRectMake((iScreenW-150)/2, mask_y, 150, maskHeight);
        [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:10] bezierPathByReversingPath]];
        //下方圆
        CGPoint point = CGPointMake(iScreenW/2, iScreenH-(r_size_arc+1+toolBarHeight));
        [path appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:r_size_arc startAngle:0 endAngle:2 * M_PI clockwise:NO]];
        
        // 绘制透明区域
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        [self.backTranslucentView.layer setMask:shapeLayer];
    }else {
        
        //icon
        UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"event_guide_icon"]];
        [self.backTranslucentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@(0));
            make.bottom.equalTo(@(-dp2po(5)-toolBarHeight));
        }];
        
        //imgView
        CGFloat y_origin = 20;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"event_guide_contral"]];
        [self.backTranslucentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(@(dp2po(y_origin)));
        }];
    }
    
    //tipLabel
    UILabel *tipLabel = [self addTipLabelWithTip:NSLocalizedString(@"bc.newguidepage.tap_filte_devices", 0)];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(dp2po(64+30)));
        make.leading.equalTo(@(dp2po(50)));
        make.trailing.equalTo(@(-dp2po(50)));
    }];
    
    //next button
    UIButton *nextButton = [self addNextButtonWithText:NSLocalizedString(@"bc.common.next", 0)];
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(dp2po(30));
        make.centerX.equalTo(@0);
        make.width.equalTo(@(dp2po(150)));
    }];
}

-(void)showModeGuideWithFrame:(CGRect)frame {
    if (![BCNewGuidePageManager showedFirstGuidePage] || !self.shouldShowNewGuideView || ![BCNewGuidePageManager isNewUserFirstToAddDevice] || ![BCNewGuidePageManager isOneWeekLongerToShowNewGuide:_type]) {
        return;
    }
    //添加半透明视图
    [self addBackTransLucentView];
    
    //iPhoneX
    CGFloat toolBarHeight = iAppDele->toolBarHeightMax-49;
    if (kNewGuideDrawMaskPath_Open) {
        //绘制遮障层路径
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        CGFloat maskHeight = frame.size.height;
        CGFloat mask_y = frame.origin.y-1;
        CGFloat right_rect_w = dp2po(55);
        if (iScreenW<=320) {
            mask_y = frame.origin.y-2;
            maskHeight = frame.size.height-3;
            right_rect_w = dp2po(53);
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:screenFrame];
        //左侧方框
        CGRect targetRect = CGRectMake(15, mask_y, iScreenW-dp2po(100), maskHeight);
        [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:10] bezierPathByReversingPath]];
        //右侧方框
        targetRect = CGRectMake(iScreenW-dp2po(70), mask_y, right_rect_w, maskHeight);
        [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:10] bezierPathByReversingPath]];
        //下方圆
        CGFloat x_offset = 5;
        if (iScreenW<=320) {
            x_offset = 7;
        }
        CGFloat toolBarHeight = iAppDele->toolBarHeightMax-49;
        CGPoint point = CGPointMake(iScreenW*7/9+r_size_arc-x_offset, iScreenH-(r_size_arc+1+toolBarHeight));
        [path appendPath:[UIBezierPath bezierPathWithArcCenter:point radius:r_size_arc startAngle:0 endAngle:2 * M_PI clockwise:NO]];
        
        // 绘制透明区域
        CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
        shapeLayer1.path = path.CGPath;
        [self.backTranslucentView.layer setMask:shapeLayer1];
    }else {
        //切图
        CGFloat w_icon = iScreenW/9;
        UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mode_guide_icon"]];
        [self.backTranslucentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@(-dp2po(w_icon)));
            make.bottom.equalTo(@(-dp2po(5)-toolBarHeight));
        }];
        
        //left imgView
        CGFloat y_origin = frame.origin.y-1;
        CGFloat x_origin_left = 18;
        CGFloat left_w = iScreenW-x_origin_left-dp2po(20)-44-5;
        UIImageView *left_imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mode_switch_icon"]];
        [self.backTranslucentView addSubview:left_imgView];
        [left_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(y_origin));
            make.leading.equalTo(@(dp2po(x_origin_left)));
            make.width.lessThanOrEqualTo(@(left_w));
        }];
        
        //right imgView
        UIImageView *right_imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mode_set_icon"]];
        [self.backTranslucentView addSubview:right_imgView];
        [right_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@(-dp2po(20)));
            make.top.equalTo(@(y_origin));
        }];
    }
    
    
    //left tipLabel
    UILabel *left_tipLabel = [self addTipLabelWithTip:NSLocalizedString(@"bc.newguidepage.tap_switch_mode", 0)];
    UIImageView *left_arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down_guide_icon"]];
    [self.backTranslucentView addSubview:left_arrow];
    [left_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(left_arrow.mas_top).offset(-dp2po(10));
        make.leading.equalTo(@(dp2po(20)));
        make.width.equalTo(@(iScreenW/2));
    }];
    [left_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.bottom.equalTo(left_imgView.mas_top).offset(-dp2po(10));
        make.bottom.equalTo(@(frame.origin.y-iScreenH-10));
        make.centerX.equalTo(left_tipLabel);
    }];
    
    //right tipLabel
    UILabel *right_tipLabel = [self addTipLabelWithTip:NSLocalizedString(@"bc.newguidepage.tap_set_mode", 0)];
    UIImageView *right_arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down_guide_icon"]];
    [self.backTranslucentView addSubview:right_arrow];
    [right_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(right_arrow.mas_top).offset(-dp2po(10));
        make.trailing.equalTo(@(-10));
        make.width.equalTo(@(iScreenW/4));
    }];
    [right_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.bottom.equalTo(left_imgView.mas_top).offset(-dp2po(10));
        make.bottom.equalTo(@(frame.origin.y-iScreenH-10));
        make.centerX.equalTo(right_tipLabel.mas_centerX).offset(dp2po(10));
    }];
    
    //next button
    UIButton *nextButton = [self addNextButtonWithText:NSLocalizedString(@"bc.common.next", 0)];
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(frame.origin.y+dp2po(100)+30));
        make.centerX.equalTo(@0);
        make.width.equalTo(@(dp2po(150)));
    }];
}

-(void)showModeSettingGuide1WithFrame:(CGRect)frame {
    if (![BCNewGuidePageManager showedFirstGuidePage] || !self.shouldShowNewGuideView || ![BCNewGuidePageManager isNewUserFirstToAddDevice] || ![BCNewGuidePageManager isOneWeekLongerToShowNewGuide:_type]) {
        return;
    }
    //添加半透明视图
    [self addBackTransLucentView];
    
    //适配
    CGFloat statusBarHeight = iAppDele->statusBarHeightMax;
    CGFloat navBarHeight = statusBarHeight+44;
    CGFloat y_origin = navBarHeight;
    CGFloat maskHeight = frame.size.height;
    if (kNewGuideDrawMaskPath_Open) {
        //遮障图层
        //绘制路径
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        CGRect targetRect = CGRectMake(5, y_origin, iScreenW-10, maskHeight);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:screenFrame];
        [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:5] bezierPathByReversingPath]];
        
        // 绘制透明区域
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        [self.backTranslucentView.layer setMask:shapeLayer];
        
        //图标
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat arrow_h = 108/2;
        if (scale==3) {
            arrow_h = 162/2;
        }
        UIImageView *right_arrow_imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mode_setting_right"]];
        [[UIApplication sharedApplication].keyWindow addSubview:right_arrow_imgView];
        [right_arrow_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@(-(dp2po(5))));
            make.top.equalTo(@(y_origin+18));
        }];
        _right_arrow_imgView = right_arrow_imgView;
    }else {
        
        //切图
        //imgView
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mode_setting_control"]];
        [self.backTranslucentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(@(dp2po(y_origin)));
        }];
    }
    
    //next button
    UIButton *nextButton = [self addNextButtonWithText:NSLocalizedString(@"bc.common.next", 0)];
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(frame.origin.y+maskHeight+50));
        make.centerX.equalTo(@0);
        make.width.equalTo(@(dp2po(150)));
    }];
}

-(void)showModeSettingGuide2WithFrame:(CGRect)frame {
    if (![BCNewGuidePageManager showedFirstGuidePage] || !self.shouldShowNewGuideView || ![BCNewGuidePageManager isNewUserFirstToAddDevice] || ![BCNewGuidePageManager isOneWeekLongerToShowNewGuide:_type]) {
        return;
    }
    //添加半透明视图
    [self addBackTransLucentView];
    //设置
    [BCNewGuidePageManager saveNewUserFirstToAddDevice:NO];
    [BCNewGuidePageManager saveShowedFirstGuidePage:NO];
    
    //绘制路径
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGFloat maskHeight = dp2po(48*5);
    CGFloat mask_y = frame.origin.y;
    if (iScreenW<=320) {
        mask_y = frame.origin.y-21;
    }
    CGRect targetRect = CGRectMake(frame.origin.x+5, mask_y, 200, maskHeight);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:screenFrame];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:5] bezierPathByReversingPath]];
    
    // 绘制透明区域
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.backTranslucentView.layer setMask:shapeLayer];
    
    //tipLabel
    UILabel *tipLabel = [self addTipLabelWithTip:NSLocalizedString(@"bc.newguidepage.set_mode_actions", 0)];
    UIImageView *tip_arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"up_guide_icon"]];
    [self.backTranslucentView addSubview:tip_arrow];
    //箭头 文字 按钮 适配
    CGFloat dy = dp2po(10);
    CGFloat next_dy = dp2po(30);
    CGFloat tip_y = targetRect.origin.y+targetRect.size.height+dy;
    if (iScreenW<=320) {
        next_dy = dp2po(10);
    }
    [tip_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(tip_y));
        make.centerX.equalTo(tipLabel);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tip_arrow.mas_bottom).offset(dp2po(dy));
        make.leading.equalTo(@5);
        make.width.equalTo(@(targetRect.size.width-10));
    }];
    
    //next button
    UIImage *finish_backImg = [UIImage imageNamed:@"finish_guide_btn"];
    UIButton *nextButton = [self addNextButtonWithText:NSLocalizedString(@"bc.common.finish", 0)];
    [nextButton setBackgroundImage:[finish_backImg resizableStretchImg] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(popToDeviceMainView) forControlEvents:UIControlEventTouchUpInside];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(dp2po(next_dy));
        make.centerX.equalTo(@0);
        make.width.equalTo(@(dp2po(150)));
    }];
}

#pragma mark private mthods
-(void)addBackTransLucentView {
    
    if (_backTranslucentView) {
        [_backTranslucentView removeFromSuperview];
        _backTranslucentView = nil;
    }
    if (_right_arrow_imgView) {
        [_right_arrow_imgView removeFromSuperview];
        _right_arrow_imgView = nil;
    }
    
    //半透明视图
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(@0);
    }];
    
    _backTranslucentView = bgView;
}
-(UIButton*)addNextButtonWithText:(NSString*)title {
    
    UIImage *nextImg = [UIImage imageNamed:@"next_guide_btn"];
    UIButton *nextButton = [IProUtil commonTextBtn:iFont(18) color:iColor(0xff, 0xff, 0xff, 1.0) title:title];
    [nextButton setBackgroundImage:[nextImg resizableStretchImg] forState:UIControlStateNormal];
    [self.backTranslucentView addSubview:nextButton];
    return nextButton;
}
-(UILabel*)addTipLabelWithTip:(NSString*)tip {
    
    UILabel *tipLabel = [IProUtil commonLab:iFont(18) color:iColor(0xff, 0xff, 0xff, 1.0)];
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = tip;
    [self.backTranslucentView addSubview:tipLabel];
    
    return tipLabel;
}
-(void)popToDeviceMainView {
    
    //删除遮障层
    [self destroyInstance];
    //pop
    if ([UIViewController.curVC isKindOfClass:[WTGuidePage5VC class]]) {
        NSMutableArray *controlsArray = [NSMutableArray arrayWithArray:UIViewController.curVC.navigationController.viewControllers];
        [controlsArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"WTGuidePage4VC")] ||
                [obj isKindOfClass:NSClassFromString(@"WTGuidePage3VC")] ||
                [obj isKindOfClass:NSClassFromString(@"WTGuidePage2VC")]) {
                [controlsArray removeObject:obj];
            }
        }];
        UIViewController.curVC.navigationController.viewControllers = controlsArray;
        
        [UIViewController popVC];
    }else{
        NSArray *vcs = UIViewController.curVC.navigationController.viewControllers;
        UIViewController *vc = nil;
        for (UIViewController *c in vcs) {
            if ([NSStringFromClass([c class]) isEqualToString:@"WTGuidePage1VC"]) {
                vc = c;
                break;
            }
        }
        if (vc) {
            [UIViewController.curVC.navigationController popToViewController:vc animated:YES];
        }
    }
    runOnMain(^{
        //iAppDele.mainVC.tabVC.selectedIndex=0;
    });
}

#pragma Mark actions
-(void)tapGestureAction:(UIGestureRecognizer*)gesture {
    
    _type++;
    _backTranslucentView.userInteractionEnabled = NO;
    if (_type>=GuidePageType_End) {
        [self destroyInstance];
        //[BCNewGuidePageManager saveNewUserFirstToAddDevice:NO];
        [self performSelector:@selector(popToDeviceMainView) withObject:nil afterDelay:0.25];
        return;
    }
    if (!_shouldShowNewGuideView) {
        [self destroyInstance];
        return;
    }
    
    
    if (_type == GuidePageType_Device) {
        
        [self showDeviceGuideWithFrame:CGRectZero];
        if ([UIViewController.curVC isKindOfClass:NSClassFromString(@"WTGuidePage3VC")]) {
            WTGuidePage3VC *vc = (WTGuidePage3VC*)UIViewController.curVC;
            [vc onClick:nil];
        }
        
    }else if (_type == GuidePageType_Event) {
        
        //iAppDele.mainVC.tabVC.selectedIndex=1;
        if ([UIViewController.curVC isKindOfClass:NSClassFromString(@"WTGuidePage1VC")]) {
            WTGuidePage1VC *vc = (WTGuidePage1VC*)UIViewController.curVC;
            [vc onClick:nil];
        }
        
    }else if (_type == GuidePageType_Mode) {
        
        //[self removeAllMask];
        //iAppDele.mainVC.tabVC.selectedIndex=2;
        if ([UIViewController.curVC isKindOfClass:NSClassFromString(@"WTGuidePage2VC")]) {
            WTGuidePage2VC *vc = (WTGuidePage2VC*)UIViewController.curVC;
            [vc onClick:nil];
        }
        
    }else if (_type == GuidePageType_ModeSetting1) {
        
        //[self removeAllMask];
        if ([UIViewController.curVC isKindOfClass:NSClassFromString(@"WTGuidePage3VC")]) {
            WTGuidePage3VC *vc = (WTGuidePage3VC*)UIViewController.curVC;
            [vc onClick:nil];
        }
        
    }else if (_type == GuidePageType_ModeSetting2) {
        
        if ([UIViewController.curVC isKindOfClass:NSClassFromString(@"WTGuidePage4VC")]) {
            WTGuidePage4VC *vc = (WTGuidePage4VC*)UIViewController.curVC;
            [vc onClick:nil];
        }
    }
}

-(void)nextButtonAction:(UIButton*)sender {
    
    [self tapGestureAction:nil];
}


@end
