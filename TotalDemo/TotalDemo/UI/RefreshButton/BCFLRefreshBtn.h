//
//  BCRefreshBtn.h
//  BatteryCam
//
//  Created by wzt on 2019/2/11.
//  Copyright © 2019年 oceanwing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCFLRefreshBtn : UIButton
@property (nonatomic,strong)UIActivityIndicatorView *roll;

+(instancetype)btnWith:(NSString *)title;
+(instancetype)btnNonNormalImg:(UIImage*)nonNormalImg nonHighImg:(UIImage*)nonHighImage
             selectedNormalImg:(UIImage*)selecedNormalImg selectedHighImg:(UIImage*)selectedHighImg
                    disableImg:(UIImage*)disableImg;
-(void)refresh:(BOOL)start;

+(instancetype)btnWithNormalImg:(UIImage *)normalImg selectImg:(UIImage *)selectImg;
-(void)nightRefresh:(BOOL)start;
@end
