//
//  WTPersonObj.m
//  TotalDemo
//
//  Created by tyler on 7/22/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTPersonObj.h"

@interface WTPersonObj ()
{
    NSString *_objID;
    
    NSString *_isEarth;
    
    NSString *nickName;
    
    NSString *isPerson;
}

@end

@implementation WTPersonObj

+(BOOL)accessInstanceVariablesDirectly {
    
    return YES;
}

-(id)valueForUndefinedKey:(NSString *)key {
    
    NSLog(@"valueForUndefinedKey: %@", key);
    return nil;
}
-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {
    
    NSLog(@"setValue:%@ forUndefinedKey: %@", value, key);
}

@end
