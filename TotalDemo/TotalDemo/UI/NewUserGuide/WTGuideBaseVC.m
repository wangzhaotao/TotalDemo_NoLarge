//
//  WTGuideBaseVC.m
//  TotalDemo
//
//  Created by ocean on 3/6/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTGuideBaseVC.h"

@interface WTGuideBaseVC ()

@end

@implementation WTGuideBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIViewController setVC:self];
}

@end
