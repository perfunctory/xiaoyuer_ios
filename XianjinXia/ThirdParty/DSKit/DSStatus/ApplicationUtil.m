//
//  ApplicationUtil.m
//  Demo
//
//  Created by FengDongsheng on 12/6/8.
//  Copyright (c) 2012年 FengDongsheng. All rights reserved.
//

#import "ApplicationUtil.h"
#import <CoreLocation/CoreLocation.h>

#import "BaseRequest.h"

@interface ApplicationUtil()

@property (strong, nonatomic) UIWebView *mainWebView;
@property (strong, nonatomic, readwrite) NSDateFormatter *dateFormatter;

@end

@implementation ApplicationUtil

+ (instancetype)sharedApplicationUtil{
    static ApplicationUtil *sharedApplicationUtil = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedApplicationUtil = [[ApplicationUtil alloc] init];
    });
    return sharedApplicationUtil;
}


//拨打电话
- (void)makeTelephoneCall:(NSString *)telNumber{
    static const NSInteger telTag = 19009527;
    NSString *str = [NSString stringWithFormat:@"tel:%@",telNumber];
    if (!_mainWebView) {
        _mainWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _mainWebView.tag = telTag;
    }
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    UIView *tempView = [SharedApplication.keyWindow viewWithTag:telTag];
    if (tempView) {
        [tempView removeFromSuperview];
    }
    [SharedApplication.keyWindow addSubview:self.mainWebView];
}

//注册push通知
- (void)registerNotification{
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeSound
                                                        | UIUserNotificationTypeAlert
                                                        | UIUserNotificationTypeBadge
                                                                                         categories:nil];
    [SharedApplication registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] currentUserNotificationSettings];
}

//是否开启了定位服务
- (BOOL)bIsOpenLocationService{
    BOOL bOpenLocation;
    CLAuthorizationStatus status=[CLLocationManager authorizationStatus];
    if (![CLLocationManager locationServicesEnabled]    ||
        status == kCLAuthorizationStatusRestricted  ||
        status == kCLAuthorizationStatusDenied
        ){
        bOpenLocation=NO;
    }else{
        bOpenLocation=YES;
    }
    return bOpenLocation;
}

/**
 *  跳转到系统设置页面，iOS8之后可用
 */
- (void)gotoSettings{
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
    }
}

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

- (void)checkVersionIsTheLatest:(void(^)(NSInteger updateType, NSString *updateContent, NSString *updateUrl))completeBlock {
    
    [[[BaseRequest alloc] init] doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kCheckVersion] andMetohd:kHttpRequestGet andParameters:nil andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200 && 0 == [responseObject[@"code"] intValue]) {
            !completeBlock ? : completeBlock([responseObject[@"data"][@"item"][@"whether_need_upgrade"] integerValue], responseObject[@"data"][@"item"][@"update_context"], responseObject[@"data"][@"item"][@"update_url"]);
            
//            !completeBlock ? : completeBlock([responseObject[@"data"][@"item"][@"whether_need_upgrade"] integerValue], responseObject[@"data"][@"item"][@"update_context"], @"");
        }
    } andFailHandler:^(NSError *e,NSInteger statusCode,NSString *errorMsg){ }];
}
@end
