//
//  GCDisplayLocationViewController.m
//  baymax_marketing_iOS
//
//  Created by BestKai on 16/1/13.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "GCDisplayLocationViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface GCDisplayLocationViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    AMapReGeocodeSearchResponse *locationResult;//逆地理编码结果
    
    MAPointAnnotation *annotationaa;
}
@property (strong, nonatomic) MAMapView *BMapView;
@property (nonatomic, strong) AMapSearchAPI *MapSearch;

@end

@implementation GCDisplayLocationViewController

- (AMapSearchAPI *)MapSearch
{
    if (!_MapSearch) {
        _MapSearch = [[AMapSearchAPI alloc] init];
        _MapSearch.delegate = self;
    }
    return _MapSearch;
}


- (MAMapView *)BMapView
{
    if (!_BMapView) {
        
        _BMapView = [[MAMapView alloc] initWithFrame:self.view.frame];
        _BMapView.zoomLevel = 13.5;
        _BMapView.delegate = self;
        _BMapView.showsCompass = NO;
        if (_needLocation) {
            
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
                //定位功能不可用，
                UIAlertView *alert = [[UIAlertView alloc]init];
                [alert setTitle:@"提示"];
                [alert setMessage:@"设备未打开定位，请在'设置'中为应用打开定位服务"];
                [alert addButtonWithTitle:@"好的"];
                [alert show];
                
            }else {
                
                _BMapView.userTrackingMode = MAUserTrackingModeFollow;
                _BMapView.showsUserLocation = YES;
            }
        }else if (_address){
            
            AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
            geo.address = _address;
            [self.MapSearch AMapGeocodeSearch:geo];
        }
    }
    return _BMapView;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        _currentCoordinate2D = userLocation.location.coordinate;

        [_BMapView setCenterCoordinate:_currentCoordinate2D animated:YES];
        
        annotationaa.coordinate = _currentCoordinate2D;
        
        AMapReGeocodeSearchRequest *reverseGeoCodeOption = [[AMapReGeocodeSearchRequest alloc] init];
        
        reverseGeoCodeOption.location = [AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];;
        [self.MapSearch AMapReGoecodeSearch:reverseGeoCodeOption];
    }
}

#pragma mark [----  BMKGeoCodeSearchDelegate
//地理编码回调
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"定位失败"];
        return;
    }
    
    annotationaa = [[MAPointAnnotation alloc] init];
    annotationaa.title = request.address;
    AMapGeocode *geoCode = response.geocodes[0];
    annotationaa.coordinate = CLLocationCoordinate2DMake(geoCode.location.latitude, geoCode.location.longitude);
    
    [self.BMapView setCenterCoordinate:annotationaa.coordinate animated:YES];
    [self.BMapView addAnnotation:annotationaa];
}

// 逆地理编码回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode !=nil) {
        
        locationResult = response;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (void)loadLocations {
    
    if (_address) {
        annotationaa.title = _address;
    }
    
    annotationaa = [[MAPointAnnotation alloc] init];
    [_BMapView addAnnotation:annotationaa];
    annotationaa.coordinate = _currentCoordinate2D;
    [_BMapView setCenterCoordinate:_currentCoordinate2D animated:YES];
}
#pragma mark - Life cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.needLocation && !_address) {
        [self loadLocations];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _BMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.MapSearch.delegate = self;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _BMapView.delegate = nil;
    self.MapSearch.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"地理位置";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.BMapView];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backImage"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    if (self.needLocation) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendLocation)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)sendLocation
{
    if (self.DidGetGeolocationsCompledBlock) {
        self.DidGetGeolocationsCompledBlock(locationResult.regeocode.formattedAddress,[[CLLocation alloc] initWithLatitude:_currentCoordinate2D.latitude longitude:_currentCoordinate2D.longitude]);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
