//
//  WTLocationManager.m
//  TotalDemo
//
//  Created by tyler on 9/23/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface WTLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic,strong)CLLocationManager *man;
@property (nonatomic,copy)void (^locationcb)(BOOL,NSArray *);

@end

@implementation WTLocationManager

#pragma mark - init

+(instancetype)shareInstance{
    static long l=0;
    static WTLocationManager *instance;
    dispatch_once(&l, ^{
        instance=[[WTLocationManager alloc] init];
    });
    return instance;
}

#pragma  mark  CLLocationManagerDelegate //TODO 定位权限
+(void)locationWith:(void (^)(BOOL, NSArray *))cb{
    WTLocationManager *inst=[self shareInstance];
    inst.locationcb=cb;
    [inst checkAuthorized];
    [inst.man startUpdatingLocation];
}

-(CLLocationManager *)man{
    if(!_man){
        
        //TODO 移除定位权限
        _man=[[CLLocationManager alloc] init];
        _man.delegate=self;
        [_man requestAlwaysAuthorization];
        [_man requestWhenInUseAuthorization];
    }
    return _man;
}
-(void) checkAuthorized{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status != kCLAuthorizationStatusAuthorizedAlways) {
        [self.man requestAlwaysAuthorization];
    }
    if(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        NSLog(@"GEO:Location Authorize is not allow...");
    }else{
        NSLog(@"GEO:Location Authorzie is done");
        self.man.desiredAccuracy = kCLLocationAccuracyBest;
        [self.man requestLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    [_man stopUpdatingLocation];
    if(self.locationcb){
        self.locationcb(1,locations);
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [_man stopUpdatingLocation];
    if(self.locationcb){
        self.locationcb(0,@[error]);
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status==kCLAuthorizationStatusDenied){
        [_man stopUpdatingLocation];
    }else{
        [_man startUpdatingLocation];
        
    }
}


@end
