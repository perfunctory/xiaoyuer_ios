//
//  AppDelegate.m
//  XianjinXia
//
//  Created by lxw on 17/1/18.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarVC.h"
#import "ReportInterface.h"
#import "GDLocationManager.h"
#import "NewFeatureVC.h"
#import "QQShareManager.h"
#import "WXShareManager.h"
#import "KDShareHeader.h"
#import "LoactionUpdate.h"
#import <MGLivenessDetection/MGLivenessDetection.h>
#import "DSNetWorkStatus.h"
#import "GetContactsBook.h"

#import "UserManager.h"
#import "KDAlertView.h"

#import  <Bugly/Bugly.h>
#import "UMMobClick/MobClick.h"

#import "FMDeviceManager.h" //同盾设备指纹
#import "SetServerVC.h"
#import "CommonWebVC.h"
#import "UIView+Tool.h"

//#import "QMProfileManager.h"
//#import <QMChatSDK/QMChatSDK.h>
//#import <QMChatSDK/QMChatSDK-Swift.h>
//#import "QMManager.h"
#import "QYSDK.h"
@interface AppDelegate ()

@end



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        [UserDefaults setObject:@"1" forKey:@"Setp"];
    //监听网络状态
    [DSNetWorkStatus sharedNetWorkStatus];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    
    // nabigationBar阴影
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    // navigationBar是否半透明模糊处理，此项设置将影响有navigationBar的ViewController的布局
    [UINavigationBar appearance].translucent = NO;
    // 背景颜色
    [UINavigationBar appearance].barTintColor = Color_Red;
    // 导航栏中间标题样式
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          Font_Navigationbar_Title, NSFontAttributeName, nil]];
    //本地保存的上一次进入APP时候的版本
    NSString *saveVersion = [UserDefaults objectForKey:@"version"];
    if (![CurrentAppVersion isEqualToString:saveVersion]) { // 如果是第一次进入新版本,进入介绍页面
        [UserDefaults setObject:CurrentAppVersion forKey:@"version"];
        NewFeatureVC * vcNew = [[NewFeatureVC alloc] init];
        __unsafe_unretained AppDelegate *app = self;
        vcNew.start = ^() {
            [app gotoTabbarController];
        };
        self.window.rootViewController = vcNew;
    } else { // 否则，直接进入TabbarController
        [self gotoTabbarController];
    }
    
    //七陌
    [self registerUserNotification];
    
    //个推
    [self startGeTui];
    /**
     创建文件管理类
     name: 可随便填写
     password: 可随便填写
     */
//    QMProfileManager *manger = [QMProfileManager sharedInstance];
//    [manger loadProfile:@"moor" password:@"123456"];
    
    //使用bugly
    [self useBugly];
    
    //启动友盟
    [self configUmeng];

    //七鱼
    [[QYSDK sharedSDK] registerAppId:@"e80294cd56aa856fe235ba063a74ebb6" appName:@"信合宝"];
    
    //开启高德
    [GDLocationManager registerGD];
    [[GDLocationManager shareInstance] startLocation];
    
    //子线程中
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [[ReportInterface shareMasterReport] responceContent:YES];
        [[ReportInterface shareMasterReport] upLoadAddressBook];
        //
        [WXShareManager resigterWXApp:wxAppid];
        
        //注册face++
        [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
            NSLog(@"Face++  SDK 授权【%@】", License ? @"成功" : @"失败");
        }];
        
    });
    
//    [self checkUpdate];
    
    //同盾
    [self starTongDunService];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)registerUserNotification {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
}

