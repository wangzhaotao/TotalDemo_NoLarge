//
//  KQDraggblePolygonView.m
//  MordenAutoLayoutDemo
//
//  Created by Anker on 2018/12/15.
//  Copyright © 2018 Anker. All rights reserved.
//

#import "DPVDraggablePolygonView.h"



@implementation DPVPoint

+(instancetype)pointWithCGPoint:(CGPoint)point {
    DPVPoint* dp = [[self alloc] init];
    if (self) {
        dp.x = point.x;
        dp.y = point.y;
    }
    return dp;
}

-(CGPoint)CGPointValue {
    return CGPointMake(self.x, self.y);
}
@end


@implementation DPVPolygon
-(instancetype)initWithPoints:(NSArray *)points {
    self = [super init];
    if (self) {
        self.points = [NSMutableArray arrayWithArray:points];
    }
    return self;
}

-(BOOL)isPointInside:(CGPoint)point {
    if ([self.points count] <= 1) {
        return NO;
    }
    if ([self.points count] == 2) {
        //TODO: 这里可以考虑判断是否在线段内，先不实现
        return NO;
    }
    //以下参考：https://blog.csdn.net/hgl868/article/details/7947272
    //http://www.cnblogs.com/luxiaoxun/p/3722358.html
    int nCross = 0;
    NSInteger nCount = self.points.count;
    for (int i = 0; i < nCount; i++) {
        DPVPoint* p1 = self.points[i];
        DPVPoint* p2 = self.points[(i + 1) % nCount];
        
        // 求解 y=p.y 与 p1p2 的交点
        
        if ( p1.y == p2.y ) // p1p2 与 y=p0.y平行
            continue;
        
        if ( point.y < MIN(p1.y, p2.y) ) // 交点在p1p2延长线上
            continue;
        if ( point.y >= MAX(p1.y, p2.y) ) // 交点在p1p2延长线上
            continue;
        
        // 求交点的 X 坐标 --------------------------------------------------------------
        double x = (double)(point.y - p1.y) * (double)(p2.x - p1.x) / (double)(p2.y - p1.y) + p1.x;
        
        if ( x > point.x )
            nCross++; // 只统计单边交点
    }
    // 单边交点为偶数，点在多边形之外
    return (nCross % 2 == 1);
}

-(BOOL)hasCrossLineSegments {
    NSInteger pointCount = [self.points count];
    if (pointCount <= 3) { //对于三角形或更小的边数，不会出现非公共顶点的边
        return NO;
    }
    BOOL cross = NO;
    for (NSInteger i = 0; i < pointCount-1; i++) {
        NSInteger xp1 = i;
        NSInteger xp2 = i+1;
        for (NSInteger j = i+2; j < pointCount; j++) {
            NSInteger xq1 = j%pointCount;
            NSInteger xq2 = (j+1)%pointCount;
            if (xq2==xp1) { break; } //已经到头了，不需要继续了
            DPVPoint* p1 = [self.points objectAtIndex:xp1];
            DPVPoint* p2 = [self.points objectAtIndex:xp2];
            DPVPoint* q1 = [self.points objectAtIndex:xq1];
            DPVPoint* q2 = [self.points objectAtIndex:xq2];
            cross = [self isTwoLineSegmentsCrossing:p1 :p2 :q1 :q2];
//            NSLog(@"CP: (%d,%d) vs (%d,%d)",xp1,xp2,xq1,xq2);
            if (cross) {
//                NSLog(@"CROSS: p1(%.lf,%.lf) p2(%.lf,%.lf) vs q1(%.lf,%.lf) q2(%.lf,%.lf)",p1.x,p1.y,p2.x,p2.y,q1.x,q1.y,q2.x,q2.y);
                break;
            }
        }
        if(cross) { break; }
    }
    return cross;
}

#pragma mark - private

-(BOOL)passQuickCrossTest:(DPVPoint*)p1 :(DPVPoint*)p2 :(DPVPoint*)q1 :(DPVPoint*)q2 {
    return MIN(p1.x,p2.x) <= MAX(q1.x,q2.x) &&
           MIN(q1.x,q2.x) <= MAX(p1.x,p2.x) &&
           MIN(p1.y,p2.y) <= MAX(q1.y,q2.y) &&
           MIN(q1.y,q2.y) <= MAX(p1.y,p2.y);
}

