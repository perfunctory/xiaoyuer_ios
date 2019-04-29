	//
//  AppDelegate.h
//  XianjinXia
//
//  Created by lxw on 17/1/18.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用
#import <PushKit/PushKit.h> //VOIP支持需要导入PushKit库,实现 PKPushRegistryDelegate

// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

/// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
#if DEBUG

#define kGtAppId           @"V3WWs5EPKg5U6CEszGV4l7"
#define kGtAppKey          @"FO43vTXwYJ6c7g0gCBNWP2"
#define kGtAppSecret       @"s0sRYSrxCO7DNFAgA0ldM2"

#else

#define kGtAppId           @"fl1rYbQLhr8AIB7PXXYvE2"
#define kGtAppKey          @"c2w4kVqU9D7JXYtv2lJ61"
#define kGtAppSecret       @"Z5thA1RSVF9KE2WvZrUfG8"

#endif

/// 使用个推回调时，需要添加"GeTuiSdkDelegate"
/// iOS 10 及以上环境，需要添加 UNUserNotificationCenterDelegate 协议，才能使用 UserNotifications.framework 的回调
@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate, PKPushRegistryDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

