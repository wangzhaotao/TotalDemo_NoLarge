//
//  WTThreadManager.h
//  TotalDemo
//
//  Created by tyler on 8/21/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTThreadManager : NSObject

+(NSThread*)shareThread;

@end

NS_ASSUME_NONNULL_END
