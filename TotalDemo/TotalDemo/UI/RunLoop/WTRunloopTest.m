//
//  WTRunloopTest.m
//  TotalDemo
//
//  Created by tyler on 8/24/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTRunloopTest.h"


@implementation WTRunloopTest


+(NSThread*)shareThread {
    
    static NSThread *thread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[NSThread alloc]initWithTarget:self selector:@selector(testShareThread) object:nil];
        
        [thread setName:@"WT share thread test"];
        
        [thread start];
    });
    return thread;
}

+(void)testShareThread {
    NSLog(@"%@ - %@ start", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    static BOOL flag = NO;
    while (!flag) {
        NSLog(@"%@ - %@ while start", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        NSLog(@"%@ - %@ while end", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    NSLog(@"%@ - %@ end", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
