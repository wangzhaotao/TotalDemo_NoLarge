//
//  UIImage+Extention.m
//  TotalDemo
//
//  Created by ocean on 2019/1/5.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "UIImage+Extention.h"

@implementation UIImage (Extention)

+ (instancetype)img4Color:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(instancetype)resizableStretchImg{
    CGFloat  w=self.size.width*.5;
    CGFloat h=self.size.height*.5;
    return [self resizableImageWithCapInsets:(UIEdgeInsets){h,w,h,w} resizingMode:UIImageResizingModeStretch];
}

@end
