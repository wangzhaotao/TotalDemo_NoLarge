//
//  BCDrawLocalStorageView.m
//  TotalDemo
//
//  Created by ocean on 3/5/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "BCDrawLocalStorageView.h"
#import "UIColor+RectExtension.h"

@interface BCDrawLocalStorageView ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *top_available_label;
@property (nonatomic, strong) UILabel *top_total_label;

@property (nonatomic, strong) NSArray *colorArray;

@property (nonatomic, strong) BCDrawStorageView *drawView;

@end

@implementation BCDrawLocalStorageView

-(instancetype)init {
    if (self = [super init]) {
        [self initUI];
        [self setAutoresizesSubviews:YES];
    }
    return self;
}

-(void)updateWithTotal:(CGFloat)total system:(CGFloat)system video:(CGFloat)video {
    
    CGFloat available = total-(system+video);
    
    [self updateWithTotal:total available:available system:system video:video];
}
-(void)updateWithTotal:(CGFloat)total available:(CGFloat)available system:(CGFloat)system video:(CGFloat)video {
    
    self.top_total_label.text = [NSString stringWithFormat:@"%0.1f", total];
    self.top_available_label.text = [NSString stringWithFormat:@"%0.1f", available];
    
    [self.drawView updateWithColorArray:self.colorArray numberArray:@[[NSNumber numberWithFloat:system],
                                                                      [NSNumber numberWithFloat:video],
                                                                      [NSNumber numberWithFloat:available]
                                                                      ]];
}

-(void)initUI {
    
    //lines
    UIView *line_up = [[UIView alloc]init];
    line_up.backgroundColor = iColor(0xf0, 0xf0, 0xf0, 1.0);
    [self addSubview:line_up];
    
    UIView *line_down = [[UIView alloc]init];
    line_down.backgroundColor = iColor(0xf0, 0xf0, 0xf0, 1.0);
    [self addSubview:line_down];
    
    //available total
    [self createTopLabelViewWithAvailable:3.4 total:4.0];
    
    //system video available
    [self createBottomLabelViewsWithDataArray:@[@"System", @"Video", @"Available"]];
    
    //draw view
    BCDrawStorageView *drawView = [[BCDrawStorageView alloc]init];
    drawView.layer.cornerRadius = 5.0;
    drawView.layer.masksToBounds = YES;
    [self addSubview:drawView];
    self.drawView = drawView;
    
    //layout
    __weak typeof(self) weakSelf = self;
    [line_up mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@1.0);
    }];
    [line_down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(weakSelf.mas_bottomMargin).offset(0);
        make.height.equalTo(@1.0);
    }];
    [drawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.height.equalTo(@15);
        make.top.equalTo(weakSelf.topView.mas_bottom).offset(12);
    }];
}

-(void)createTopLabelViewWithAvailable:(CGFloat)available total:(CGFloat)total {
    
    UIView *topView = [[UIView alloc]init];
    [self addSubview:topView];
    _topView = topView;
    
    NSString *availableText = NSLocalizedString(@"Available:", 0);
    UIView *availableView = [self createTextView:availableText number:available flag:YES];
    [topView addSubview:availableView];
    
    NSString *totalText = NSLocalizedString(@"Total:", 0);
    UIView *totalView = [self createTextView:totalText number:total flag:NO];
    [topView addSubview:totalView];
    
    //layout
    __weak typeof(self) weakSelf = self;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    [availableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.top.equalTo(@15);
        make.bottom.equalTo(topView.mas_bottomMargin).offset(0);
    }];
    [totalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-15));
        make.top.equalTo(@15);
        make.bottom.equalTo(topView.mas_bottomMargin).offset(0);
    }];
}

-(void)createBottomLabelViewsWithDataArray:(NSArray<NSString*>*)dataArray {
    
    UIView *leftView = nil;
    for (int i=0; i<dataArray.count; i++) {
        NSString *title = dataArray[i];
        UIColor *color = self.colorArray[i%(self.colorArray.count)];
        
        UIView *labView = [self createColorView:color text:title];
        [self addSubview:labView];
        
        __weak typeof(self) weakSelf = self;
        if (leftView) {
            [labView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(leftView.mas_trailing).offset(20);
                make.bottom.equalTo(weakSelf.mas_bottomMargin).offset(-15);
                make.top.equalTo(weakSelf.topView.mas_bottom).offset(45);
            }];
        }else{
            [labView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(@15);
                make.bottom.equalTo(weakSelf.mas_bottomMargin).offset(-15);
                make.top.equalTo(weakSelf.topView.mas_bottom).offset(45);
            }];
        }
        leftView = labView;
    }
}

