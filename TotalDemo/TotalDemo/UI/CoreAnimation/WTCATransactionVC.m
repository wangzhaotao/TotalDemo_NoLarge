//
//  WTCATransactionVC.m
//  TotalDemo
//
//  Created by tyler on 7/31/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTCATransactionVC.h"

@interface WTCATransactionVC ()
@property (nonatomic, strong) UIView *layerView;
@property (nonatomic, strong) CALayer *colorLayer;

@end

@implementation WTCATransactionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    //[self test1];
    
    [self test2];
}

-(void)test2 {
    
    //
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the touch point
    CGPoint point = [[touches anyObject] locationInView:self.view];
    //check if we've tapped the moving layer
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        //randomize the layer background color
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    } else {
        //otherwise (slowly) move the layer to new position
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
}

-(void)test1 {
    
    //
    UIView *layerView = [[UIView alloc]init];
    layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:layerView];
    _layerView = layerView;
    
    CALayer *colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layerView.layer addSublayer:colorLayer];
    _colorLayer = colorLayer;
    
    UIButton *changeBtn = [[UIButton alloc]init];
    [changeBtn setTitle:@"Change Color" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    
    [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(30));
        make.trailing.equalTo(@(-30));
        make.center.equalTo(@0);
        make.height.equalTo(@200);
    }];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(layerView.mas_bottom).offset(30);
    }];
}

- (void)changeColor
{
    
    
#if 1
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    //[CATransaction setDisableActions:YES];
    [CATransaction begin];
    NSLog(@"1111: %.2f", [CATransaction animationDuration]);
    self.layerView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    [CATransaction commit];
    
#else
    //randomize the layer background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    //[CATransaction setDisableActions:YES];
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    NSLog(@"1111: %.2f", [CATransaction animationDuration]);
    [CATransaction setCompletionBlock:^{
        NSLog(@"2222: %.2f", [CATransaction animationDuration]);
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        self.colorLayer.affineTransform = transform;
    }];
    _colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    [CATransaction commit];
#endif
}






@end
