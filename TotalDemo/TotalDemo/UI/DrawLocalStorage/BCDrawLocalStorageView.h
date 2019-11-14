//
//  BCDrawLocalStorageView.h
//  TotalDemo
//
//  Created by ocean on 3/5/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCDrawStorageView : UIView

-(void)updateWithColorArray:(NSArray<UIColor*>*)colorArray numberArray:(NSArray<NSNumber*>*)numberArray;

@end



@interface BCDrawLocalStorageView : UIView

-(void)updateWithTotal:(CGFloat)total system:(CGFloat)system video:(CGFloat)video;

@end

