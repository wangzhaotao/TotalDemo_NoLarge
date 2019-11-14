//
//  TestDrawView.m
//  TotalDemo
//
//  Created by ocean on 3/5/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "TestDrawView.h"
#import "UIColor+RectExtension.h"

@implementation TestDrawView

-(instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = 50;//self.bounds.size.height;
    
    // 获取上下文CGContext
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 50);
    
    CGFloat offset = 0;
    CGPoint points[4];
    points[0] = CGPointMake(offset,    25);
    points[1] = CGPointMake(offset+10, 25);
    //points[2] = CGPointMake(offset+10, height);
    //points[3] = CGPointMake(offset,    height);
    
    UIColor *color = iColor(0xff, 0xc8, 0x50, 1.0);
    CGContextSetRGBStrokeColor(context, color.R/255.0, color.G/255.0, color.B/255.0, 1.0);
    CGContextSetRGBFillColor(context, color.R/255.0, color.G/255.0, color.B/255.0, 1.0);
    CGContextAddLines(context, points, 1);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    
    //color = iColor(0xff, 0x91, 0x46, 1.0);
    CGContextSetLineWidth(context, 1.0);
    offset += 10;
    points[0] = CGPointMake(offset,    0);
    points[1] = CGPointMake(offset+20, 0);
    points[2] = CGPointMake(offset+20, height);
    points[3] = CGPointMake(offset,    height);
    
    color = iColor(0xff, 0x91, 0x46, 1.0);
    CGContextSetRGBStrokeColor(context, color.R/255.0, color.G/255.0, color.B/255.0, 1.0);
    CGContextSetRGBFillColor(context, color.R/255.0, color.G/255.0, color.B/255.0, 1.0);
    CGContextAddLines(context, points, 4);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
