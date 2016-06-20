//
//  GCDisplayLocationViewController.h
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/13.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCMessage.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface GCDisplayLocationViewController : UIViewController


@property (assign, nonatomic) BOOL needLocation;

@property (strong, nonatomic) void(^DidGetGeolocationsCompledBlock)(NSString *result,CLLocation *location);

@property (nonatomic, copy) NSString *address;//地址
@property (assign,nonatomic) CLLocationCoordinate2D  currentCoordinate2D;// 经纬度

@end
