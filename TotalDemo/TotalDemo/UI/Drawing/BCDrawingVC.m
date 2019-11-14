//
//  BCDrawingVC.m
//  TotalDemo
//
//  Created by tyler on 8/6/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "BCDrawingVC.h"
#import "Masonry.h"
#import "BCFLMotionDistanceView.h"

@interface BCDrawingVC ()<BCFLMotionDistanceViewDelegate>
@property (nonatomic, strong) BCFLMotionDistanceView *drawView;

@end

@implementation BCDrawingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    BCFLMotionDistanceView *drawView = [[BCFLMotionDistanceView alloc]init];
    drawView.delegate = self;
    [self.view addSubview:drawView];
    _drawView = drawView;
    [drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.centerX.equalTo(@0);
        make.width.equalTo(@(iScreenW));
        make.height.equalTo(@300);
    }];
    
}

static int redius = 2;
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    redius += 3;
    redius = redius%20;
    
    _drawView.redius = redius;
}

#pragma mark BCFLMotionDistanceViewDelegate
-(void)updateFLLightPirMotionDistanceValue:(NSInteger)value {
    
    NSLog(@"----更新value = %d ----", value);
}


@end
