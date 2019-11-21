//
//  WTGifAnimationVC.m
//  TotalDemo
//
//  Created by tyler on 11/20/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTGifAnimationVC.h"
#import "Lottie.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
#import "YYKit.h"

@interface WTGifAnimationVC ()

@end

@implementation WTGifAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat originX = 10;
    CGFloat width = (screenWidth - originX*4)/3;
    //显示Gif动画
    //1.CoreGraphic加载gif文件 / UIWebView加载gif文件
    UIView *firstView = [self showGifWithCoreGraphic];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(originX));
        make.width.height.equalTo(@(width));
        make.top.equalTo(@80);
    }];
    
    //2.Lottie
    UIView *secondView = [self showGifWithLottie];
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.height.top.equalTo(firstView);
    }];
    
    //3.SDWebImage
    UIView *thirdView = [self showGifWithSDWebImage];
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-originX));
        make.width.height.top.equalTo(firstView);
    }];
    
    //4.UIWebView
    UIView *fourthView = [self showGifWithWebView];
    [fourthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.leading.equalTo(firstView);
        make.top.equalTo(firstView.mas_bottom).offset(originX);
    }];
    
    //5.YYImage
    UIView *fifthView = [self showGifWithYYImage];
    [fifthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(firstView);
        make.top.equalTo(firstView.mas_bottom).offset(originX);
        make.centerX.equalTo(@0);
    }];
    
//    //6.（1.2）
//    UIView *sixthView = [self showGifJsonWithCoreGraphic];
//    [sixthView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(firstView.mas_bottom).offset(originX);
//        make.trailing.equalTo(@(-originX));
//        make.width.height.equalTo(firstView);
//    }];
    
}

//1.CoreGraphic
-(UIView*)showGifWithCoreGraphic {
    
    UIImageView *imgView = [[UIImageView alloc]init];
    [imgView setAnimationImages:[self loadGifImageSource]];
    imgView.animationDuration = 1.0 ;
    imgView.animationRepeatCount = MAXFLOAT;
    [imgView startAnimating];
    [self.view addSubview:imgView];
    
    [self addLabel:@"CoreGraphic\ngif" target:imgView];
    
    return imgView;
}

//1.2 CoreGraphic - json
-(UIView*)showGifJsonWithCoreGraphic {
    
    UIImageView *imgView = [[UIImageView alloc]init];
    [imgView setAnimationImages:[self loadJsonGifImageArray]];
    imgView.animationDuration = 1.0 ;
    imgView.animationRepeatCount = MAXFLOAT;
    [imgView startAnimating];
    [self.view addSubview:imgView];
    
    [self addLabel:@"CoreGraphic\njson" target:imgView];
    
    return imgView;
}


//2.Lottie
-(UIView*)showGifWithLottie {
    
    NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"animation" ofType:@"json"];
    LOTAnimationView *gifView = [LOTAnimationView animationWithFilePath:jsonPath];
    gifView.loopAnimation = YES;
    [gifView playWithCompletion:^(BOOL animationFinished) {
        
    }];
    [self.view addSubview:gifView];
    
    [self addLabel:@"Lottie\njson" target:gifView];
    
    return gifView;
}

//3.SDWebImage
-(UIView*)showGifWithSDWebImage {
    
    NSString *gifPath = [[NSBundle mainBundle]pathForResource:@"animation" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:gifPath];

    UIImageView *imgView = [[UIImageView alloc]init];
    UIImage *img = [UIImage sd_imageWithGIFData:gifData];
    imgView.image = img;
    [self.view addSubview:imgView];
    
    [self addLabel:@"SDWebImage\ngif" target:imgView];
    
    return imgView;
}

//4.WebView
-(UIView*)showGifWithWebView {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"animation" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.scalesPageToFit = YES;
    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    [self.view addSubview:webView];
    
     [self addLabel:@"UIWebView\ngif" target:webView];
    
    return webView;
}

//5.YYImage
-(UIView*)showGifWithYYImage {
    
    YYImage *image = [YYImage imageNamed:@"animation.gif"];
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    [self.view addSubview:imageView];
    
    [self addLabel:@"YYKit\ngif" target:imageView];
    
    return imageView;
}


#pragma mark private methods
-(NSArray<UIImage*>*)loadGifImageSource {
    
    NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"animation" ofType:@"gif"];
    
    //获取gif文件数据
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:jsonPath], NULL);
    //获取gif文件中图片的个数
    size_t count =CGImageSourceGetCount(source);
    //存放所有图片数组
    NSMutableArray <UIImage*>*imageArray = [[NSMutableArray alloc] init];

    //遍历gif
    for(int i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage* img = [UIImage imageWithCGImage: image];
        [imageArray addObject:img];
    }
    
    return imageArray;
}

-(NSArray<UIImage*>*)loadJsonGifImageArray {
    
    NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"animation" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    
    NSString *gifPath = [[NSBundle mainBundle]pathForResource:@"animation" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:0];
    NSLog(@"jsonObj: %@", jsonObj);
    
    id gifObj = [NSJSONSerialization JSONObjectWithData:gifData options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:0];
    NSLog(@"gifObj: %@", gifObj);
    
    //获取gif文件数据
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)jsonData, NULL);
    //获取gif文件中图片的个数
    size_t count =CGImageSourceGetCount(source);
    if (count==0) {
        source = CGImageSourceCreateWithData((CFDataRef)gifData, NULL);
        count =CGImageSourceGetCount(source);
    }
    //存放所有图片数组
    NSMutableArray <UIImage*>*imageArray = [[NSMutableArray alloc] init];

    //遍历gif
    for(int i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage* img = [UIImage imageWithCGImage: image];
        [imageArray addObject:img];
    }
    
    return imageArray;
}

-(void)addLabel:(NSString*)title target:(UIView*)target {
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.numberOfLines = 2;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    [target addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
}


@end
