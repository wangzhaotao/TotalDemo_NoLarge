//
//  WTLocationManager.h
//  TotalDemo
//
//  Created by tyler on 9/23/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTLocationManager : NSObject

+(void)locationWith:(void(^)(BOOL suc,NSArray *locs))cb; //TODO 定位权限

@end

NS_ASSUME_NONNULL_END
