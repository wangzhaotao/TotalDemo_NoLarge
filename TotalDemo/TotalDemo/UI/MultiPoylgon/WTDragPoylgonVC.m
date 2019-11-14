//
//  WTDragPoylgonVC.m
//  TotalDemo
//
//  Created by tyler on 7/6/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTDragPoylgonVC.h"
#import "DPVDraggablePolygonView.h"

@interface WTDragPoylgonVC ()
@property (nonatomic, assign) BOOL mHasBit;
@property (nonatomic,strong) DPVDraggablePolygonView* polygonView;

@end

@implementation WTDragPoylgonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
}


#pragma mark actions
-(void)addBtnAction:(id)sender {
    
    
    CGFloat insetX = (self.polygonView.bounds.size.width - 90) / 2;
    CGFloat insetY = (self.polygonView.bounds.size.height - sqrt(3)*90) / 2;
    CGRect rect = CGRectInset(self.polygonView.bounds, insetX, insetY);
    if(_mHasBit) {
        [self addRectToDraggableView:rect];
    } else{
        [self addHexagonToDraggableView:rect];
    }
    self.polygonView.allowEdit = YES;
    //[self toggleInterfaceStateIfCan:AZVStateEditing];
}

#pragma mark - dragble logic
-(void)addRectToDraggableView:(CGRect)rect {
    NSMutableArray* polygon = [NSMutableArray array];
    NSValue* v1 = [NSValue valueWithCGPoint:rect.origin];
    NSValue* v2 = [NSValue valueWithCGPoint:CGPointMake(rect.origin.x+rect.size.width, rect.origin.y)];
    NSValue* v3 = [NSValue valueWithCGPoint:CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height)];
    NSValue* v4 = [NSValue valueWithCGPoint:CGPointMake(rect.origin.x, rect.origin.y+rect.size.height)];
    [polygon addObject:v1];
    [polygon addObject:v2];
    [polygon addObject:v3];
    [polygon addObject:v4];
    if (!_mHasBit) {
        [self.polygonView addPolygon:polygon editable:YES];
    }else{
        //对多个的情况：新加入的默认为可编辑态，其他旧的都不可编辑
        NSInteger currentCount = [self.polygonView polygenCount];
        for (NSInteger i = 0; i < currentCount; i++) {
            DPVPolygon* py = [self.polygonView polygenAtIndex:i];
            py.editable = NO;
        }
        UIColor* color = [UIColor redColor];
        [self.polygonView addPolygon:polygon sideColor:color editable:YES];
    }
}

-(void)addHexagonToDraggableView:(CGRect)refRect {
    /**
     默认六边形是一个矩形的样式，点的序列为：
     0------1
     |      |
     5      2
     |      |
     4------3
     下边2和5点横坐标有点偏移是设备要求不能三个点同线
     */
    
    NSMutableArray* polygon = [NSMutableArray array];
    NSValue* v1 = [NSValue valueWithCGPoint:refRect.origin];
    NSValue* v2 = [NSValue valueWithCGPoint:CGPointMake(refRect.origin.x+refRect.size.width, refRect.origin.y)];
    NSValue* v3 = [NSValue valueWithCGPoint:CGPointMake(refRect.origin.x+refRect.size.width+60, refRect.origin.y+refRect.size.height*0.5)];
    NSValue* v4 = [NSValue valueWithCGPoint:CGPointMake(refRect.origin.x+refRect.size.width, refRect.origin.y+refRect.size.height)];
    NSValue* v5 = [NSValue valueWithCGPoint:CGPointMake(refRect.origin.x,refRect.origin.y+refRect.size.height)];
    NSValue* v6 = [NSValue valueWithCGPoint:CGPointMake(refRect.origin.x-60,refRect.origin.y+refRect.size.height*0.5)];
    [polygon addObject:v1];
    [polygon addObject:v2];
    [polygon addObject:v3];
    [polygon addObject:v4];
    [polygon addObject:v5];
    [polygon addObject:v6];
    [self.polygonView addPolygon:polygon editable:YES];
}


#pragma mark init UI
-(void)initUI {

    self.polygonView = [[DPVDraggablePolygonView alloc] initWithFrame:CGRectZero];
    self.polygonView.sideColor = iColor(0xfa, 0x2d, 0x50, 1); //红
    self.polygonView.backgroundColor = [UIColor clearColor];
    //self.polygonView.rectangleOnly = YES;
    self.polygonView.allowDragPolygon = YES;
    [self.view addSubview:self.polygonView];
    
    UIButton *addBtn = [[UIButton alloc]init];
    [addBtn setTitle:@"添加多边形" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    //layout
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@(20));
        make.width.equalTo(@90);
        make.height.equalTo(@40);
    }];
    [self.polygonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);
    }];
}











@end
