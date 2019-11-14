//
//  MarsCoordinateHelper.h
//  LocationDemo
//
//  Created by Anker on 2018/11/23.
//  Copyright © 2018 Anker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarsCoordinateHelper : NSObject

+ (CLLocation *)transformToMars:(CLLocation *)location;

/**
 *  @brief  世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  ####只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
 *
 *  @param  location    世界标准地理坐标(WGS-84)
 *
 *  @return 中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)location;


/**
 *  @brief  中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *  @param  location    中国国测局地理坐标（GCJ-02）
 *
 *  @return 世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)location;
@end

NS_ASSUME_NONNULL_END
