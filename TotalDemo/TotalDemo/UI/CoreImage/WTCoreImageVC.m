//
//  WTCoreImageVC.m
//  TotalDemo
//
//  Created by tyler on 4/24/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTCoreImageVC.h"
#import <CoreImage/CoreImage.h>
#import <GLKit/GLKit.h>
#import <CoreImage/CoreImageDefines.h>

@interface WTCoreImageVC ()
@property (nonatomic, strong) UIImageView *imgView1;
@property (nonatomic, strong) UIImageView *imgView2;
@property (nonatomic, strong) UIImageView *imgView3;
@property (nonatomic, strong) UIImageView *imgView4;

@end

@implementation WTCoreImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    [self initUI];
    
    //
    UIImage *image = [UIImage imageNamed:@"moguPic"];
    _imgView1.image = image; //= _imgView2.image = _imgView3.image = _imgView4.image
    //[self process_LianXi:image];
    
    
    
    //[self processImage_ColorFilterLink2:image];
    
    //[self colorsControlWithImage:image brightness:1 inputContraset:1.0 staturation:0.5];
    
    [self colorInvertWithImage:image];
    [self sepiaToneWithImage:image];
    [self gaussianBlurWithImage:image];
    [self pixellateWithImage:image];
}



//色彩控制滤镜
-(void)colorsControlWithImage:(UIImage*)image brightness:(CGFloat)brightness
               inputContraset:(CGFloat)inputContrast staturation:(CGFloat)inputStaturation {
    
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    if (brightness>-1 && brightness<=1) {
        [filter setValue:@(brightness) forKey:kCIInputBrightnessKey];
    }
    if (inputContrast>=0.25 && inputContrast<=4) {
        [filter setValue:@(inputContrast) forKey:kCIInputContrastKey];
    }
    if (inputStaturation>=0 && inputStaturation<=2) {
        [filter setValue:@(inputStaturation) forKey:kCIInputSaturationKey];
    }
    
    _imgView2.image = [self imageFromCIImage:filter.outputImage];
}
//反转颜色滤镜
-(void)colorInvertWithImage:(UIImage*)image {
    if (!image) {
        return;
    }
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    
    _imgView2.image = [self imageFromCIImage:filter.outputImage];
}
//棕色滤镜
-(void)sepiaToneWithImage:(UIImage*)image {
    
    if (!image) {
        return;
    }
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    
    _imgView2.image = [self imageFromCIImage:filter.outputImage];
}
//模糊滤镜
-(void)gaussianBlurWithImage:(UIImage*)image {
    
    if (!image) {
        return;
    }
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    
    _imgView2.image = [self imageFromCIImage:filter.outputImage];
}
//像素滤镜
-(void)pixellateWithImage:(UIImage*)image {
    
    if (!image) {
        return;
    }
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    
    //scale
    [filter setValue:@(100) forKey:@"inputScale"];
    
    //vector
    //CIVector *vector = [CIVector vectorWithCGPoint:CGPointMake(image.size.width/2, image.size.height/2)];
    //[filter setValue:vector forKey:@"inputCenter"];
    
    _imgView2.image = [self imageFromCIImage:filter.outputImage];
}
////人脸检测
//-(void)featureFaceWithImage:(UIImage*)image {
//
//    if (!image) {
//        return;
//    }
//    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
//
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIDectetor *dectector = [CIDecetor detectorOfType:CIDectectTypeFace context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
//    NSArray *features = [detector featuresInImage:ciImage];
//
//
//}


#pragma private methods
-(UIImage*)imageFromCIImage:(CIImage*)image {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    //Output
    CGImageRef imageRef = [context createCGImage:image fromRect:image.extent];
    UIImage *resImg = [UIImage imageWithCGImage:imageRef];
    return resImg;
}





#pragma mark methods1
-(void)processImage_ColorFilterLink2:(UIImage*)image {
    
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    /*
     kCICategoryDistortionEffect;
     kCICategoryGeometryAdjustment;
     kCICategoryCompositeOperation;
     kCICategoryHalftoneEffect;
     kCICategoryColorAdjustment;
     kCICategoryColorEffect;
     kCICategoryTransition;
     kCICategoryTileEffect;
     kCICategoryGenerator;
     kCICategoryReduction         NS_AVAILABLE(10_5, 5_0);
     kCICategoryGradient;
     kCICategoryStylize;
     kCICategorySharpen;
     kCICategoryBlur;
     kCICategoryVideo;
     kCICategoryStillImage;
     kCICategoryInterlaced;
     kCICategoryNonSquarePixels;
     kCICategoryHighDynamicRange;
     kCICategoryBuiltIn;
     kCICategoryFilterGenerator  NS_AVAILABLE(10_5, 9_0);
     */
    NSLog(@"效果分类:\n%@",[CIFilter filterNamesInCategory:kCICategoryTileEffect]); // //kCICategoryDistortionEffect
    
    CIFilter *filter = [CIFilter filterWithName:@"CIAffineClamp"]; //
    NSLog(@"具体效果的属性:\n%@",filter.attributes);

    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(0.5) forKey:kCIInputTransformKey];
//
    //CIContext
    CIContext *context = [CIContext contextWithOptions:nil];

    //Output
    CIImage *outPutImage = filter.outputImage;
    CGImageRef imageRef = [context createCGImage:outPutImage fromRect:outPutImage.extent];
    _imgView2.image = [UIImage imageWithCGImage:imageRef];
//
//    CIFilter *filter2 = [CIFilter filterWithName:@"CISepiaTone"]; //
//    [filter2 setValue:inputImage forKey:kCIInputImageKey];
//    [filter2 setValue:@(0.5) forKey:kCIInputIntensityKey];
//    //CIContext
//    CIContext *context2 = [CIContext contextWithOptions:nil];
//    //Output
//    CIImage *outPutImage2 = filter2.outputImage;
//    CGImageRef imageRef2 = [context createCGImage:outPutImage2 fromRect:outPutImage2.extent];
//    _imgView3.image = [UIImage imageWithCGImage:imageRef2];
//
//    CIFilter *filter3 = [CIFilter filterWithName:@"CISepiaTone"]; //
//    [filter3 setValue:inputImage forKey:kCIInputImageKey];
//    [filter3 setValue:@(1.0) forKey:kCIInputIntensityKey];
//    //CIContext
//    CIContext *context3 = [CIContext contextWithOptions:nil];
//    //Output
//    CIImage *outPutImage3 = filter3.outputImage;
//    CGImageRef imageRef3 = [context3 createCGImage:outPutImage3 fromRect:outPutImage3.extent];
//    _imgView4.image = [UIImage imageWithCGImage:imageRef3];
}
-(void)processImage_ColorFilterLink:(UIImage*)image {
    
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    //先打印NSLog(@"%@",[CIFilter filterNamesInCategory:kCICategoryDistortionEffect]);进去找到需要设置的属性(查询效果分类中都有什么效果)  可以设置什么效果
    //然后通过[CIFilter filterWithName:@""];找到属性   具体效果的属性
    //然后通过KVC的方式设置属性
    NSLog(@"效果分类:\n%@",[CIFilter filterNamesInCategory:kCICategoryColorEffect]); // //kCICategoryDistortionEffect
    /*
     1.查询 效果分类中 包含什么效果：filterNamesInCategory:
     2.查询 使用的效果中 可以设置什么属性（KVC） attributes
     
     使用步骤
     1.需要添加滤镜的源图
     2.初始化一个滤镜 设置滤镜（根据查询到的属性来设置）
     3.把滤镜 输出的图像 和滤镜  合并 CIContext -> 得到一个合成之后的图像
     4.展示
     */
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"]; //
    NSLog(@"具体效果的属性:\n%@",filter.attributes);
    //这个属性是必须赋值的，假如你处理的是图片的话
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIColor *color = [CIColor colorWithRed:1.000 green:0.759 blue:0.592 alpha:1];
    [filter setValue:color forKey:kCIInputColorKey];
    //CIContext
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *outPutImage = filter.outputImage;
    
    CGImageRef imageRef = [context createCGImage:outPutImage fromRect:outPutImage.extent];
    
    _imgView2.image = [UIImage imageWithCGImage:imageRef];

    [self addFilterLinkerWithImage:outPutImage];
}
//再次添加滤镜  ->  形成滤镜链
- (void)addFilterLinkerWithImage:(CIImage *)image
{
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setValue:image forKey:kCIInputImageKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef resultImage = [context createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
    _imgView3.image = [UIImage imageWithCGImage:resultImage];
}










#pragma mark methods1
-(void)process_LianXi:(UIImage*)image {
    
    //
    UIImage *resImg1 = [self coreImageProcessImage1:image];
    _imgView2.image = resImg1;
    
    //
    UIImage *resImg2 = [self coreImageProcessImage2:image];
    _imgView3.image = resImg2;
    
    //
    [self openglesProcessImage:image];
}

-(void)openglesProcessImage:(UIImage*)image {
    
    //导入要渲染的图片
    UIImage *showImage = image;
    CGRect rect        = CGRectMake(0, 0, showImage.size.width, showImage.size.height);
    
    //获取OpenGLES渲染的上下文
    EAGLContext *eagContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //创建出渲染的buffer
    GLKView *glkView = [[GLKView alloc] initWithFrame:rect
                                              context:eagContext];
    [glkView bindDrawable];
    [self.view addSubview:glkView]; //CIFilter
    
    //创建出CoreImage的上下文
    CIContext *ciContext = [CIContext contextWithEAGLContext:eagContext
                                                     options:@{kCIContextWorkingColorSpace: [NSNull null]}];
    
    //CoreImage相关设置
    CIImage *ciImage = [[CIImage alloc] initWithImage:showImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@(0) forKey:kCIInputIntensityKey];
    
    //开始渲染
    [ciContext drawImage:[filter valueForKey:kCIOutputImageKey]
                  inRect:CGRectMake(0, 0, glkView.drawableWidth, glkView.drawableHeight)
                fromRect:[ciImage extent]];
    
    [glkView display];
    
    
    _imgView4.hidden = YES;
    __weak typeof(self) weakSelf = self;
    [glkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(weakSelf.imgView4);
        make.width.height.equalTo(weakSelf.imgView4);
    }];
}

