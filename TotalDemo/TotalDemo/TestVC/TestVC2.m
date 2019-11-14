//
//  TestVC2.m
//  TotalDemo
//
//  Created by wztMac on 2019/5/12.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "TestVC2.h"
#import "TestVC.h"
#import "WTFirebaseManager.h"
#import <Crashlytics/Crashlytics.h>

@interface TestVC2 ()<TestVCDelegate>
@property (nonatomic, strong) TestVC *vc;
@property (nonatomic, copy) NSString *test;

@end

@implementation TestVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    [self firebaseTest];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 50, 100, 30);
    [button setTitle:@"Crash" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(crashButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //[self gcdTest];
    
    //[self delegateTest];
    
    //[self stackViewTest];
    
}

- (IBAction)crashButtonTapped:(id)sender {
    [[Crashlytics sharedInstance] crash];
}

#pragma mark UIStackView
-(void)stackViewTest {
    
    UIStackView *stackView3 = [[UIStackView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:stackView3];
    stackView3.axis = UILayoutConstraintAxisVertical;
    
    
    UIStackView *stackView = [[UIStackView alloc]initWithFrame:CGRectZero];
    [stackView3 addSubview:stackView];
    stackView.backgroundColor = [UIColor blueColor];
    stackView.distribution = UIStackViewDistributionFillEqually;
    
    UIButton *btn1 = [[UIButton alloc]init];
    [btn1 setTitle:@"Test Btn1" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(clickHiddeBtnActon:) forControlEvents:UIControlEventTouchUpInside];
    btn1.layer.borderWidth = 1.0;
    btn1.layer.borderColor = [UIColor blackColor].CGColor;
    [stackView addArrangedSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc]init];
    [btn2 setTitle:@"Test Btn1" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(clickHiddeBtnActon:) forControlEvents:UIControlEventTouchUpInside];
    btn2.layer.borderWidth = 1.0;
    btn2.layer.borderColor = [UIColor blackColor].CGColor;
    [stackView addArrangedSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc]init];
    [btn3 setTitle:@"Test Btn1" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(clickHiddeBtnActon:) forControlEvents:UIControlEventTouchUpInside];
    btn3.layer.borderWidth = 1.0;
    btn3.layer.borderColor = [UIColor blackColor].CGColor;
    [stackView addArrangedSubview:btn3];
    
    UIButton *btn4 = [[UIButton alloc]init];
    [btn4 setTitle:@"Test Btn1" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(clickHiddeBtnActon:) forControlEvents:UIControlEventTouchUpInside];
    btn4.layer.borderWidth = 1.0;
    btn4.layer.borderColor = [UIColor blackColor].CGColor;
    [stackView addArrangedSubview:btn4];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        make.width.equalTo(@(100));
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        make.height.equalTo(@(100));
    }];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        make.width.equalTo(@(100));
    }];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        make.width.equalTo(@(100));
    }];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@20);
        make.trailing.equalTo(@(-20));
    }];
    
    UIStackView *stackView2 = [[UIStackView alloc]initWithFrame:CGRectZero];
    stackView2.axis = UILayoutConstraintAxisHorizontal;
    stackView2.distribution = UIStackViewDistributionFillEqually;
    [self.view addSubview:stackView2];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"About long long ago....";
    [stackView2 addArrangedSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"About long long ago....";
    [stackView2 addArrangedSubview:label2];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        make.leading.equalTo(@0);
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        make.trailing.equalTo(@0);
    }];
    [stackView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stackView.mas_bottom).offset(5);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@(0));
    }];
    
    
    [stackView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.leading.equalTo(@20);
        make.trailing.equalTo(@(-20));
    }];
    
    
}

-(void)clickHiddeBtnActon:(UIButton*)sender {
    
    sender.hidden = !sender.hidden;
}

#pragma mark firebase
-(void)firebaseTest {
    
    BOOL remoteConfig = [[WTFirebaseManager share]getAppModeGeoEnableStatus];
    NSLog(@"Firebase远程配置开关状态:%@", remoteConfig?@"开":@"关");
}

#pragma mark gcd
-(void)gcdTest {
    
    dispatch_block_t block = dispatch_block_create(0, ^{
        self.test = @"This is test.";
        NSLog(@"test: %@", self.test);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
    
    //    dispatch_sync(dispatch_get_main_queue(), ^{
    //        NSLog(@"这回是一个死锁吗？？？");
    //    });
    
    //UDID 141171e0e0713c041c8884811742b96869939639
    //[self.view addSubview:nil];
}



#pragma mark delegate
-(void)delegateTest {
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"Test Btn" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtnActon:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.frame = CGRectMake(100, 100, 100, 45);
    
    //
    _vc = [[TestVC alloc]init];
    _vc.delegate = self;
}

-(void)clickBtnActon:(UIButton*)btn {
    
    [_vc testMethodButtonAction];
}

-(void)testMethod {
    
    NSLog(@"test");
}



@end
