//
//  WTCrashExceptionVC.m
//  TotalDemo
//
//  Created by tyler on 4/10/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTCrashExceptionVC.h"
#import "WTCrashExpectionHandler.h"
#import "Masonry.h"

@interface WTCrashExceptionVC ()

@end

@implementation WTCrashExceptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    
    [self initUI];
    
    
}


-(void)initUI {
    
    UIButton *btn1 = [[UIButton alloc]init];
    btn1.layer.cornerRadius = 5.0;
    btn1.layer.masksToBounds = YES;
    btn1.layer.borderWidth = 0.5;
    btn1.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [btn1 setTitle:@"触发崩溃按钮事件1" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(crashBtn1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]init];
    btn2.layer.cornerRadius = 5.0;
    btn2.layer.masksToBounds = YES;
    btn2.layer.borderWidth = 0.5;
    btn2.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [btn2 setTitle:@"触发崩溃按钮事件2" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(crashBtn2Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc]init];
    btn3.layer.cornerRadius = 5.0;
    btn3.layer.masksToBounds = YES;
    btn3.layer.borderWidth = 0.5;
    btn3.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [btn3 setTitle:@"触发崩溃按钮事件3" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(crashBtn3Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [[UIButton alloc]init];
    btn4.layer.cornerRadius = 5.0;
    btn4.layer.masksToBounds = YES;
    btn4.layer.borderWidth = 0.5;
    btn4.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    [btn4 setTitle:@"触发崩溃按钮事件4" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(crashBtn4Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    //
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.leading.equalTo(@50);
        make.trailing.equalTo(@-50);
        make.height.equalTo(@40);
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn1.mas_bottom).offset(15);
        make.leading.equalTo(@50);
        make.trailing.equalTo(@-50);
        make.height.equalTo(@40);
    }];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn2.mas_bottom).offset(15);
        make.leading.equalTo(@50);
        make.trailing.equalTo(@-50);
        make.height.equalTo(@40);
    }];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn3.mas_bottom).offset(15);
        make.leading.equalTo(@50);
        make.trailing.equalTo(@-50);
        make.height.equalTo(@40);
    }];
}

-(void)crashBtn1Action:(UIButton*)sender {
    
    NSArray *tmp = @[@"1", @"2"];
    NSLog(@"%@", tmp[2]);
}

-(void)crashBtn2Action:(UIButton*)sender {
    
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:@[@"1", @"2"]];
    for (NSString *str in tmp) {
        if ([str isEqualToString:@"2"]) {
            [tmp removeObject:str];
        }
    }
}

-(void)crashBtn3Action:(UIButton*)sender {
    
    NSString *str = nil;
    NSAttributedString *attributeStr = [[NSAttributedString alloc]initWithString:str];
    NSLog(@"%@", attributeStr);
}

-(void)crashBtn4Action:(UIButton*)sender {
    
    NSString *tmp = nil;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"key1"];
    [dic setObject:tmp forKey:@"key2"];
    NSLog(@"%@", dic);
}




@end
