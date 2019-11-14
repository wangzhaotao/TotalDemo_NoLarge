//
//  UIViewController+Extension.h
//  TotalDemo
//
//  Created by ocean on 3/6/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <UIKit/UIKit.h>
#define iVCKey "curVC"



@interface UIViewController (Extension)

+(void)popVC;

+(void)setVC:(UIViewController *)vc;
+(instancetype)curVC;

-(void)alert:(NSString *)title msg:(NSString *)msg;

+(UIViewController *)topVC;

@end

