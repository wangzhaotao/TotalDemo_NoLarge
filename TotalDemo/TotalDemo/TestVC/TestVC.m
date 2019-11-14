//
//  TestVC.m
//  TotalDemo
//
//  Created by ocean on 2019/1/5.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "TestVC.h"
#import "WTFirebaseManager.h"

#define Video_FPS 15

@interface TestVC ()
{
    NSRunLoop *_showRunLoop;
}
@property (nonatomic, strong) NSThread *videoThread;
@property (nonatomic, strong) CADisplayLink *videoLink;

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

-(void)testMethodButtonAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate) {
            [self.delegate testMethod];
        }
    });
    self.view.backgroundColor = [[WTFirebaseManager share]mainBackgroundColor];
    //
    
    
    
    _videoThread = [[NSThread alloc]initWithTarget:self selector:@selector(videoThreadAction) object:nil];
    [_videoThread start];
}

-(void)viewDidDisappear:(BOOL)animated {
    
    [self destroy];
    
    [super viewDidDisappear:animated];
}

-(void)testZhiZhenLog {
    
    //指针
    int array[10];
    for (int i=0; i<10; i++) {
        array[i] = i;
    }
    int *p = array;
    int *q = &array[2];
    
    printf("q-p = %d \n", q-p);
    printf("array[q-p] = %d \n", array[q-p]);
}


-(void)videoThreadAction {
    
    @autoreleasepool {
        if(_videoLink){
            [_videoLink invalidate];
            _videoLink = nil;
        }
        _videoLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTimeAction)];
        if([_videoLink respondsToSelector:@selector(setPreferredFramesPerSecond:)]){
            _videoLink.preferredFramesPerSecond = Video_FPS;
        }
        else{
            _videoLink.frameInterval = 60/Video_FPS;
        }
        
        _showRunLoop = [NSRunLoop currentRunLoop];
        [_videoLink addToRunLoop:_showRunLoop forMode:NSRunLoopCommonModes];
        //[_showRunLoop run];
        CFRunLoopRun();
        [_videoLink invalidate];
        _videoLink = nil;
    }
}
-(void)displayLinkTimeAction {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self destroy];
}
- (void)destroy{
    if(_videoLink){
        if(_showRunLoop){
            [_videoLink removeFromRunLoop:_showRunLoop forMode:NSRunLoopCommonModes];
            CFRunLoopStop(_showRunLoop.getCFRunLoop);
        }
        NSLog(@"currentRunLoop destroy_videoLink");
    }
}


@end
