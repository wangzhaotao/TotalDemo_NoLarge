//
//  WTPersonObj.h
//  TotalDemo
//
//  Created by tyler on 7/22/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTAnimalObj.h"

@interface WTPersonObj : WTAnimalObj

@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *name;

@end

