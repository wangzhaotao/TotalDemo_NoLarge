//
//  UIColor+Extension.m
//  BatteryCam
//
//  Created by ocean on 2/25/19.
//  Copyright © 2019 oceanwing. All rights reserved.
//

#import "UIColor+RectExtension.h"

@implementation UIColor (RectExtension)

-(CGFloat)R {
    NSArray *tmp = [self getRGBValueFromUIColor:self];
    if (tmp.count>0) {
        return [tmp[0] floatValue];
    }
    return 1.0;
}
-(CGFloat)G {
    NSArray *tmp = [self getRGBValueFromUIColor:self];
    if (tmp.count>1) {
        return [tmp[1] floatValue];
    }
    return 1.0;
}
-(CGFloat)B {
    NSArray *tmp = [self getRGBValueFromUIColor:self];
    if (tmp.count>2) {
        return [tmp[2] floatValue];
    }
    return 1.0;
}
-(CGFloat)alpha {
    
    NSArray *tmp = [self getRGBValueFromUIColor:self];
    if (tmp.count>3) {
        return [[tmp lastObject]floatValue];
    }
    return 1.0;
}
-(NSArray<NSNumber*>*)getRGBValueFromUIColor:(UIColor *)color {
    
    NSMutableArray<NSNumber*> *components = [NSMutableArray arrayWithCapacity:4];
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 4; component++) {
        components[component] = [NSNumber numberWithFloat:resultingPixel[component]];
    }
    
    return components;
}



@end
