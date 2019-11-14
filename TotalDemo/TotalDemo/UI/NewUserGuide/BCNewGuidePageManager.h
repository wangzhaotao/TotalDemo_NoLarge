//
//  BCNewGuidePageManager.h
//  BatteryCam
//
//  Created by ocean on 2019/1/7.
//  Copyright © 2019年 oceanwing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * LOGOUT_NOTI=@"LOGOUT_EVENT_NOTI";

typedef NS_ENUM(NSInteger, GuidePageType) {
    GuidePageType_None,
    GuidePageType_Device,
    GuidePageType_Event,
    GuidePageType_Mode,
    GuidePageType_ModeSetting1,
    GuidePageType_ModeSetting2,
    GuidePageType_End
};

@interface BCNewGuidePageManager : NSObject

+(instancetype)share;

+(void)saveNewUserFirstToAddDevice:(BOOL)firstAdd;

-(void)showWithFrame:(CGRect)frame type:(GuidePageType)type;
-(void)dismissBy:(GuidePageType)type;
@end


