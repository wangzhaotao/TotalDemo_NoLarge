//
//  BCFLMotionDistanceView.h
//  BatteryCam
//
//  Created by tyler on 8/6/19.
//  Copyright © 2019 oceanwing. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat kMinMotionDistanceValue = 2.0;
static CGFloat kMaxMotionDistanceValue = 19.0;

static CGFloat kMaxMotionDistanceRedius = 150.0;
static CGFloat kMinMotionDistanceRedius = 37.5;  // kMaxMotionDistanceRedius/4

@protocol BCFLMotionDistanceViewDelegate <NSObject>

-(void)updateFLLightPirMotionDistanceValue:(NSInteger)value;

@end

@interface BCFLMotionDistanceView : UIView

@property(nonatomic, assign) CGFloat redius;
@property (nonatomic, weak) id<BCFLMotionDistanceViewDelegate> delegate;

@end