-(UIImage*)coreImageProcessImage1:(UIImage*)image {
    
    //导入CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    //创建出Filter滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
    
    [filter setValue:ciImage forKey:kCIInputImageKey];
    
    [filter setDefaults];
    
    CIImage *outImage = [filter valueForKey:kCIOutputImageKey];
    
    //用CIContext将滤镜中的图片渲染出来
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgImage = [context createCGImage:outImage
                                       fromRect:[outImage extent]];
    
    //导出图片
    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return showImage;
}

-(UIImage*)coreImageProcessImage2:(UIImage*)image {
    
    //导入CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    //创建出Filter滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
    
    [filter setValue:ciImage forKey:kCIInputImageKey];
    
    [filter setDefaults];
    
    CIImage *outImage = [filter valueForKey:kCIOutputImageKey];
    
    CIFilter *filterTwo = [CIFilter filterWithName:@"CIHueAdjust"];
    
    [filterTwo setValue:outImage forKey:kCIInputImageKey];
    
    [filterTwo setDefaults];
    
    [filterTwo setValue:@(1.0f) forKey:kCIInputAngleKey]; //如果不增加这行新增的滤镜不会生效
    
    CIImage *outputImage = [filterTwo valueForKey:kCIOutputImageKey];
    
    //用CIContext将滤镜中的图片渲染出来
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    //导出图片
    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return showImage;
}


