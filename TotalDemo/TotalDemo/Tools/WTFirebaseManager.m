//
//  WTFirebaseManager.m
//  TotalDemo
//
//  Created by tyler on 5/21/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTFirebaseManager.h"
#import "Fabric/Fabric.h"

@interface WTFirebaseManager ()
@property (nonatomic, strong) FIRRemoteConfig *remoteConfig;

@end

@implementation WTFirebaseManager

+(void)configure {
    
    [FIRApp configure];
    
#ifdef DEBUG
    [Fabric.sharedSDK setDebug:YES];
#endif
}

+(instancetype)share {
    
    static WTFirebaseManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WTFirebaseManager alloc]init];
        [instance configRemote];
    });
    return instance;
}

-(instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

-(void)configRemote{
    self.remoteConfig = [FIRRemoteConfig remoteConfig];
#ifdef DEBUG
    FIRRemoteConfigSettings *remoteConfigSettings = [[FIRRemoteConfigSettings alloc] initWithDeveloperModeEnabled:YES];
    self.remoteConfig.configSettings = remoteConfigSettings;
    
    
    
#else
    FIRRemoteConfigSettings *remoteConfigSettings = [[FIRRemoteConfigSettings alloc] initWithDeveloperModeEnabled:NO];
    self.remoteConfig.configSettings = remoteConfigSettings;
#endif
    [self.remoteConfig setDefaultsFromPlistFileName:@"RemoteConfigDefaults"];
}

-(void)fetchConfig{
    NSTimeInterval duration = 60*60*24;
    if(self.remoteConfig.configSettings.isDeveloperModeEnabled)
        duration = 0;
    [self fetchConfigWithDura:duration];
}

-(void)fetchConfigImmediately{
    [self fetchConfigWithDura:0];
}

-(void)fetchConfigWithDura:(NSTimeInterval)dura{
    [self.remoteConfig fetchWithExpirationDuration:dura completionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            NSLog(@"remoteConfig-Config fetched!");
            [self.remoteConfig activateFetched];
            NSLog(@"remoteConfig.allKeysFromSource------%@------------",[self.remoteConfig allKeysFromSource:(FIRRemoteConfigSourceRemote) namespace:FIRNamespaceGoogleMobilePlatform]);
            //            NSLog(@"%@ >>>>>>>>%.0f",[self.remoteConfig configValueForKey:@"nas_beta"].stringValue,dura);
        } else {
            NSLog(@"remoteConfig-Config not fetched");
            NSLog(@"Error %@", error.localizedDescription);
        }
    }];
}


#pragma mark Firebase远程配置选项
-(UIColor*)mainBackgroundColor {
    
    NSString *tarversion = [self.remoteConfig configValueForKey:@"main_color"].stringValue;
    UIColor *color = [UIColor colorWithHexString:tarversion];
    return color;
}
-(BOOL)getAppModeGeoEnableStatus {
    
    NSString *enableStr = [self.remoteConfig configValueForKey:@"app_mode_geo_enable_fl"].stringValue;
    BOOL enable = [enableStr boolValue];
    return enable;
}

@end
