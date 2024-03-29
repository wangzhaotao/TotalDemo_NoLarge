//
//  ImageScrollView.m
//  TotalDemo
//
//  Created by tyler on 6/26/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "ImageScrollView.h"
#import "TiledImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageScrollView

@synthesize image, backTiledView;

- (void)dealloc {
    self.backTiledView = nil;
}

-(id)initWithFrame:(CGRect)frame image:(UIImage*)img {
    if((self = [super initWithFrame:frame])) {
        // Set up the UIScrollView
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        self.maximumZoomScale = 5.0f;
        self.minimumZoomScale = 0.25f;
        self.backgroundColor = [UIColor colorWithRed:0.4f green:0.2f blue:0.2f alpha:1.0f];
        // determine the size of the image
        self.image = img;
        CGRect imageRect = CGRectMake(0.0f,0.0f,CGImageGetWidth(image.CGImage),CGImageGetHeight(image.CGImage));
        imageScale = self.frame.size.width/imageRect.size.width;
        minimumScale = imageScale * 0.75f;
        NSLog(@"imageScale: %f",imageScale);
        imageRect.size = CGSizeMake(imageRect.size.width*imageScale, imageRect.size.height*imageScale);
        // Create a low res image representation of the image to display before the TiledImageView
        // renders its content.
        UIGraphicsBeginImageContext(imageRect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextDrawImage(context, imageRect, image.CGImage);
        CGContextRestoreGState(context);
        UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //模糊的背景图片，用于在加载好清晰图前显示，清晰图加载好后会覆盖掉模糊图，这样视觉效果比较好
        backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundImageView.frame = imageRect;
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:backgroundImageView];
        //放到父视图的最后面显示
        [self sendSubviewToBack:backgroundImageView];
        // Create the TiledImageView based on the size of the image and scale it to fit the view.
        //显示的清晰图片
        frontTiledView = [[TiledImageView alloc] initWithFrame:imageRect image:image scale:imageScale];
        [self addSubview:frontTiledView];
    }
    return self;
}

// We use layoutSubviews to center the image in the view
- (void)layoutSubviews {
    [super layoutSubviews];
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = frontTiledView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    frontTiledView.frame = frameToCenter;
    backgroundImageView.frame = frameToCenter;
    // to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
    // tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
    // which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
    frontTiledView.contentScaleFactor = 1.0;
}

#pragma mark -
#pragma mark UIScrollView delegate methods
// A UIScrollView delegate callback, called when the user starts zooming.
// We return our current TiledImageView.
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return frontTiledView;
}
// A UIScrollView delegate callback, called when the user stops zooming.  When the user stops zooming
// we create a new TiledImageView based on the new zoom level and draw it on top of the old TiledImageView.
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    // set the new scale factor for the TiledImageView
    imageScale *=scale;
    if( imageScale < minimumScale ) imageScale = minimumScale;
    CGRect imageRect = CGRectMake(0.0f,0.0f,CGImageGetWidth(image.CGImage) * imageScale,CGImageGetHeight(image.CGImage) * imageScale);
    // Create a new TiledImageView based on new frame and scaling.
    frontTiledView = [[TiledImageView alloc] initWithFrame:imageRect image:image scale:imageScale];
    [self addSubview:frontTiledView];
}

// A UIScrollView delegate callback, called when the user begins zooming.  When the user begins zooming
// we remove the old TiledImageView and set the current TiledImageView to be the old view so we can create a
// a new TiledImageView when the zooming ends.
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    // Remove back tiled view.
    [backTiledView removeFromSuperview];
    // Set the current TiledImageView to be the old view.
    self.backTiledView = frontTiledView;
}


@end
