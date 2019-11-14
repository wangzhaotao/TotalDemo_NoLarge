//
//  TestVC.h
//  TotalDemo
//
//  Created by ocean on 2019/1/5.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TestVCDelegate <NSObject>

-(void)testMethod;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TestVC : UIViewController

@property (nonatomic, strong) id<TestVCDelegate> delegate;

-(void)testMethodButtonAction;


@end

NS_ASSUME_NONNULL_END
