//
//  GDLocationManager.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

//高德地图appkey
#if DEBUG

static NSString * APIKey = @"e9935bc1e7923ba44b74ff40cf28ad58";

#else

static NSString * APIKey = @"e9935bc1e7923ba44b74ff40cf28ad58";

#endif

typedef void(^locationSucceedBlock)(AMapLocationReGeocode *regeoCode,NSString *errorStr);
typedef void(^locationSucceedUploadBlock)(AMapLocationReGeocode *regeoCode,NSString *errorStr,CLLocation *location);

@interface GDLocationManager : NSObject

+ (instancetype) shareInstance;
/**
 *  注册高的地图
 *
 */
+ (void)registerGD;
//开始定位
- (void) startLocation;
//判断是否开启定位
- (BOOL)isOpenLocationServices;
/**
 *  定位成功回调block
 */
@property (nonatomic, copy) locationSucceedBlock locationSuccessBlock;
/**
 *  上报block
 */
@property (nonatomic, copy) locationSucceedUploadBlock locationUploadBlock;

@end
