//
//  WTCrashExpectionHandler.h
//  TotalDemo
//
//  Created by tyler on 4/10/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WTCrashExpectionHandler : NSObject

+ (instancetype)Instance;

//注册捕获信号的方法
+ (void)RegisterSignalHandler;
//处理异常用到的方法
- (void)HandleException:(NSException *)exception;

@end
