

//
//  BCRefreshBtn.m
//  BatteryCam
//
//  Created by wzt on 2019/2/11.
//  Copyright © 2019年 oceanwing. All rights reserved.
//

#import "BCFLRefreshBtn.h"
@interface BCFLRefreshBtn()
@property (nonatomic,strong)NSString *title;

@property (nonatomic, strong) UIImage *nonNormalImage;
@property (nonatomic, strong) UIImage *nonHighlightImage;
@property (nonatomic, strong) UIImage *selectedNormalImage;
@property (nonatomic, strong) UIImage *selectedHighlightImage;

@end

@implementation BCFLRefreshBtn

+(instancetype)btnWith:(NSString *)title{
    BCFLRefreshBtn *btn = [[BCFLRefreshBtn alloc]init];
    btn.title=title;
    [btn setTitle:title forState:0];
    btn.titleLabel.font=iFont(14);
    UIColor *color = [[UIColor whiteColor]colorWithAlphaComponent:.7];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:[color colorWithAlphaComponent:.6] forState:UIControlStateHighlighted];
    [btn setTitleColor:[color colorWithAlphaComponent:.3] forState:UIControlStateDisabled];
    btn.clipsToBounds=YES;
    return btn;
}

+(instancetype)btnWithNormalImg:(UIImage *)normalImg selectImg:(UIImage *)selectImg{
    BCFLRefreshBtn *btn = [[BCFLRefreshBtn alloc]init];
    btn.nonNormalImage = normalImg;
    btn.selectedNormalImage = selectImg;
    [btn.roll setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [btn setImage:normalImg forState:UIControlStateNormal];
    [btn setImage:selectImg forState:UIControlStateSelected];
    return btn;
}

-(void)nightRefresh:(BOOL)start{
    if(start){
        [self.roll startAnimating];
        [self setTitle:@"" forState:0];
        
        //image
        [self setImage:nil forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateSelected];
    }else{
        [self.roll stopAnimating];
        
        //image
        [self setImage:self.nonNormalImage forState:UIControlStateNormal];
        [self setImage:self.selectedNormalImage forState:UIControlStateSelected];
    }
    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        [self layoutIfNeeded];
    } completion:nil];
    
}



+(instancetype)btnNonNormalImg:(UIImage*)nonNormalImg nonHighImg:(UIImage*)nonHighImage
             selectedNormalImg:(UIImage*)selecedNormalImg selectedHighImg:(UIImage*)selectedHighImg
                    disableImg:(UIImage*)disableImg {
    
    BCFLRefreshBtn *btn = [[BCFLRefreshBtn alloc]init];
    btn.nonNormalImage = nonNormalImg;
    btn.nonHighlightImage = nonHighImage;
    btn.selectedNormalImage = selecedNormalImg;
    btn.selectedHighlightImage = selectedHighImg;
    [btn.roll setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [btn setImage:nonNormalImg forState:UIControlStateNormal];
    [btn setImage:nonHighImage forState:UIControlStateHighlighted];
    //[btn setImage:selecedNormalImg forState:UIControlStateSelected];
    [btn setImage:disableImg forState:UIControlStateDisabled];
    return btn;
}

-(void)refresh:(BOOL)start{
    if(start){
        [self.roll startAnimating];
        [self setTitle:@"" forState:0];
        
        //image
        [self setImage:nil forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateHighlighted];
    }else{
        [self.roll stopAnimating];
        [self setTitle:self.title forState:0];
        
        //image
        UIImage *normalImg = self.selected?_selectedNormalImage:_nonNormalImage;
        UIImage *highlightImg = self.selected?_selectedHighlightImage:_nonHighlightImage;
        [self setImage:normalImg forState:UIControlStateNormal];
        [self setImage:highlightImg forState:UIControlStateHighlighted];
    }
    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}





#pragma mark 重写
-(void)setSelected:(BOOL)selected {
    
    
    //image
    UIImage *normalImg = selected?_selectedNormalImage:_nonNormalImage;
    UIImage *highlightImg = selected?_selectedHighlightImage:_nonHighlightImage;
    if (normalImg && highlightImg) {
//
//        if (selected) {
//            [self setImage:normalImg forState:UIControlStateHighlighted];
//        }else {
//            [self setImage:highlightImg forState:UIControlStateHighlighted];
//        }
        [self setImage:highlightImg forState:UIControlStateHighlighted];
        [self setImage:normalImg forState:UIControlStateNormal];
    }
    
    [super setSelected:selected];
}
-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        UIImage *img = [self imageForState:UIControlStateHighlighted];
        
    } else {
        
    }
}


#pragma mark set/get
-(UIActivityIndicatorView *)roll{
    if(_roll)return _roll;
    _roll=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    _roll.hidesWhenStopped=YES;
    [self addSubview:_roll];
    [_roll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    return _roll;
}
@end
