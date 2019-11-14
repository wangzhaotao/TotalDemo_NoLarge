//
//  WTHomeKitVC.m
//  TotalDemo
//
//  Created by tyler on 6/12/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTHomeKitVC.h"
#import <HomeKit/HomeKit.h>

@interface WTHomeKitVC ()<HMHomeManagerDelegate, HMAccessoryBrowserDelegate>

@property HMAccessoryBrowser *accessoryBrowser;

@property (nonatomic, strong) HMHomeManager *homeManager;

@end

@implementation WTHomeKitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    
    [self findHomeInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.accessoryBrowser stopSearchingForNewAccessories];
    [super viewWillDisappear:animated];
}



#pragma mark private methods
-(void)findHomeInfo {
    
    //创建配件浏览器对象，并设置它的代理
    self.accessoryBrowser = [[HMAccessoryBrowser alloc] init];
    self.accessoryBrowser.delegate = self;
    
    [self.accessoryBrowser startSearchingForNewAccessories];
}

-(void)printHomeInfoTest {
    
    self.homeManager = [[HMHomeManager alloc]init];
    self.homeManager.delegate = self;
    
    HMHome *primaryHome = self.homeManager.primaryHome;
    NSLog(@"Primary Home name: %@", primaryHome.name);
    
    for(HMRoom *room in primaryHome.rooms){
        NSLog(@"Primary Home room name: %@", primaryHome.name);
        
        for(HMAccessory *accessory in room.accessories) {
            //获取到room中的所有 accessory对象
            NSLog(@"获取到room中的所有 accessory对象:%@", accessory);
        }
    }
    
    for(HMAccessory *accessory in primaryHome.accessories) {
        //获取到hoom中的所有accessory对象
        NSLog(@"获取到hoom中的所有accessory对象:%@", accessory);
    }
    
    
    
    for (HMHome *home in self.homeManager.homes) {
        NSLog(@"Home name: %@", home.name);
    }
}

#pragma mark HMAccessoryBrowserDelegate
- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory {
    NSLog(@"%@ accessory:%@", NSStringFromSelector(_cmd), accessory.name);
    [self printHomeInfoTest];
}
- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark HMHomeManagerDelegate
- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
    
}




@end
