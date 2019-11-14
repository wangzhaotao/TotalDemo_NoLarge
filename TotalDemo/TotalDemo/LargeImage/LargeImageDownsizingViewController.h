//
//  LargeImageDownsizingViewController.h
//  TotalDemo
//
//  Created by tyler on 6/26/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageScrollView;

@interface LargeImageDownsizingViewController : UIViewController
{
    // sub rect of the input image bounds that represents the
    // maximum amount of pixel data to load into mem at one time.
    CGRect sourceTile;
    // sub rect of the output image that is proportionate to the
    // size of the sourceTile.
    CGRect destTile;
    // the ratio of the size of the input image to the output image.
    float imageScale;
    // source image width and height
    CGSize sourceResolution;
    // total number of pixels in the source image
    float sourceTotalPixels;
    // total number of megabytes of uncompressed pixel data in the source image.
    float sourceTotalMB;
    // output image width and height
    CGSize destResolution;
    // the temporary container used to hold the resulting output image pixel
    // data, as it is being assembled.
    CGContextRef destContext;
    // the number of pixels to overlap tiles as they are assembled.
    float sourceSeemOverlap;
}

// The input image file
@property (strong, strong) UIImage* sourceImage;
// output image file
@property (strong, strong) UIImage* destImage;
// an image view to visualize the image as it is being pieced together
@property (strong, strong) UIImageView* progressView;
// a scroll view to display the resulting downsized image
@property (strong, strong) ImageScrollView* scrollView;

-(void)downsize:(id)arg;
-(void)updateScrollView:(id)arg;
-(void)initializeScrollView:(id)arg;
-(void)createImageFromContext;

@end