-(UIView*)createTextView:(NSString*)title number:(CGFloat)number flag:(BOOL)flag {
    
    UIView *view = [[UIView alloc]init];
    [self addSubview:view];
    
    //
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = iColor(0x22, 0x22, 0x22, 1.0);
    titleLabel.font = iFont(14);
    titleLabel.text = title;
    [view addSubview:titleLabel];
    
    UILabel *numLabel = [[UILabel alloc]init];
    numLabel.textColor = iColor(0x22, 0x22, 0x22, 1.0);
    numLabel.font = iFont(14);
    numLabel.text = [NSString stringWithFormat:@"%.1f", number];
    [view addSubview:numLabel];
    if (flag) {
        _top_available_label = numLabel;
    }else{
        _top_total_label = numLabel;
    }
    
    //layout
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleLabel.mas_trailing).offset(5);
        make.trailing.equalTo(@0);
        make.top.bottom.equalTo(@0);
    }];
    
    return view;
}

-(UIView*)createColorView:(UIColor*)color text:(NSString*)text {
    
    UIView *view = [[UIView alloc]init];
    [self addSubview:view];
    
    //
    UIView *colorView = [[UIView alloc]init];
    colorView.backgroundColor = color;
    [view addSubview:colorView];
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = iColor(0x22, 0x22, 0x22, 1.0);
    label.font = iFont(14);
    label.text = text;
    [view addSubview:label];
    
    //layout
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@15);
        make.leading.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(colorView.mas_trailing).offset(5);
        make.trailing.equalTo(@0);
        make.top.bottom.equalTo(@0);
    }];
    
    return view;
}

-(NSArray*)colorArray {
    
    if (!_colorArray) {
        _colorArray = @[iColor(0xff, 0xc8, 0x50, 1.0), iColor(0xff, 0x91, 0x46, 1.0),
                        iColor(0xec, 0xec, 0xec, 1.0)];
    }
    return _colorArray;
}

@end



@interface BCDrawStorageView ()
@property (nonatomic, strong) NSArray<UIColor*> *colorArray;
@property (nonatomic, strong) NSArray<NSNumber*> *numberArray;

@end

@implementation BCDrawStorageView

-(instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)updateWithColorArray:(NSArray<UIColor*>*)colorArray numberArray:(NSArray<NSNumber*>*)numberArray {
    
    if (colorArray.count != numberArray.count) {
        _colorArray = nil;
        _numberArray = nil;
        return;
    }
    
    _colorArray = colorArray;
    _numberArray = numberArray;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    //
    CGFloat total = 0;
    for (NSNumber *number in _numberArray) {
        total += [number floatValue];
    }
    
    // 获取上下文CGContext
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    
    CGFloat offset = 0;
    for (int i=0; i<_numberArray.count; i++) {
        CGFloat number = [_numberArray[i] floatValue];
        CGFloat color_w = width * number/total;
        UIColor *color = _colorArray[i];
        
        if (i!=0) {
            CGFloat xx = 1.0;
            CGPoint points[4];
            points[0] = CGPointMake(offset,     0);
            points[1] = CGPointMake(offset+xx, 0);
            points[2] = CGPointMake(offset+xx, height);
            points[3] = CGPointMake(offset,     height);
            offset = offset+xx;
            
            UIColor *color = iColor(0xff, 0xff, 0xff, 1.0);
            CGContextSetRGBStrokeColor(context, color.R/255.0, color.G/255.0, color.B/255.0, 1.0);
            CGContextSetRGBFillColor(context, color.R/255.0, color.G/255.0, color.B/255.0, 1.0);
            CGContextAddLines(context, points, 4);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        
        CGPoint points[4];
        points[0] = CGPointMake(offset,         0);
        points[1] = CGPointMake(offset+color_w, 0);
        points[2] = CGPointMake(offset+color_w, height);
        points[3] = CGPointMake(offset,         height);
        offset = offset+color_w;
        
        CGContextSetRGBStrokeColor(context, color.R/255.0, color.G/255.0, color.B/255.0, 1.0);
        CGContextSetRGBFillColor(context, color.R/255.0, color.G/255.0, color.B/255.0, 1.0);
        CGContextAddLines(context, points, 4);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

@end
