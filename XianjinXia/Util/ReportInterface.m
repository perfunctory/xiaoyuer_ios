//
//  ReportInterfaceDelegate.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "ReportInterface.h"
#import "UtilRequest.h"
#import "UserManager.h"
#import <AdSupport/AdSupport.h>
#import "DSUtils.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "VerifyListRequest.h"
#import "GetContactsBook.h"

@interface ReportInterface ()

@property (nonatomic, strong) UtilRequest * request;

@end

@implementation ReportInterface

static ReportInterface * _shareReportReport = nil;
+ (ReportInterface *)shareMasterReport {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (!_shareReportReport) {
            _shareReportReport = [[self alloc] init];
        }
    });
    return _shareReportReport;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)responceContent:(BOOL)status {
    NSString * uid = @"";
    NSString * userName = @"";
    NSString * deviceID = @"";
    NSString * netType = @"";
    NSString * installTime = @"";
    NSString * appmarket = @"AppStore";
    NSString * adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([UserManager sharedUserManager].userInfo.uid != 0) {
        uid = [UserManager sharedUserManager].userInfo.uid;
    }
    if ([UserManager sharedUserManager].userInfo.username != 0) {
        userName = [UserManager sharedUserManager].userInfo.username;
    }
    deviceID = [DSUtils getUUIDString];
    netType = [self getNetworkType];
    
    if (status) {
        NSDate * today = [NSDate date];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
        installTime = [formatter stringFromDate:today];
    }
//    [KDReport getAppsInfo];
    NSDictionary * parm = [NSDictionary dictionaryWithObjectsAndKeys:adId,@"IdentifierId",appmarket,@"appMarket",deviceID, @"device_id", installTime, @"installed_time",uid,@"uid",userName,@"username",netType,@"net_type", nil];
    [self.request appDeviceReportWithDict:parm onSuccess:^(NSDictionary *dictResult) {
        NSLog(@"上报信息成功");
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        NSLog(@"requestFailed %@",errorMsg);
        NSLog(@"上报信息失败");
    }];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"repayDate"];
        [self.request logoutWithDict:nil onSuccess:^(NSDictionary *dictResult) {
        } andFailed:^(NSInteger code, NSString *errorMsg) {
        }];
    }else{
        NSLog(@"不是第一次启动");
    }
}

- (void)upLoadAddressBook {
    [[GetContactsBook shareControl] upLoadAddressBook];
}

//获取网络状态
- (NSString *)getNetworkType{
    
    NSString *type = @"";
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
        //2g,3g
        type = @"2g,3g,4g";
    }
    else if (status == AFNetworkReachabilityStatusReachableViaWiFi)
    {
        //wifi
        type = @"wifi";
    }
    return type;
}

- (UtilRequest *)request {
    if (!_request) {
        _request = [[UtilRequest alloc] init];
    }
    return _request;
}

@end
