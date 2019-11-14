//
//  KQDraggblePolygonView.h
//  MordenAutoLayoutDemo
//
//  Created by Anker on 2018/12/15.
//  Copyright © 2018 Anker. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DPVPoint : NSObject
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
+(instancetype)pointWithCGPoint:(CGPoint)point;
-(CGPoint)CGPointValue;
@end

@interface DPVPolygon : NSObject
@property (nonatomic,strong) NSMutableArray<DPVPoint*>* points;
@property (nonatomic,assign) BOOL editable;
@property (nonatomic,strong,nullable) UIColor* sideColor;
-(instancetype)initWithPoints:(NSArray<DPVPoint*>*)points;
/**
 判断目标点是否在多边形内

 @param point 目标点
 @return YES表示落在多边形内
 */
-(BOOL)isPointInside:(CGPoint)point;
/**
 判断当前多边形的（非共顶点）边是否出现相交
 如果此判定为YES，则表示此多边形已经不是真正意义上的多边形了
 @return YES表示出现相交
 */
-(BOOL)hasCrossLineSegments;
@end


@interface DPVDraggablePolygonView : UIView

/**
 默认的多边形颜色
 当新增的Polygon未指定颜色时，采用此颜色。
 */
@property (nonatomic,strong) UIColor* sideColor;

/**
 是否仅处理矩形
 设置为YES时，将在针对有四个顶点的polygon拖动顶点时，保持矩形的形状。
 设置为NO时，可以拖出任意形状。
 */
@property (nonatomic,assign) BOOL rectangleOnly;

/**
 是否允许拖动内部的polygon。
 设置为YES时，标记为ediable的polygon在点中区域内部后可以拖动。
 @warnning 注意，如果ediable为NO，则无论如何都不能拖动polygon。
 */
@property (nonatomic,assign) BOOL allowDragPolygon;

/**
 是否允许拖动polygon到view的外部去。
 @warnning 对于非矩形，会在边界上有明显的“卡住”感觉，因为有一个角碰到边界就不会再动了。
 */
@property (nonatomic,assign) BOOL allowBeyondBorder;

/**
 是否允许对polygon进行拖动，选择等操作。
 当此开关为NO时，无论内部DPVPolygon的editable是否为YES，均不可进行任何操作。但是DPVPolygon的editable属性
 仍会影响其外观。
 */
@property (nonatomic,assign) BOOL allowEdit;

-(void)addPolygon:(NSArray<NSValue*> *)polygon editable:(BOOL)editable;

-(void)addPolygon:(NSArray<NSValue*> *)polygon sideColor:(nullable UIColor*)color editable:(BOOL)editable;

-(NSInteger)polygenCount;

-(DPVPolygon*)polygenAtIndex:(NSInteger)index;

-(void)removePolygonAtIndex:(NSInteger)index;

-(void)removeAllPolygens;

@end

NS_ASSUME_NONNULL_END