-(BOOL)isTwoLineSegmentsCrossing:(DPVPoint*)p1 :(DPVPoint*)p2 :(DPVPoint*)q1 :(DPVPoint*)q2 {
    //方法来源：https://segmentfault.com/a/1190000004070478
    //注意原文论述及源码有误，说两个叉积条件满足其一即可，实际上需要同时满足才可（看评论有说）
    if (![self passQuickCrossTest:p1 :p2 :q1 :q2]) {
        return NO;
    }
    if(
       ((q1.x-p1.x)*(q1.y-q2.y)-(q1.y-p1.y)*( q1.x-q2.x)) * ((q1.x-p2.x)*(q1.y-q2.y)-(q1.y-p2.y)*(q1.x-q2.x)) < 0 &&
       ((p1.x-q1.x)*(p1.y-p2.y)-(p1.y-q1.y)*(p1.x-p2.x)) * ((p1.x-q2.x)*(p1.y-p2.y)-(p1.y-q2.y)*( p1.x-p2.x)) < 0
       )
        return YES;
    else
        return NO;
}
@end

typedef NS_ENUM(int32_t, DPVMoveAction) {
    DPVMoveActionUnknwon,
    DPVMoveActionDragPoint,
    DPVMoveActionSelectPolygon,
    DPVMoveActionDragPolygon,
};


@interface DPVDraggablePolygonView() {
    ///激活的多边形顶点
    DPVPoint* _activePoint;
    ///激活的多边形
    DPVPolygon* _activePolygon;
    DPVMoveAction _moveAction;
}
@property (nonatomic,strong) NSMutableArray<DPVPolygon*> * polygons;
@end

@implementation DPVDraggablePolygonView

-(void)awakeFromNib {
    [super awakeFromNib];
    [self internalInit];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self internalInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInit];
    }
    return self;
}

-(void)internalInit {
    self.polygons = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
}

-(void)addPolygon:(NSArray<NSValue *> *)polygon editable:(BOOL)editable {
    [self addPolygon:polygon sideColor:nil editable:editable];
}

-(void)addPolygon:(NSArray<NSValue *> *)polygon sideColor:(UIColor *)color editable:(BOOL)editable {
    if (polygon.count < 3) {
        return ;
    }
    NSMutableArray* points = [NSMutableArray arrayWithCapacity:polygon.count];
    for (NSValue* value in polygon) {
        CGPoint point = [value CGPointValue];
        DPVPoint* dp = [DPVPoint pointWithCGPoint:point];
        [points addObject:dp];
    }
    DPVPolygon* pg = [[DPVPolygon alloc] initWithPoints:points];
    pg.editable = editable;
    pg.sideColor = color;
    [self.polygons addObject:pg];
    [self setNeedsDisplay];
}

-(NSInteger)polygenCount {
    return [self.polygons count];
}

-(DPVPolygon *)polygenAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.polygons.count) {
        return nil;
    }
    return [self.polygons objectAtIndex:index];
}

-(void)removePolygonAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.polygons.count) {
        return ;
    }
    [self.polygons removeObjectAtIndex:index];
    [self setNeedsDisplay];
}

