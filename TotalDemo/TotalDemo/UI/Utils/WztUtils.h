//
//  WztUtils.h
//  TotalDemo
//
//  Created by ocean on 3/6/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>

CGFloat dp2po(CGFloat dp);
UIApplication *mainApp(void);
BOOL emptyStr(NSString *str);
id nilID(void);
BOOL nullObj(id obj);

void runOnMain(void (^blo)(void));
void runOnGlobal(void (^blo)(void));

@interface WztUtils : NSObject


@end