#pragma mark -检查更新-
-(void) checkUpdate {
    [[ApplicationUtil sharedApplicationUtil] checkVersionIsTheLatest:^(NSInteger updateType, NSString *updateContent, NSString *updateUrl) {
        //检查当前版本是否需要更新 0 是最新 1 需要选择更新 2 需要强制更新
        if(2 == updateType){
            @Weak(self);
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"发现新版本" message:updateContent preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *updateAct = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if([wself stringIsNilOrEmpty:updateUrl]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrl]];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                }
            }];
            [alertC addAction:updateAct];
            [wself.window.rootViewController presentViewController:alertC animated:YES completion:^{
                
            }];
        }
    }];
}

- (BOOL)stringIsNilOrEmpty:(NSString*)aString {
    if (!aString)
        return YES;
    return [aString isEqualToString:@""];
}

#pragma mark -初始化同盾设备指纹-
-(void)starTongDunService{

    //获取设备管理实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    //准备SDK初始化参数
    NSMutableDictionary * options = [NSMutableDictionary dictionary];
    
    #if DEBUG
    /*
     * SDK具有防调试功能，当使用xcode运行时(开发测试阶段),请取消下面代码注释，
     * 开启调试模式,否则使用xcode运行会闪退。上架打包的时候需要删除或者注释掉这
     * 行代码,如果检测到调试行为就会触发crash,起到对APP的保护作用
     */
    // 上线Appstore的版本，请记得删除此行，否则将失去防调试防护功能！
    [options setValue:@"allowd" forKey:@"allowd"];  // TODO
    #endif
    
    // 此处替换为您的合作方标识
    [options setValue:@"jiexiang" forKey:@"partner"];
    
    // 使用上述参数进行SDK初始化
    manager->initWithOptions(options);
}

//使用bugly
- (void)useBugly{
    BuglyConfig *configBug = [[BuglyConfig alloc]init];
    configBug.channel = @"App store";
    [Bugly  setUserIdentifier: DSStringValue([UserDefaults objectForKey:@"username"])];
    
    [Bugly startWithAppId:kBuglyAppId config:configBug];
}

#pragma mark umeng 统计
- (void)configUmeng{
    
    UMConfigInstance.appKey = kUmengAppKey;
    UMConfigInstance.channelId =@"App Store";

    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [MobClick setLogEnabled:NO];
    [MobClick setAppVersion:XcodeAppVersion];
}

//创建tabbarVC
- (void)gotoTabbarController {
    
    #if DEBUG
    
        SetServerVC * setSerVerVC = [[SetServerVC alloc] init];
        UINavigationController *homeNav = [self styleNavigationControllerWithRootController:setSerVerVC];
        __unsafe_unretained AppDelegate *app = self;
        setSerVerVC.start = ^() {
            MainTabBarVC *vcMainTabbar = [[MainTabBarVC alloc] init];
            app.window.rootViewController = vcMainTabbar;
            app.window.backgroundColor = [UIColor whiteColor];
        };
        self.window.rootViewController = homeNav;
    
    #else
    
        MainTabBarVC *vcMainTabbar = [[MainTabBarVC alloc] init];
        self.window.rootViewController = vcMainTabbar;
        self.window.backgroundColor = [UIColor whiteColor];
    #endif
    
}

- (UINavigationController *)styleNavigationControllerWithRootController:(UIViewController *)vc {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.tintColor = Color_White;
    nav.navigationBar.barTintColor = Color_Red_New;
    UIView *shaowLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(nav.navigationBar.frame), CGRectGetWidth(nav.navigationBar.frame), 0.5)];
    shaowLine.backgroundColor = Color_GRAY;
    [nav.navigationBar addSubview:shaowLine];
    nav.navigationBar.translucent = NO;
    return nav;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString * UrlStr = [url absoluteString];
    if([UrlStr hasPrefix:@"wx"])
    {
        return [WXShareManager wxHandleOpenURL:url delegate:(id)[WXShareManager shareInstance]];
    }else if([UrlStr hasPrefix:@"tencent"])
    {
        return [QQShareManager qqHandleOpenURL:url delegate:(id)[QQShareManager shareInstance]];
    }
    return  YES;
}

