//
//  LargeImageDownsizingViewController.m
//  TotalDemo
//
//  Created by tyler on 6/26/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "LargeImageDownsizingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageScrollView.h"


//#define IPAD1_IPHONE3GS
#define IPAD2_IPHONE4
//#define IPHONE3G_IPOD2_AND_EARLIER

#ifdef IPAD1_IPHONE3GS
#   define kDestImageSizeMB 60.0f // The resulting image will be (x)MB of uncompressed image data.
#   define kSourceImageTileSizeMB 20.0f // The tile size will be (x)MB of uncompressed image data.
#endif

/* 这些常量为iPad2和iphone4提供了初始值 */
#ifdef IPAD2_IPHONE4
#   define kDestImageSizeMB 120.0f // The resulting image will be (x)MB of uncompressed image data.
#   define kSourceImageTileSizeMB 40.0f // The tile size will be (x)MB of uncompressed image data.
#endif

/* 这些常量为iPhone3G、iPod2和早期设备提供了初始值 */
#ifdef IPHONE3G_IPOD2_AND_EARLIER
#   define kDestImageSizeMB 30.0f // The resulting image will be (x)MB of uncompressed image data.
#   define kSourceImageTileSizeMB 10.0f // The tile size will be (x)MB of uncompressed image data.
#endif

#define bytesPerMB 1048576.0f  //1024 * 1024
//每个像素占用4字节
#define bytesPerPixel 4.0f
//每个像素占用1/MB数
#define pixelsPerMB ( bytesPerMB / bytesPerPixel ) // 262144 pixels, for 4 bytes per pixel.
#define destTotalPixels kDestImageSizeMB * pixelsPerMB
#define tileTotalPixels kSourceImageTileSizeMB * pixelsPerMB
#define destSeemOverlap 2.0f // the numbers of pixels to overlap the seems where tiles meet.


@interface LargeImageDownsizingViewController ()
@property (nonatomic, strong) UILabel *processLabel;

@end

@implementation LargeImageDownsizingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self initUI];
    
    //
    [NSThread detachNewThreadSelector:@selector(downsize:) toTarget:self withObject:nil];
}


