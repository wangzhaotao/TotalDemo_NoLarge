//
//  TiledImageView.h
//  TotalDemo
//
//  Created by tyler on 6/26/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TiledImageView : UIView {
    CGFloat imageScale;
    UIImage* image;
    CGRect imageRect;
}
@property (strong) UIImage* image;

-(id)initWithFrame:(CGRect)_frame image:(UIImage*)image scale:(CGFloat)scale;

@end