#pragma mark -初始化个推-
-(void)startGeTui{
    [GeTuiSdk runBackgroundEnable:YES];           // [是否允许APP后台运行]
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES]; // [是否运行电子围栏Lbs功能和是否SDK主动请求用户定位]
    [GeTuiSdk setChannelId:@"GT-Channel"];              // 渠道
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
    
    // [3]:注册Voip
    [self voipRegistration];
}

#pragma mark - 用户通知(推送) _自定义方法
/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

#pragma mark - 远程通知(推送)回调
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
    
//    [QMConnect setServerToken:deviceToken];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - iOS 10中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        [self getJumpDataWithVC:response.notification.request.content.userInfo];
    }
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
}

#endif

//通过控制器的布局视图可以获取到控制器实例对象    modal的展现方式需要取到控制器的根视图
- (UIViewController *)currentViewController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // modal展现方式的底层视图不同
    // 取到第一层时，取到的是UITransitionView，通过这个view拿不到控制器
    UIView *firstView = [keyWindow.subviews firstObject];
    UIView *secondView = [firstView.subviews firstObject];
    UIViewController *vc = [secondView parentController];
    
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            return [nav.viewControllers lastObject];
        } else {
            return tab.selectedViewController;
        }
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.viewControllers lastObject];
    } else {
        return vc;
    }
    return nil;
}

- (void)getJumpDataWithVC:(NSDictionary *)userInfo
{
    NSInteger badgeValue = [[UIApplication sharedApplication] applicationIconBadgeNumber] - 1;
    if (badgeValue < 0) {
        badgeValue = 0;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeValue];
    [GeTuiSdk setBadge:badgeValue];
    
    if (userInfo) {
        if (userInfo[@"url"]) {
            CommonWebVC * vcWeb = [[CommonWebVC alloc] init];
            vcWeb.strAbsoluteUrl = userInfo[@"url"];
            [[self currentViewController].navigationController pushViewController:vcWeb animated:YES];
            return;
        }
        
        if (userInfo[@"payload"]) {
            NSDictionary *dicMsg = [self dictionaryWithJsonString:userInfo[@"payload"]];
            if (dicMsg && dicMsg[@"url"]) {
                CommonWebVC * vcWeb = [[CommonWebVC alloc] init];
                vcWeb.strAbsoluteUrl = dicMsg[@"url"];
                [[self currentViewController].navigationController pushViewController:vcWeb animated:YES];
            }
        }
    }
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送
/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // 处理APNs代码，通过userInfo可以取到推送的信息（包括内容，角标，自定义参数等）。如果需要弹窗等其他操作，则需要自行编码。
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
        [self getJumpDataWithVC:userInfo];
    }
    
    //静默推送收到消息后也需要将APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    
    // 控制台打印接收APNs信息
    NSLog(@"\n>>>[Receive RemoteNotification]:%@\n\n", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
    
    
    //七陌
//    NSString *messageAlert = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
//    
//    if (application.applicationState == UIApplicationStateActive) {
//        
//        [application setApplicationIconBadgeNumber:0];
//        
//        //弹框通知
//        UIAlertController * stateAlert = [UIAlertController alertControllerWithTitle:@"客服新消息" message:messageAlert preferredStyle:UIAlertControllerStyleAlert];
//        [stateAlert addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [QMConnect registerSDKWithAppKey:kQiMoAppKey userName:[UserManager sharedUserManager].userInfo.username userId:[UserManager sharedUserManager].userInfo.uid];
//        }]];
//        [stateAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
//        [self.window.rootViewController presentViewController:stateAlert animated:YES completion:nil];
//    }else {
//        [QMConnect registerSDKWithAppKey:kQiMoAppKey userName:[UserManager sharedUserManager].userInfo.username userId:[UserManager sharedUserManager].userInfo.uid];
//    }
//    
//    [QMManager defaultManager].selectedPush = YES;
}

