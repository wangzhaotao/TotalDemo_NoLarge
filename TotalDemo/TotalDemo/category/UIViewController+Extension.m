//
//  UIViewController+Extension.m
//  TotalDemo
//
//  Created by ocean on 3/6/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "objc/runtime.h"
#import "YFWeakRef.h"

@implementation UIViewController (Extension)

+(void)popVC{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *obj=[self curVC];
        if([obj  isKindOfClass:[UINavigationController class]]){
            [(UINavigationController *)obj popViewControllerAnimated:YES];
        }else{
            [ [obj navigationController] popViewControllerAnimated:YES];
        }
    });
}

+(void)setVC:(UIViewController *)vc{
    YFWeakRef *ref = [YFWeakRef refWith:vc];
    objc_setAssociatedObject(mainApp(), iVCKey, ref, OBJC_ASSOCIATION_RETAIN);
}

+(instancetype)curVC{
    return  ((YFWeakRef*)(objc_getAssociatedObject(mainApp(), iVCKey))).obj;
}

-(void)alert:(NSString *)title msg:(NSString *)msg{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:0]];
    [self presentViewController:vc animated:YES completion:nil];
}


+(UIViewController *)topVC{
    
    UIWindow *window = [mainApp().delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
    
}

@end
