//
//  BCFLMotionDistanceView.m
//  BatteryCam
//
//  Created by tyler on 8/6/19.
//  Copyright © 2019 oceanwing. All rights reserved.
//

#import "BCFLMotionDistanceView.h"

@interface BCFLMotionDistanceView ()
@property (nonatomic, assign) CGPoint beginPoint;

@end

@implementation BCFLMotionDistanceView

-(instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark private
-(void)drawEndedToUpdateDistance {
    
    CGFloat max_redius = dp2po(kMaxMotionDistanceRedius);
    CGFloat min_redius = dp2po(kMinMotionDistanceRedius);
    
    CGFloat radio = (kMaxMotionDistanceValue-kMinMotionDistanceValue)/(max_redius-min_redius);
    
    CGFloat distance = (_redius-kMinMotionDistanceRedius)*radio;
    distance += kMinMotionDistanceValue;
    distance = distance<kMinMotionDistanceValue?kMinMotionDistanceValue:distance;
    distance = distance>kMaxMotionDistanceValue?kMaxMotionDistanceValue:distance;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateFLLightPirMotionDistanceValue:)]) {
        [self.delegate updateFLLightPirMotionDistanceValue:distance];
    }
}

#pragma mark set/get
-(void)setRedius:(CGFloat)redius {
    
    if (_redius != redius) {
        _redius = redius;
        [self setNeedsDisplay];
    }
}


#pragma mark 重写 画图
// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect {
    
    CGPoint startPoint = CGPointMake(self.bounds.size.width/2, 0);
    CGFloat max_redius = dp2po(kMaxMotionDistanceRedius);
    CGFloat min_redius = dp2po(kMinMotionDistanceRedius);
    CGFloat new_redius = _redius;
    if (new_redius<min_redius) {
        new_redius = min_redius;
    }
    if (new_redius>max_redius) {
        new_redius = max_redius;
    }
    _redius = new_redius;
    
    //上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*画扇形*/
    //iGlobalFocusColor=2b92f9
    UIColor *defaultColor = iColor(0xeb, 0xf0, 0xf5, 1.0);
    CGContextSetFillColorWithColor(context, defaultColor.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, defaultColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddArc(context, startPoint.x, startPoint.y, max_redius,  40 * M_PI / 180, 140 * M_PI / 180, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    
    //ebf0f5
    UIColor *focusColor = iGlobalFocusColor;
    CGContextSetFillColorWithColor(context, focusColor.CGColor);
    CGContextSetStrokeColorWithColor(context, focusColor.CGColor);
    //以redius为半径围绕圆心画指定角度扇形
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddArc(context, startPoint.x, startPoint.y, new_redius,  40 * M_PI / 180, 140 * M_PI / 180, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
}


#pragma mark 手势
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    _beginPoint = p;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    CGFloat offsetY = p.y - _beginPoint.y;
    //更新
    self.redius = _redius + offsetY;
    _beginPoint = p;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    _beginPoint = CGPointZero;
    [self drawEndedToUpdateDistance];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    _beginPoint = CGPointZero;
    [self drawEndedToUpdateDistance];
}


@end
