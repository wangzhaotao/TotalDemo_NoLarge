//
//  WTMapLocationVC.m
//  TotalDemo
//
//  Created by tyler on 9/24/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTMapLocationVC.h"
#import <MapKit/MapKit.h>
#import "DYMapAnnotation.h"
#import "MarsCoordinateHelper.h"

@interface WTMapLocationVC ()<MKMapViewDelegate, CLLocationManagerDelegate> {
    DYMapAnnotation* _currentAnnotation;
    BOOL _isLocating;
}
@property (nonatomic, assign) BOOL isInit;
@property (nonatomic, assign) BOOL isTapMap;

@property (strong, nonatomic)  MKMapView *mkMapview;
@property (strong, nonatomic)  UIImageView *currentLocationImgV;

@property (nonatomic, assign) CLLocationDistance curRadius;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic,assign,readwrite) CLLocationCoordinate2D lastCoord;
@property (nonatomic,strong) CLLocation* lastLocation; //记录了位置确定的时间点
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation WTMapLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.isInit = YES;
    
    [self initView];
    [self loadData];
    [self checkAuthorized];
}

#pragma mark public methods
- (CLLocationCoordinate2D)getCurrentSelectCoordinate{
    return [MarsCoordinateHelper gcj02ToWgs84:_currentAnnotation.coordinate];
}


#pragma mark private method
-(void) initView {
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    MKMapView *mkMapview = [[MKMapView alloc] init];
    mkMapview.delegate = self;
    mkMapview.showsScale = YES;
    mkMapview.showsCompass = YES;
    mkMapview.showsUserLocation = YES;
    mkMapview.zoomEnabled = YES;
    _mkMapview = mkMapview;
    
    UIImageView *currentLocationImgV = [[UIImageView alloc] init];
    currentLocationImgV.image = [UIImage imageNamed:@"geo_map_coordinate_icon"];
    _currentLocationImgV = currentLocationImgV;
    
    [self.view addSubview:mkMapview];
    [self.view addSubview:currentLocationImgV];
    
    [currentLocationImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(mkMapview).offset(dp2po(-15));
        make.bottom.mas_equalTo(mkMapview).offset(dp2po(-15));
    }];
    [mkMapview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);
    }];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //手势事件
    //mapview gesture
    UITapGestureRecognizer *mTapMapview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMapview:)];
    [self.mkMapview addGestureRecognizer:mTapMapview];
    //location gesture
    currentLocationImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *mTapLocation = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLocation:)];
    [currentLocationImgV addGestureRecognizer:mTapLocation];
}
-(void) loadData{
    
    [self updateRadius:0 withUpdateMap:NO];
}

-(void) checkAuthorized{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status != kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager requestAlwaysAuthorization];
    }
    if(status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        NSLog(@"GEO:Location Authorize is not allow...");
    }else{
        NSLog(@"GEO:Location Authorzie is done");
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        [self.locationManager startUpdatingLocation];
        if(self.isInit){
            NSLog(@"定位加载中...");
            [self startTimer];
        }
    }
}
-(void) startTimer{
    _isLocating = YES;
    __weak typeof(self) weak_self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([weak_self isLocating]){
            [weak_self stopTimer];
            NSLog(@"获取定位错误...");
        }
    });
}
-(void) stopTimer{
    _isLocating = NO;
    NSLog(@"加载结束...");
}
-(BOOL)isLocating{
    return _isLocating;
}

#pragma mark 手势
- (void)tapLocation:(UITapGestureRecognizer *)sender {
    NSLog(@"GEO:tap location");
    [self.mkMapview setCenterCoordinate:self.mkMapview.userLocation.coordinate animated:YES];
}
- (void)tapMapview:(UIGestureRecognizer*)gestureRecognizer {
    NSLog(@"GEO:tap mapview");
    self.isTapMap = YES;
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mkMapview];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mkMapview convertPoint:touchPoint toCoordinateFromView:self.mkMapview];//这里touchMapCoordinate就是该点的经纬度了
    
    CLLocationCoordinate2D newTouchMapCd = [MarsCoordinateHelper gcj02ToWgs84:touchMapCoordinate];
    [self addRegionAndAddress:newTouchMapCd];
    [self.mkMapview setCenterCoordinate:touchMapCoordinate animated:YES];
    
    NSLog(@"世界标准经纬度: latitude=%f, longitude=%f", touchMapCoordinate.latitude, touchMapCoordinate.longitude);
    NSLog(@"火星经纬度: latitude=%f, longitude=%f", newTouchMapCd.latitude, newTouchMapCd.longitude);
}

#pragma mark
-(void) updateRadius:(NSInteger) index withUpdateMap:(BOOL) isUpdate{

    self.curRadius = 150;
    if(isUpdate){
        [self addRegionAndAnnotation:[MarsCoordinateHelper gcj02ToWgs84:_currentAnnotation.coordinate] withRadius:self.curRadius];
    }
}

/**
 将一个Region和图标绘制在地图上
 @param coord 接收WGS-84坐标系为中心，内部会转化为GCJ-02坐标系
 */
