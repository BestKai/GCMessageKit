//
//  MKMapView+Zoomlevel.h
//  GCMessageKitDemo
//
//  Created by BestKai on 16/6/20.
//  Copyright © 2016年 BestKai. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (Zoomlevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