/**
 收到通知后回调
 @param application 应用
 @param notification 通知
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"%@", notification.userInfo);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 10.0) {
        [self getJumpDataWithVC:notification.userInfo];
    }
}

#pragma mark - GeTuiSdkDelegate
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    [MyHandle shareHandle].clientId = clientId;
    [[NSUserDefaults standardUserDefaults]setObject:clientId forKey:@"ClientId"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
        NSDictionary *dicMsg = [self dictionaryWithJsonString:payloadMsg];
        if (dicMsg) {
            if ([@"1" isEqualToString:dicMsg[@"isNotification"]]) {//发送通知
                if (offLine) {
                    
                } else {
                    NSInteger badgeValue = [[UIApplication sharedApplication] applicationIconBadgeNumber];
                    if (badgeValue < 0) {
                        badgeValue = 0;
                    }
                    badgeValue += 1;
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeValue];
                    [GeTuiSdk setBadge:badgeValue];
                    
                    //在前端的时候，发送本地通知
                    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
                        [self addlocalNotificationForNewVersion:dicMsg];
                    } else {
                        [self addLocalNotificationForOldVersion:dicMsg];
                    }
                }
            } else {
                //不发送通知
            }
        }
    }
    
//    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
//    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 iOS 10以前版本添加本地通知
 */
- (void)addLocalNotificationForOldVersion:(NSDictionary *) dic {
    //定义本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //设置调用时间
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];//通知触发的时间，1s以后
    notification.repeatInterval = 0;//通知重复次数
    notification.repeatCalendar = [NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
    
    //设置通知属性
    notification.alertTitle = [NSString localizedUserNotificationStringForKey:dic[@"title"] arguments:nil];
    notification.alertBody = [NSString localizedUserNotificationStringForKey:dic[@"summary"] arguments:nil]; //通知主体
    notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
    notification.alertLaunchImage = @"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
    notification.soundName = UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    if ([dic.allKeys containsObject:@"url"]) {
        notification.userInfo = @{@"url": dic[@"url"]};
    }
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

/**
 iOS 10以后的本地通知
 */
- (void)addlocalNotificationForNewVersion:(NSDictionary *) dic{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString localizedUserNotificationStringForKey:dic[@"title"] arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:dic[@"summary"] arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    if ([dic.allKeys containsObject:@"url"]) {
        content.userInfo = @{@"url": dic[@"url"]};
    }
    //    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:alertTime repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"GTNotification" content:content trigger:nil];
    [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
        NSLog(@"成功添加推送");
    }];
}

#pragma mark - VOIP 接入
//注册VOIP
- (void)voipRegistration {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    PKPushRegistry *voipRegistry = [[PKPushRegistry alloc] initWithQueue:mainQueue];
    voipRegistry.delegate = self;
    voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type {
    NSString *voiptoken = [credentials.token.description stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    voiptoken = [voiptoken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 向个推服务器注册 VoipToken
    [GeTuiSdk registerVoipToken:voiptoken];
    
    NSLog(@"[VoipToken is:]:%@", voiptoken);
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type {
    //3-1: TODO:接收 VOIP 推送中的 Payload 信息进行业务处理。
    // <!--TODO: 具体 VOIP 业务处理-->
    NSLog(@"[Voip Payload]:%@,%@", payload, payload.dictionaryPayload);
    
    //3-2:调用个推 VOIP 回执统计接口
    [GeTuiSdk handleVoipNotification:payload.dictionaryPayload];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [QMConnect logout];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
//    [GeTuiSdk resetBadge];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([UserManager sharedUserManager].isLogin) {
        [[GDLocationManager shareInstance] startLocation];
        [GetContactsBook CheckAddressBookAuthorization:^(bool isAuthorized) {
            if (isAuthorized) {
                [[ReportInterface shareMasterReport] upLoadAddressBook];
            }
        }];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [self checkUpdate];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
