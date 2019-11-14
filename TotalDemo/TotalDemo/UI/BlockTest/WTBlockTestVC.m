//
//  WTBlockTestVC.m
//  TotalDemo
//
//  Created by tyler on 8/15/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTBlockTestVC.h"
#import "WTLightMode.h"
#import "WTRequestManager.h"

@interface WTBlockTestVC ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WTBlockTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"obj1", @"key1", @"obj2", @"key2", nil];
    NSLog(@"dic: %@", dic);
    
    
    
    
    //////////////////////////
    __block int i = 1024;
    int j = 1;
    void (^blk)(void);
    blk = ^{
        printf("i=%d, j=%d, &i:%p, &j:%p", i, j, &i, &j);
    };
    blk();
    //////////////////////////
}

-(void)updateDatas {
    
    WTLightMode *light = [self.dataArray objectAtIndex:0];
    light.open = NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    WTLightMode *light = [self.dataArray objectAtIndex:0];
    light.open = YES;
    NSLog(@"开关状态: %@", light.open?@"开":@"关");
    [WTRequestManager.share requestWithOpen:light.open time:4 completion:^(int code, id obj) {
        
        NSLog(@"开关状态: %@", light.open?@"开":@"关");
    }];
    
    [self performSelectorOnMainThread:@selector(updateDatas) withObject:nil waitUntilDone:0];
}


#pragma mark set/get
-(NSMutableArray*)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        WTLightMode *light = [[WTLightMode alloc]init];
        light.sn = @"T842010030007";
        light.name = @"Front Door";
        light.open = NO;
        
        [_dataArray addObject:light];
    }
    return _dataArray;
}




@end
