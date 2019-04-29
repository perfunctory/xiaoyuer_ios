//
//  GDLocationManager.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GDLocationManager.h"
#import <MapKit/MapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundation/AMapFoundationKit/AMapServices.h>
//#import <MAMapKit/MAMapServices.h>
#import <MAMapKit/MAMapKit.h>
#import "UtilRequest.h"

#define LocationTimeout 3  //   定位超时时间，可修改，最小2s
#define ReGeocodeTimeout 3 //   逆地理请求超时时间，可修改，最小2s

@interface GDLocationManager ()<AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager           * locationManager;
@property (nonatomic, copy)   AMapLocatingCompletionBlock     completionBlock;
@property (nonatomic, strong) UtilRequest                   * locationULoadRequest;

@end

@implementation GDLocationManager

+ (instancetype)shareInstance
{
    static dispatch_once_t predicate;
    static GDLocationManager *manager = nil;
    dispatch_once(&predicate, ^{
        manager = [[GDLocationManager alloc]init];
        manager.locationUploadBlock = ^(AMapLocationReGeocode *regeocode,NSString *error,CLLocation *location){
            if ([error isEqualToString:@""]||!error) {
                [manager upLoadLocationWith:regeocode andLocation:location];
            }
        };
    });
    return manager;
}

//注册高德地图服务
+ (void)registerGD
{
//    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
//    [AMapLocationServices sharedServices].apiKey = APIKey;
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
    
    
    
}
//开始定位
- (void)startLocation
{
    [self configLocationManager];
    [self initCompleteBlock];
    [self reGeocodeAction];
    
}

- (BOOL)isOpenLocationServices
{
    //kCLAuthorizationStatusNotDetermined                  //用户尚未对该应用程序作出选择
    //kCLAuthorizationStatusRestricted                     //应用程序的定位权限被限制
    //kCLAuthorizationStatusAuthorizedAlways               //一直允许获取定位
    //kCLAuthorizationStatusAuthorizedWhenInUse            //在使用时允许获取定位
    //kCLAuthorizationStatusAuthorized                     //已废弃，相当于一直允许获取定位
    //kCLAuthorizationStatusDenied                         //拒绝获取定位
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        //定位功能可用
        return YES;
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        return NO;
    }
    return NO;
}

- (void)reGeocodeAction
{
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}
/**
 *  配置高德定位manager
 */
- (void)configLocationManager
{
    if (!self.locationManager) {
        self.locationManager = [[AMapLocationManager alloc] init];
    }
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    [self.locationManager setLocationTimeout:LocationTimeout];
    
    [self.locationManager setReGeocodeTimeout:ReGeocodeTimeout];
    
}

- (void)initCompleteBlock
{
    __weak GDLocationManager *weakself = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        NSString *errorStr = @"";
        AMapLocationReGeocode *code = [[AMapLocationReGeocode alloc]init];
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                errorStr = @"定位服务未开启，请进入系统［设置］》［隐私］》［定位服务］中打开开关，并允许信合宝使用定位服务";
            }else
            {
                errorStr = @"定位失败，请检查网络情况";
            }
        }
        if (regeocode) {
            code = regeocode;
        }
        if (weakself.locationSuccessBlock) {
            weakself.locationSuccessBlock(code,errorStr);
        }
        if (weakself.locationUploadBlock) {
            weakself.locationUploadBlock(code,errorStr,location);
        }
        
    };
}
- (UtilRequest *)locationULoadRequest
{
    if (!_locationULoadRequest) {
        _locationULoadRequest = [[UtilRequest alloc] init];
    }
    return _locationULoadRequest;
}

#pragma mark -
- (void)upLoadLocationWith:(AMapLocationReGeocode *)code andLocation:(CLLocation *)location
{
    [self getLocalAddressWith:location];
    
}

- (void)getLocalAddressWith:(CLLocation *)location {
    __block  NSString * str = @"";
    CLLocation * clocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    CLGeocoder * revGeo = [[CLGeocoder alloc] init];
    [revGeo reverseGeocodeLocation:clocation completionHandler:^(NSArray * placemarks, NSError * error) {
        if (!error && [placemarks count] > 0) {
            NSDictionary * dict = [[placemarks objectAtIndex:0] addressDictionary];
            str = [NSString stringWithFormat:@"%@-%@-%@",dict[@"City"],dict[@"Street"],dict[@"Name"]];
        }else {
            str = @"";
        }
        NSDictionary * param = @{@"longitude":[NSNumber numberWithDouble:location.coordinate.longitude],@"latitude":[NSNumber numberWithDouble:location.coordinate.latitude],@"address":str ? str : @"",@"time":[self getCurrentTime]};
        [self.locationULoadRequest uploadLocationWithDict:param onSuccess:^(NSDictionary *dictResult) {
        } andFailed:^(NSInteger code, NSString * errorMsg) {
        }];
    }];
}

- (NSString *)getCurrentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}


@end
