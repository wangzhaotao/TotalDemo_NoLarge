//
//  WTRequestManager.m
//  TotalDemo
//
//  Created by tyler on 8/15/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTRequestManager.h"

@implementation WTRequestManager

+(instancetype)share {
    
    static WTRequestManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WTRequestManager alloc]init];
    });
    return instance;
}

-(void)requestWithOpen:(BOOL)status time:(int)sleep completion:(void(^)(int code, id obj))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSThread sleepForTimeInterval:sleep];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES, nil);
        });
    });
}


@end
