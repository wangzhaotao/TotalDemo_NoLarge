//
//  WTRefreshBtnVC.m
//  TotalDemo
//
//  Created by ocean on 2019/2/11.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "WTRefreshBtnVC.h"
#import "BCFLRefreshBtn.h"

@interface WTRefreshBtnVC ()
@property (nonatomic, strong) BCFLRefreshBtn *refreshBtn;

@end

@implementation WTRefreshBtnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor blueColor];
    BCFLRefreshBtn *refreshBtn = [BCFLRefreshBtn btnNonNormalImg:[UIImage imageNamed:@"live_view_round_off_s_icon"]
                                                      nonHighImg:[UIImage imageNamed:@"live_view_round_off_n_icon"]
                                               selectedNormalImg:[UIImage imageNamed:@"live_view_round_on_n_icon"]
                                                 selectedHighImg:[UIImage imageNamed:@"live_view_round_on_s_icon"]
                                                      disableImg:[UIImage imageNamed:@"live_view_round_off_n_icon"]];
    [refreshBtn addTarget:self action:@selector(setFloodLightSwitchOnOffAction:) forControlEvents:UIControlEventTouchUpInside];
    self.refreshBtn = refreshBtn;
    [self.view addSubview:refreshBtn];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
}

-(void)setFloodLightSwitchOnOffAction:(UIButton*)btn {
    
    [self.refreshBtn refresh:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshBtn refresh:NO];
        if (btn.selected) {
            btn.selected = NO;
        }else{
            btn.selected = YES;
        }
    });
}


@end