-(void) addRegionAndAnnotation:(CLLocationCoordinate2D)coord withRadius:(CLLocationDistance) radius{
    CLLocationDistance distance = radius;
    CLRegion* region = [[CLCircularRegion alloc] initWithCenter:coord radius:distance identifier:[NSString stringWithFormat:@"ManualSet_%f",distance]];
    if(_currentAnnotation!=nil){
        [self removeRegionAndAnnotation];
    }
    _currentAnnotation = [self markPositionOnMap:coord];
    [self drawRegionOnMap:region associateAnnotation:_currentAnnotation];
}
- (void)addRegionAndAnnotation:(CLLocationCoordinate2D)coord{
    [self addRegionAndAnnotation:coord withRadius:_curRadius];
}
-(void)removeRegionAndAnnotation{
    if(_currentAnnotation!=nil){
        [self.mkMapview removeOverlay:_currentAnnotation.associateOverlay];
        [self.mkMapview removeAnnotation:_currentAnnotation];
        _currentAnnotation = nil;
    }
    
}

/**
 将一个点标记在地图上
 
 @param coord 接收WGS-84坐标系为中心，内部会转化为GCJ-02坐标系
 */
-(DYMapAnnotation*)markPositionOnMap:(CLLocationCoordinate2D)coord {
    DYMapAnnotation* dma = [[DYMapAnnotation alloc] init];
    CLLocation* oldL = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    CLLocation* newL = [MarsCoordinateHelper transformToMars:oldL];
    dma.coordinate = newL.coordinate;
    [self.mkMapview addAnnotation:dma];
    return dma;
}
/**
 将一个Region绘制在地图上
 
 @param region 只能处理CLCircularRegion类型；接收WGS-84坐标系为中心，内部会转化为GCJ-02坐标系
 */
-(void)drawRegionOnMap:(CLRegion*)region associateAnnotation:(DYMapAnnotation*)annotation {
    if ([region isKindOfClass:[CLCircularRegion class]]) {
        CLCircularRegion* ccr = (CLCircularRegion*)region;
        CLLocation* oldL = [[CLLocation alloc] initWithLatitude:ccr.center.latitude longitude:ccr.center.longitude];
        CLLocation* newL = [MarsCoordinateHelper transformToMars:oldL];
        ccr = [[CLCircularRegion alloc] initWithCenter:newL.coordinate radius:ccr.radius identifier:ccr.identifier];
        MKCircle* circle = [MKCircle circleWithCenterCoordinate:ccr.center radius:ccr.radius];
        [self.mkMapview addOverlay:circle];
        annotation.associateOverlay = circle;
    }
}

-(void)onGetReliableCurrentLocation {
    NSLog(@"GEO:update current location");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopTimer];
        [self centerMapViewWithPoint:self.lastCoord];
        [self addRegionAndAddress:self.lastCoord];
    });
}

/**
 将地图的展示区域设置到以指定点为中心处
 
 @param coord 接收以WGS-84坐标系定义的点，内部会转化成GCJ-02坐标系
 */
-(void)centerMapViewWithPoint:(CLLocationCoordinate2D)coord {
    CLLocation* oldL = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    CLLocation* newL = [MarsCoordinateHelper transformToMars:oldL];
    MKCoordinateRegion cr = MKCoordinateRegionMake(newL.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mkMapview setRegion:cr animated:NO];
}
- (void) addRegionAndAddress:(CLLocationCoordinate2D)coord{
    [self addRegionAndAnnotation:coord];
    [self getAddressByLatitude:coord];
}
/**
 根据经纬度获取地名
 */
-(void)getAddressByLatitude:(CLLocationCoordinate2D) coordinate{
    //反地理编码
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
    NSString *locationStr = [NSString stringWithFormat:@"%lf,%lf",coordinate.latitude,coordinate.longitude];
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            runOnMain(^{
                                if(error){
                                    NSLog(@"根据经纬度获取地名--错误:%@", locationStr);
                                }else{
                                    CLPlacemark *placemark = [placemarks firstObject];
                                    NSLog(@"根据经纬度获取地名: %@", placemark);
                                }
                            });
                        }];
}


#pragma mark - map delegate
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer* cr = [[MKCircleRenderer alloc] initWithCircle:overlay];
        cr.fillColor = iColor(0x2c, 0x7a, 0xfc, 0.1);
        cr.strokeColor = iGlobalFocusColor;
        cr.lineWidth = dp2po(1);
        return cr;
    }else{
        return [[MKOverlayRenderer alloc] initWithOverlay:overlay];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *identifier = @"annotation";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        //V2:把标注对象的image值赋值给标注视图的image属性
        annotationView.image = [UIImage imageNamed:@"geo_map_position_icon"];
        annotationView.centerOffset = CGPointMake(0, -15);
        
    } else {
        annotationView.annotation = annotation;
    }
    return annotationView;
}

#pragma mark - location delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation* ll = [locations lastObject];
    self.lastCoord = [ll coordinate];
    self.lastLocation = [ll copy];
    if (!CLLocationCoordinate2DIsValid(ll.coordinate)) {
        //对于明显不合理的点，丢弃
        return ;
    }
    NSLog( @"GEO:pending location: %@",ll);
    [self.locationManager stopUpdatingLocation];
    if(self.isInit){
        [self onGetReliableCurrentLocation];
    }
}

@end
