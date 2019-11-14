//
//  BCLocalStorageVC.m
//  TotalDemo
//
//  Created by ocean on 3/5/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "BCLocalStorageVC.h"
#import "BCDrawLocalStorageView.h"
#import "TestDrawView.h"

@interface BCLocalStorageVC ()
@property (nonatomic, strong) BCDrawLocalStorageView *drawView;

@end

@implementation BCLocalStorageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"内存使用视图";
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.drawView updateWithTotal:100 system:7.2 video:21.0];
    
//    [self addDrawView];
//
//    [self addDrawViewTest];
}

-(BCDrawLocalStorageView*)drawView {
    if (!_drawView) {
        _drawView = [[BCDrawLocalStorageView alloc]init];
        [self.view addSubview:_drawView];
        
        [_drawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(120));
            make.leading.trailing.equalTo(@0);
            //CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            //make.width.equalTo(@(screenWidth));
        }];
    }
    return _drawView;
}

-(void)addDrawViewTest {
    
    TestDrawView *test = [[TestDrawView alloc]init];
    [self.view addSubview:test];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    test.frame = CGRectMake(15, 450, screenWidth-30, 50);
    [test setNeedsDisplay];
}

-(void)addDrawView {
    
    BCDrawStorageView *drawView = [[BCDrawStorageView alloc]init];
    [self.view addSubview:drawView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    drawView.frame = CGRectMake(15, 350, screenWidth-30, 50);
    
//    __weak typeof(self) weakSelf = self;
//    [drawView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(@15);
//        make.trailing.equalTo(@(-15));
//        make.height.equalTo(@100);
//        make.top.equalTo(weakSelf.drawView.mas_bottom).offset(15);
//    }];
    
    NSArray *colorArray = @[iColor(0xff, 0xc8, 0x50, 1.0), iColor(0xff, 0x91, 0x46, 1.0),
                            iColor(0xec, 0xec, 0xec, 1.0)];
    [drawView updateWithColorArray:colorArray numberArray:@[[NSNumber numberWithFloat:7.2],
                                                                      [NSNumber numberWithFloat:21.1],
                                                                      [NSNumber numberWithFloat:71.8]
                                                                      ]
     ];
}




@end
