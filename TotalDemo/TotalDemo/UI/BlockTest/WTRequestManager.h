//
//  WTRequestManager.h
//  TotalDemo
//
//  Created by tyler on 8/15/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface WTRequestManager : NSObject

+(instancetype)share;

-(void)requestWithOpen:(BOOL)status time:(int)sleep completion:(void(^)(int code, id obj))completion;

@end