#pragma mark private methods
-(void)downsize:(id)arg {
    @autoreleasepool {
        
        //
        NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"zz" ofType:@"jpg"];
        _sourceImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
        if( _sourceImage == nil ) NSLog(@"input image not found!");
        
        
        //原图片size
        sourceResolution.width = CGImageGetWidth(_sourceImage.CGImage);
        sourceResolution.height = CGImageGetHeight(_sourceImage.CGImage);
        
        //原图片分辨率
        sourceTotalPixels = sourceResolution.width * sourceResolution.height;
        
        //原图片位图大小
        sourceTotalMB = sourceTotalPixels / pixelsPerMB;        // widht*height*4 / (1024*1024)
        
        //各种设备上对应的缩放比例，各种设备上的destTotalPixels（预览图分辨率）值也不一样
        imageScale = destTotalPixels / sourceTotalPixels; //0.5;//
        destResolution.width = (int)( sourceResolution.width * imageScale );
        destResolution.height = (int)( sourceResolution.height * imageScale );
        
        //颜色空间
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        //位图每行占用的字节数
        int bytesPerRow = bytesPerPixel * destResolution.width; //4*width
        
        // 分配足够的像素数据来保存输出预览图图像,位图占用的全部字节数。
        void* destBitmapData = malloc( bytesPerRow * destResolution.height );//4*width*height
        if( destBitmapData == NULL ) NSLog(@"failed to allocate space for the output image!");
        
        // create the output bitmap context
        destContext = CGBitmapContextCreate( destBitmapData, destResolution.width, destResolution.height, 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast );
        // remember CFTypes assign/check for NULL. NSObjects assign/check for nil.
        if( destContext == NULL ) {
            free( destBitmapData );
            NSLog(@"failed to create the output bitmap context!");
        }
        
        // release the color space object as its job is done
        CGColorSpaceRelease( colorSpace );
        
        CGContextTranslateCTM( destContext, 0.0f, destResolution.height );
        CGContextScaleCTM( destContext, 1.0f, -1.0f );
        
        //加载原图时每次加载一小块，这样大图片内存不会一下子飙升很大
        sourceTile.size.width = sourceResolution.width;
        sourceTile.size.height = (int)( tileTotalPixels / sourceTile.size.width );
        sourceTile.origin.x = 0.0f;
        NSLog(@"source tile size: %f x %f",sourceTile.size.width, sourceTile.size.height);
        
        destTile.size.width = destResolution.width;
        destTile.size.height = sourceTile.size.height * imageScale;
        destTile.origin.x = 0.0f;
        NSLog(@"dest tile size: %f x %f",destTile.size.width, destTile.size.height);
        
        //
        sourceSeemOverlap = (int)( ( destSeemOverlap / destResolution.height ) * sourceResolution.height );
        NSLog(@"dest seem overlap: %f, source seem overlap: %f",destSeemOverlap, sourceSeemOverlap);
        
        //
        CGImageRef sourceTileImageRef;
        int iterations = (int)( sourceResolution.height / sourceTile.size.height );
        int remainder = (int)sourceResolution.height % (int)sourceTile.size.height;
        if( remainder ) iterations++;
        
        float sourceTileHeightMinusOverlap = sourceTile.size.height;
        sourceTile.size.height += sourceSeemOverlap;
        destTile.size.height += destSeemOverlap;
        NSLog(@"beginning downsize. iterations: %d, tile height: %f, remainder height: %d", iterations, sourceTile.size.height,remainder );
        
        for( int y = 0; y < iterations; ++y ) {
            // create an autorelease pool to catch calls to -autorelease made within the downsize loop.
            @autoreleasepool {
                sourceTile.origin.y = y * sourceTileHeightMinusOverlap + sourceSeemOverlap;
                destTile.origin.y = ( destResolution.height ) - ( ( y + 1 ) * sourceTileHeightMinusOverlap * imageScale + destSeemOverlap );
                
                NSLog(@"迭代-iteration: %d of %d, 原图y:%f, 目标y:%f",y+1,iterations, sourceTile.origin.y, destTile.origin.y);
                
                sourceTileImageRef = CGImageCreateWithImageInRect( _sourceImage.CGImage, sourceTile );
                if( y == iterations - 1 && remainder ) {
                    float dify = destTile.size.height;
                    destTile.size.height = CGImageGetHeight( sourceTileImageRef ) * imageScale;
                    dify -= destTile.size.height;
                    destTile.origin.y += dify;
                }
                
                CGContextDrawImage( destContext, destTile, sourceTileImageRef );
                CGImageRelease( sourceTileImageRef );
            }
            if( y < iterations - 1 ) {
                _sourceImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
                [self performSelectorOnMainThread:@selector(updateScrollView:) withObject:nil waitUntilDone:YES];
            }
            
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.processLabel.text = [NSString stringWithFormat:@"%0.1f%%", 100.0*(y+1)/iterations];
            });
        }
        NSLog(@"downsize complete.");
        [self performSelectorOnMainThread:@selector(initializeScrollView:) withObject:nil waitUntilDone:YES];
        CGContextRelease( destContext );
    }
}


-(void)createImageFromContext {
    // create a CGImage from the offscreen image context
    CGImageRef destImageRef = CGBitmapContextCreateImage( destContext );
    if( destImageRef == NULL ) NSLog(@"destImageRef is null.");
    // 在CGImage周围封装一个UIImage
    self.destImage = [UIImage imageWithCGImage:destImageRef scale:1.0f orientation:UIImageOrientationDownMirrored];
    
    CGFloat cgImageBytesPerRow = CGImageGetBytesPerRow(_destImage.CGImage); // 2560
    CGFloat cgImageHeight = CGImageGetHeight(_destImage.CGImage); // 1137
    NSUInteger size  = cgImageHeight * cgImageBytesPerRow*4/1024/1024;
    NSLog(@"逐行加载图片内存大小: %lu MB",(unsigned long)size); // 输出 2910720
    
    // release ownership of the CGImage, since destImage retains ownership of the object now.
    CGImageRelease( destImageRef );
    if( _destImage == nil ) NSLog(@"destImage is nil.");
}

-(void)updateScrollView:(id)arg {
    [self createImageFromContext];
    
    _progressView.image = _destImage;
}

-(void)initializeScrollView:(id)arg {
    [_progressView removeFromSuperview];
    [self createImageFromContext];
    
    _processLabel.hidden = YES;
    
    // create a scroll view to display the resulting image.
    _scrollView = [[ImageScrollView alloc] initWithFrame:self.view.bounds image:self.destImage];
    [self.view addSubview:_scrollView];
}



#pragma mark init ui
-(void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //image
    _progressView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_progressView];
    
    //label
    _processLabel = [[UILabel alloc]init];
    _processLabel.textAlignment = NSTextAlignmentCenter;
    _processLabel.textColor = [UIColor blackColor];
    _processLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_processLabel];
    
    [_processLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
}


#pragma mark overwrite methdos
//屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
