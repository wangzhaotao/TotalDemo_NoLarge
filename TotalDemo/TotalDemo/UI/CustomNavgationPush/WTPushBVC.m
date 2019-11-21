//
//  WTPushBVC.m
//  TotalDemo
//
//  Created by tyler on 6/6/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTPushBVC.h"

@interface WTPushBVC ()

@end

@implementation WTPushBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = iColor(0xef, 0xac, 0xcd, 1.0);
    
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}

-(void)initUI {
    
    [self addTest1Button];
    [self addTest2Button];
}

-(void)addTest1Button {
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"Test Btn Auto" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn1Acton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.frame = CGRectMake(100, 100, 150, 45);
}

-(void)addTest2Button {
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"Pop Back" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn2Acton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.frame = CGRectMake(100, 150, 150, 45);
}

-(void)clickBtn1Acton:(UIButton*)sender {
    
    Class classBVC = NSClassFromString(@"WTPushBVC");
    UIViewController *vc = [[classBVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickBtn2Acton:(UIButton*)sender {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    Class classBVC = NSClassFromString(@"WTPushBVC");
    UIViewController *vc = [[classBVC alloc]init];
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController.view.layer addAnimation:transition forKey:@"animation"];
}


@end
