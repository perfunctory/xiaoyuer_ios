//
//  ReportInterfaceDelegate.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReportInterfaceDelegate <NSObject>

@optional

- (void)reportSuccess:(NSInteger) uid;
- (void)reportFailed:(NSError *) error;

@end

//
//typedef enum {
//    INSTANT = 1,            //实时上报
//    BATCH = 2,              //批量上报，达到缓存临界值时触发发送
//
//    APP_LAUNCH = 3,         //应用启动时发送，仅实现应用启动的时候
//
//    ONLY_WIFI = 4,          //仅在WIFI网络下发送
//    PERIOD = 5,             //每间隔一定最小时间发送，默认24小时
//    DEVELOPER = 6,         //开发者在代码中主动调用发送行为
//    ONLY_WIFI_NO_CACHE = 7  //仅在WIFI网络下发送, 发送失败以及非WIFI网络情况下不缓存数据
//} StatReportStrategy;

@interface ReportInterface : NSObject

@property (weak, nonatomic) id<ReportInterfaceDelegate> delegate;

+ (ReportInterface *) shareMasterReport;

- (void)responceContent:(BOOL)status;

- (void)upLoadAddressBook;


@end
