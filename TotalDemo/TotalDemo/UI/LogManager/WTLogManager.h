//
//  WTLogManager.h
//  LogToLocalDemo
//
//  Created by wztMac on 2019/5/25.
//  Copyright © 2019 wztMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WTLogManager : NSObject
+(instancetype)share;
-(void)initRedirectLogToFile;
- (void)sendLogContentMailToMe:(NSString*)logPath target:(UIViewController*)target;

@end

