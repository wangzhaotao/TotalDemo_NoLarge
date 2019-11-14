//
//  NSObject+Ex.m
//  TotalDemo
//
//  Created by tyler on 8/16/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "NSObject+Ex.h"
#import "WTUtil.h"

@implementation NSObject (Ex)

-(NSDictionary*)dictionary {
    
    NSArray *pros = [WTUtil propertiesWithClass:self.class];
    return [self dictionaryWithValuesForKeys:pros];
}

@end
