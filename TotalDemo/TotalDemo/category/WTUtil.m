//
//  WTUtil.m
//  TotalDemo
//
//  Created by tyler on 8/16/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTUtil.h"
#import <objc/runtime.h>

@implementation WTUtil

+(NSArray*)propertiesWithClass:(Class)clz {
    
    NSMutableArray *propties = [NSMutableArray array];
    while (clz != [NSObject class]) {
        unsigned int count;
        struct objc_property **prosList = class_copyPropertyList(clz, &count);
        for (int i=0; i<count; i++) {
            struct objc_property *pro = prosList[i];
            [propties addObject:[NSString stringWithUTF8String:property_getName(pro)]];
        }
        
        clz = [clz superclass];
    }
    
    return propties;
}

@end
