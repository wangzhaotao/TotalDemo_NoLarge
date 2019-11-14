//
//  WztUtils.m
//  TotalDemo
//
//  Created by ocean on 3/6/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WztUtils.h"

CGFloat dp2po(CGFloat dp){
    CGFloat w = MIN(iScreenH,iScreenW);
    return w*dp/375;
}

BOOL emptyStr(NSString *str){
    return !str||!str.length;
}
id nilID(void){
    return nil;
}
UIApplication *mainApp(void){
    static UIApplication *app=nil;
    if(!app){
        SEL selector = NSSelectorFromString(@"sharedApplication");
        if([UIApplication respondsToSelector:selector]){
            NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:[[UIApplication class]methodSignatureForSelector:selector] ];
            [invocation setSelector:selector];
            [invocation setTarget:[UIApplication class]];
            [invocation invoke];
            id returnValue;
            [invocation getReturnValue:&returnValue];
            app=returnValue;
        }
    }
    return app;
}
BOOL nullObj(id obj){
    return obj==nil||[obj isKindOfClass:[NSNull class]];
}

void runOnMain(void (^blo)(void)){
    dispatch_async(dispatch_get_main_queue(), blo);
}
void runOnGlobal(void (^blo)(void)){
    dispatch_async(dispatch_get_global_queue(0, 0), blo);
}

@implementation WztUtils



@end
