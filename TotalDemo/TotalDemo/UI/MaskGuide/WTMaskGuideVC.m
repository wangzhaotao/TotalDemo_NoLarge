//
//  WTMaskGuideVC.m
//  TotalDemo
//
//  Created by ocean on 2019/1/5.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "WTMaskGuideVC.h"
#import "HWGuidePageManager.h"

@interface WTMaskGuideVC ()
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;

@end

@implementation WTMaskGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    
    // 创建控件
    [self creatControl];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 引导视图
    [self showGuidePage];
}


- (void)creatControl
{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.font = iFont(14);
    label.text = @"iOS是由苹果公司开发的移动操作系统 [1]  。苹果公司最早于2007年1月9日的Macworld大会上公布这个系统，最初是设计给iPhone使用的，后来陆续套用到iPod touch、iPad以及Apple TV等产品上。iOS与苹果的Mac OS X操作系统一样，属于类Unix的商业操作系统。原本这个系统名为iPhone OS，因为iPad，iPhone，iPod touch都使用iPhone OS，所以2010WWDC大会上宣布改名为iOS（iOS为美国Cisco公司网络设备操作系统注册商标，苹果改名已获得Cisco公司授权）。\n2016年1月，随着9.2.1版本的发布，苹果修复了一个存在了3年的漏洞。该漏洞在iPhone或iPad用户在酒店或者机场等访问带强制门户的网络时，登录页面会通过未加密的HTTP连接显示网络使用条款。在用户接受条款后，即可正常上网，但嵌入浏览器会将未加密的Cookie分享给Safari浏览器。利用这种分享的资源，黑客可以创建自主的虚假强制门户，并将其关联至WiFi网络，从而窃取设备上保存的任何未加密Cookie。 [2]\n2018年9月22日，美国苹果公司在最新的操作系统中秘密加入了基于iPhone用户和该公司其他设备使用者的“信任评级”功能。";
    [self.view addSubview:label];
    
    UIButton *btn1 = [[UIButton alloc]init];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"按钮1" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    _btn1 = btn1;
    
    UIButton *btn2 = [[UIButton alloc]init];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"按钮2" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    _btn2 = btn2;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
    }];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.centerX.equalTo(@(-100));
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.centerX.equalTo(@(100));
    }];
}

- (void)showGuidePage
{
    // 判断是否已显示过
    //    if (![[NSUserDefaults standardUserDefaults] boolForKey:HWGuidePageHomeKey]) {
    // 显示
    __weak typeof(self) weakSelf = self;
    [[HWGuidePageManager shareManager] showGuidePageWithType:HWGuidePageTypeMajor maskView:self.btn1 completion:^{
        [[HWGuidePageManager shareManager] showGuidePageWithType:HWGuidePageTypeMajor maskView:weakSelf.btn2];
    }];
    //    }
}



@end
