//
//  WTOperationCancelVC.m
//  TotalDemo
//
//  Created by tyler on 4/17/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTOperationCancelVC.h"
#import "WTThreadManager.h"

@interface WTOperationCancelVC ()

@end

@implementation WTOperationCancelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[self gcdBlockCancel];
    
    //[self performSelector:@selector(test) onThread:[WTThreadManager shareThread] withObject:nil waitUntilDone:NO];
    
    //[self barrierTest];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"请求结束...");
            dispatch_semaphore_signal(semaphore);
        });
        
        NSLog(@"等待ing...");
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"请求结束...执行下一步...");
    });
    
    
}

- (void)test {
    
    NSLog(@"test:%@", [NSThread currentThread]);
}

-(void)barrierTest {
    
    dispatch_queue_t concreateQueue = dispatch_queue_create("com.wzt.test.concreate", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i=0; i<10; i++) {
        dispatch_sync(concreateQueue, ^{
            NSLog(@"%@--%d", NSStringFromSelector(_cmd), i);
        });
    }
    
    dispatch_barrier_sync(concreateQueue, ^{
        NSLog(@"dispatch_barrier_sync");
    });
    NSLog(@"栅栏函数....");
    
    for (int i=11; i<20; i++) {
        dispatch_sync(concreateQueue, ^{
            NSLog(@"%@--%d", NSStringFromSelector(_cmd), i);
        });
    }
}


- (void)gcdBlockCancel{
    
    dispatch_queue_t queue = dispatch_queue_create("com.gcdtest.www", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        sleep(5);
        NSLog(@"block1 %@",[NSThread currentThread]);
    });
    
    dispatch_block_t block2 = dispatch_block_create(0, ^{
        NSLog(@"block2 %@",[NSThread currentThread]);
    });
    
    dispatch_block_t block3 = dispatch_block_create(0, ^{
        NSLog(@"block3 %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
    dispatch_async(queue, block3);
    dispatch_block_cancel(block3);
}






@end
