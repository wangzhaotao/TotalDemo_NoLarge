//
//  WTFirebaseManager.h
//  TotalDemo
//
//  Created by tyler on 5/21/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Firebase.h"

NS_ASSUME_NONNULL_BEGIN

@interface WTFirebaseManager : NSObject

+(void)configure;
+(instancetype)share;
-(void)fetchConfig;
-(void)fetchConfigImmediately;

-(UIColor*)mainBackgroundColor;
-(BOOL)getAppModeGeoEnableStatus;

@end

NS_ASSUME_NONNULL_END
