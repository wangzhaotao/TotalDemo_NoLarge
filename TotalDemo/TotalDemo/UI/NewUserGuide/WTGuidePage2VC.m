//
//  WTGuidePage2VC.m
//  TotalDemo
//
//  Created by ocean on 3/6/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTGuidePage2VC.h"
#import "WTGuidePage3VC.h"

@interface WTGuidePage2VC ()
@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation WTGuidePage2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[BCNewGuidePageManager share]showWithFrame:[UIScreen mainScreen].bounds type:GuidePageType_Event];
}

-(void)onClick:(UIButton*)sender {
    
    WTGuidePage3VC *vc = [WTGuidePage3VC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initUI {
    
    UILabel *label = [IProUtil commonLab:iFont(15) color:iColor(0x00, 0x00, 0x00, 1.0)];
    label.text = @"这是第二个界面";
    [self.view addSubview:label];
    
    UIButton *nextBtn=[IProUtil commonTextBtn:iBFont(dp2po(17)) color:[UIColor whiteColor] title:@"Next"];
    [nextBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [nextBtn setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:nextBtn];
    _nextBtn = nextBtn;
    
    //layout
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    CGFloat w = iScreenW-dp2po(40);
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottomMargin).offset(-dp2po(20));
        make.width.equalTo(@(w));
        make.height.equalTo(@(dp2po(45)));
        make.centerX.equalTo(@0);
    }];
}

@end
