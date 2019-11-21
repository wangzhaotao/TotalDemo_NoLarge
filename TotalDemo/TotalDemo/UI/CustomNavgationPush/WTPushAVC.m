//
//  WTPushAVC.m
//  TotalDemo
//
//  Created by tyler on 6/6/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTPushAVC.h"

@interface WTPushAVC ()

@end

@implementation WTPushAVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self initUI];
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
    [btn setTitle:@"Test Btn Custom" forState:UIControlStateNormal];
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
    transition.subtype = kCATransitionFromTop;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    Class classBVC = NSClassFromString(@"WTPushBVC");
    UIViewController *vc = [[classBVC alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    [self.navigationController.view.layer addAnimation:transition forKey:@"animation"];
}


@end
