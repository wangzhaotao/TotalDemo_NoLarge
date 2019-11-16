//
//  RootTabbarController.m
//  TotalDemo
//
//  Created by tyler on 11/15/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "RootTabbarController.h"
#import "WTTabFirstController.h"
#import "ViewController.h"

@interface RootTabbarController ()

@end

@implementation RootTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self setupTabbarChildControllers];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"UITabbarController view will appear...");
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"UITabbarController view did appear...");
}

-(void)setupTabbarChildControllers {
    
    //
    WTTabFirstController *vc1 = [[WTTabFirstController alloc]init];
    vc1.tabBarItem=[[UITabBarItem alloc]init];
    vc1.title= @"First View";
    vc1.navigationItem.title=@"First View";
    vc1.tabBarItem.image=[UIImage imageNamed:@"geo_map_coordinate_icon"];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    [self addChildViewController:nav1];
    
    ViewController *vc2 = [[ViewController alloc]init];
    vc2.tabBarItem=[[UITabBarItem alloc]init];
    vc2.title= @"Second View";
    vc2.navigationItem.title=@"Second View";
    vc2.tabBarItem.image=[UIImage imageNamed:@"live_view_round_off_n_icon"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    [self addChildViewController:nav2];
}

@end
