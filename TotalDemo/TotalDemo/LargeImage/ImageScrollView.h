//
//  ImageScrollView.h
//  TotalDemo
//
//  Created by tyler on 6/26/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TiledImageView;

@interface ImageScrollView : UIScrollView <UIScrollViewDelegate> {
    
    TiledImageView *frontTiledView;
    
    TiledImageView *backTiledView;
    
    UIImageView *backgroundImageView;
    
    float minimumScale;
    
    float imageScale;
    
    UIImage *image;
}
@property (strong) UIImage* image;
@property (strong) TiledImageView* backTiledView;

-(id)initWithFrame:(CGRect)frame image:(UIImage*)image;


@end