-(void)initUI {
    
    UIImageView *imgView1 = [[UIImageView alloc]init];
    [self.view addSubview:imgView1];
    _imgView1 = imgView1;
    
    UIImageView *imgView2 = [[UIImageView alloc]init];
    [self.view addSubview:imgView2];
    _imgView2 = imgView2;
    
    UIImageView *imgView3 = [[UIImageView alloc]init];
    [self.view addSubview:imgView3];
    _imgView3 = imgView3;
    
    UIImageView *imgView4 = [[UIImageView alloc]init];
    [self.view addSubview:imgView4];
    _imgView4 = imgView4;
    
    //layout
    CGFloat origin_x = 20;
    CGFloat origin_y = 50;
    CGFloat imgW = (iScreenW-origin_x*3)/2;
    CGFloat imgH = (iScreenH-64-origin_y*2-origin_x)/2;
    [imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(imgW));
        make.height.equalTo(@(imgH));
        make.top.equalTo(@(origin_y));
        make.leading.equalTo(@(origin_x));
    }];
    [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(imgW));
        make.height.equalTo(@(imgH));
        make.top.equalTo(@(origin_y));
        make.leading.equalTo(imgView1.mas_trailing).offset(origin_x);
    }];
    [imgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(imgW));
        make.height.equalTo(@(imgH));
        make.top.equalTo(imgView1.mas_bottom).offset(origin_x);
        make.leading.equalTo(@(origin_x));
    }];
    [imgView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(imgW));
        make.height.equalTo(@(imgH));
        make.top.equalTo(imgView1.mas_bottom).offset(origin_x);
        make.leading.equalTo(imgView3.mas_trailing).offset(origin_x);
    }];
}


@end
