//
//  WTRunloopVC.m
//  TotalDemo
//
//  Created by tyler on 8/23/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTRunloopVC.h"
#import "WTRunloopTest.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

@interface WTRunloopVC () {
    
    BOOL flag;
}

@end

@implementation WTRunloopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Runloop阻塞主线程
    //[self runloopTest];
    
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self performSelector:@selector(testVC) onThread:[WTRunloopTest shareThread] withObject:nil waitUntilDone:NO];
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
    }];
}

-(void)testVC {
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    //方法调用的堆栈信息
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0;i < 4;i++){
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    NSLog(@"=====>>>>>堆栈<<<<<=====\n%@",backtrace);
    
    
    NSArray *csss = [NSThread callStackSymbols];
    NSLog(@"=====>>>>>堆栈<<<<<=====\n%@",csss);
}














//runloop test
-(void)runloopTest {
    
    //
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [NSThread detachNewThreadSelector:@selector(startNewThread1) toTarget:self withObject:nil];
    
    //Runloop 哈哈 有点明白啥意思了
    while (!flag) {
        NSLog(@"while start...flag=%@", flag?@"YES":@"NO");
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]; //[NSDate distantFuture]  [NSDate dateWithTimeIntervalSinceNow:0.1]
        NSLog(@"while end...");
    }
    NSLog(@"WTRunloopVC runloopTest end");
}

-(void)startNewThread {
    
    NSLog(@"子线程执行--%@ start...", NSStringFromSelector(_cmd));
    [NSThread sleepForTimeInterval:1.0];
    flag = YES;
    NSLog(@"子线程执行--%@ end...", NSStringFromSelector(_cmd));
}

-(void)startNewThread1 {
    
    NSLog(@"子线程执行--%@ start...", NSStringFromSelector(_cmd));
    [NSThread sleepForTimeInterval:1.0];
    [self performSelectorOnMainThread:@selector(mainThreadChange) withObject:nil waitUntilDone:NO];
    NSLog(@"子线程执行--%@ end...", NSStringFromSelector(_cmd));
}

-(void)mainThreadChange {
    flag = YES;
    NSLog(@"mainThreadChange...flag=%@", flag?@"YES":@"NO");
}




@end