-(void)removeAllPolygens {
    [self.polygons removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark - drawing
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    for (DPVPolygon* polygon in self.polygons) {
        [self fillPolygon:contextRef with:polygon.points color:polygon.sideColor];
        [self strokePolygon:contextRef with:polygon.points color:polygon.sideColor];
        if (polygon.editable) {
            for (DPVPoint* value in polygon.points) {
                CGPoint point = [value CGPointValue];
                [self drawPolygonPoint:contextRef at:point color:polygon.sideColor];
            }
        }
    }
}

-(void)drawPolygonPoint:(CGContextRef)ref at:(CGPoint)point color:(UIColor*)color {
    CGFloat r = 5;
    CGRect rect = CGRectMake(point.x-r, point.y-r, r*2, r*2);
    UIGraphicsPushContext(ref);
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(ref, 4);
    CGContextFillEllipseInRect(ref, rect);
    UIColor* cc = color ?: self.sideColor;
    [cc set];
    CGContextAddEllipseInRect(ref, rect);
    CGContextStrokePath(ref);
    UIGraphicsPopContext();
}

-(void)strokePolygon:(CGContextRef)ref with:(NSArray*)polygon color:(UIColor*)color {
    UIGraphicsPushContext(ref);
    CGContextSetLineWidth(ref, 1);
    CGContextSetLineCap(ref, kCGLineCapSquare);
    UIColor* cc = color ?: self.sideColor;
    [cc set];
    CGContextBeginPath(ref);
    CGPoint origin = [(NSValue*)[polygon firstObject] CGPointValue];
    CGContextMoveToPoint(ref, origin.x, origin.y);
    for (NSInteger i = 1; i < polygon.count; i++) {
        CGPoint point = [(NSValue*)[polygon objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(ref, point.x, point.y);
    }
    CGContextAddLineToPoint(ref, origin.x, origin.y);
    CGContextClosePath(ref);
    CGContextStrokePath(ref);
    
    
    UIGraphicsPopContext();
}

-(void)fillPolygon:(CGContextRef)ref with:(NSArray*)polygon color:(UIColor*)color {
    UIGraphicsPushContext(ref);
    CGContextBeginPath(ref);
    CGPoint origin = [(NSValue*)[polygon firstObject] CGPointValue];
    CGContextMoveToPoint(ref, origin.x, origin.y);
    for (NSInteger i = 1; i < polygon.count; i++) {
        CGPoint point = [(NSValue*)[polygon objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(ref, point.x, point.y);
    }
    CGContextAddLineToPoint(ref, origin.x, origin.y);
    CGContextClosePath(ref);
    CGFloat r,g,b;
    UIColor* cc = color ?: self.sideColor;
    [cc getRed:&r green:&g blue:&b alpha:nil];
    [[UIColor colorWithRed:r green:g blue:b alpha:0.4] set];
    CGContextFillPath(ref);
    
    UIGraphicsPopContext();
}

#pragma mark - touch event

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(!self.allowEdit) {
        [super touchesBegan:touches withEvent:event];
        return ;
    }
    
    UITouch* touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    //检查是否有顶点在这个点击的附近
    CGFloat radius = 25;
    BOOL found = NO;
    for (DPVPolygon* polygon in self.polygons) {
        if (!polygon.editable) {
            continue ;
        }
        for (DPVPoint* value in polygon.points) {
            CGPoint point = [value CGPointValue];
            CGRect targetRect = CGRectMake(point.x-radius, point.y-radius, 2*radius, 2*radius);
            if (CGRectContainsPoint(targetRect, touchPoint)) {
                _activePoint = value;
                _moveAction = DPVMoveActionDragPoint;
                found = YES;
                NSLog(@"set active point to %.lf, %.lf",point.x,point.y);
                break;
            }
        }
        if (found) {
            NSLog(@"set active polygon");
            _activePolygon = polygon;
            break;
        }
    }
    
    if (_moveAction == DPVMoveActionUnknwon && self.allowDragPolygon) {
        for (DPVPolygon* polygon in self.polygons) {
            BOOL isIn = [polygon isPointInside:touchPoint];
            if (isIn) {
                NSLog(@"set move polygon");
                _activePolygon = polygon;
                _moveAction = polygon.editable ? DPVMoveActionDragPolygon : DPVMoveActionSelectPolygon;
                break;
            }
        }
    }
    
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.allowEdit) {
        [super touchesMoved:touches withEvent:event];
        return ;
    }
    
    UITouch* touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (_moveAction == DPVMoveActionDragPoint && _activePolygon != nil && _activePoint != nil) {
        
        //判断是否越出view自身范围
        if (touchPoint.x < self.bounds.size.width && touchPoint.x > 0 &&
            touchPoint.y < self.bounds.size.height && touchPoint.y > 0) {
            //更新值
            _activePoint.x = touchPoint.x;
            _activePoint.y = touchPoint.y;
        }
        
        //排序
        if(self.rectangleOnly) {
            [self adjustRectanglePoints:_activePolygon.points refPoint:_activePoint];
        }
        
        //绘制界面
        [self setNeedsDisplay];
    }
    
    if (_moveAction == DPVMoveActionDragPolygon && _activePolygon != nil) {
        CGPoint previousPoint = [touch previousLocationInView:self];
        CGFloat dx = touchPoint.x - previousPoint.x;
        CGFloat dy = touchPoint.y - previousPoint.y;
        NSLog(@"dx,dy = %.2lf, %.2lf",dx,dy);
        BOOL shouldUpdateValue = YES;
        //旧：不改变多边形的形状，碰到边界就停止
//        if (!self.allowBeyondBorder) {
//            shouldUpdateValue = [self checkPolygon:_activePolygon willMoveCrossBorderWithOffset:CGPointMake(dx, dy)];
//        }
        if (shouldUpdateValue) {
            for (DPVPoint* point in _activePolygon.points) {
                point.x += dx;
                point.y += dy;
                //新：碰到边界后“挤压”改边多边形的形状
                if (!self.allowBeyondBorder) {
                    if (point.x < 0) {
                        point.x = 0;
                    }
                    if (point.x > self.bounds.size.width) {
                        point.x = self.bounds.size.width;
                    }
                    if (point.y < 0) {
                        point.y = 0;
                    }
                    if (point.y > self.bounds.size.height) {
                        point.y = self.bounds.size.height;
                    }
                }
            }
            [self setNeedsDisplay];
        }
    }
    
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.allowEdit) {
        [super touchesEnded:touches withEvent:event];
        return ;
    }
    
    NSLog(@"move action = %d",_moveAction);
    if(_moveAction == DPVMoveActionSelectPolygon && _activePolygon != nil) {
        for (DPVPolygon* polygon in _polygons) {
            polygon.editable = NO;
        }
        NSLog(@"trigger select polygon: %@",_activePolygon);
        _activePolygon.editable = YES;
        [self setNeedsDisplay];
    }
    
    _activePoint = nil;
    _activePolygon = nil;
    _moveAction = DPVMoveActionUnknwon;
    
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - logic

/**
 将多边形认为是一个矩形，调整里边点的坐标使得其是一个矩形

 @param polygon 多边形顶点
 */
-(void)adjustRectanglePoints:(NSMutableArray*)polygon refPoint:(DPVPoint*)activePoint {
    if ([polygon count] != 4) {
        NSLog(@"no adjust for polygon that have %lu points...",(unsigned long)[polygon count]);
        return ;
    }
    NSInteger idx = -1;
    for (NSInteger i = 0; i < polygon.count; i++) {
        DPVPoint* vp = [polygon objectAtIndex:i];
        if (fabs(vp.x-activePoint.x) < 0.1 && fabs(vp.y-activePoint.y) < 0.1) {
            idx = i;
            break;
        }
    }
    if (idx < 0) {
        NSLog(@"no adjust for active point not in polygon");
        return ;
    }
    //这里思路是，默认的polygon中顶点顺序为左上角为第一个点，顺时针排列
    //根据activePoint所在的位置，调整相对的点的坐标
    if (idx == 0) {
        DPVPoint* p1 = [polygon objectAtIndex:3];
        p1.x = activePoint.x;
        DPVPoint* p2 = [polygon objectAtIndex:1];
        p2.y = activePoint.y;
    }
    if (idx == 1) {
        DPVPoint* p1 = [polygon objectAtIndex:2];
        p1.x = activePoint.x;
        DPVPoint* p2 = [polygon objectAtIndex:0];
        p2.y = activePoint.y;
    }
    if (idx == 2) {
        DPVPoint* p1 = [polygon objectAtIndex:1];
        p1.x = activePoint.x;
        DPVPoint* p2 = [polygon objectAtIndex:3];
        p2.y = activePoint.y;
    }
    if (idx == 3) {
        DPVPoint* p1 = [polygon objectAtIndex:0];
        p1.x = activePoint.x;
        DPVPoint* p2 = [polygon objectAtIndex:2];
        p2.y = activePoint.y;
    }
}

-(BOOL)checkPolygon:(DPVPolygon*)polygon willMoveCrossBorderWithOffset:(CGPoint)offset {
    BOOL rtn = YES;
    CGRect border = self.bounds;
    for (DPVPoint* point in polygon.points) {
        CGPoint p = [point CGPointValue];
        p.x += offset.x;
        p.y += offset.y;
        if (!CGRectContainsPoint(border, p)) {
            rtn = NO;
            break;
        }
    }
    return rtn;
}

@end
