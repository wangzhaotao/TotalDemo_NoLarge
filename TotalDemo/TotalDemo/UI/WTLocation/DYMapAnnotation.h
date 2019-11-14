//
//  DYMapAnnotation.h
//  TotalDemo
//
//  Created by tyler on 9/24/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import MapKit;

@interface DYMapAnnotation : NSObject<MKAnnotation> {
    
}
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,weak) CLRegion* associateRegion;
@property (nonatomic,weak) id<MKOverlay> associateOverlay;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@end

