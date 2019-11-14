//
//  WTThreadManager.m
//  TotalDemo
//
//  Created by tyler on 8/21/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTThreadManager.h"

@implementation WTThreadManager

+(NSThread*)shareThread {
    
    static NSThread *shareThread = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadTest) object:nil];
        
        [shareThread setName:@"threadTest"];
        
        [shareThread start];
    });
    
    return shareThread;
}

+ (void)threadTest
{
    @autoreleasepool {

        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];

        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];

        [runLoop run];
    }
}

@end
