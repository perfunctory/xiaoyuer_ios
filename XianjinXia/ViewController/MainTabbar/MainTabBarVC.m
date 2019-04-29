//
//  MainTabBarVC.m
//  MeiXiang
//
//  Created by FengDongsheng on 16/3/25.
//  Copyright © 2016年 FengDongsheng. All rights reserved.
//

#import "MainTabBarVC.h"
#import "MeVC.h"
#import "BorrowVC.h"
#import "QBMHomeVC.h"
#import "UserManager.h"
#import "RepayVC.h"
#import "SVProgressHUD.h"
#import "InteractivePopGestureDelegate.h"

//#import "QMChatRoomViewController.h"
//#import <QMChatSDK/QMChatSDK.h>
//#import <QMChatSDK/QMChatSDK-Swift.h>
//#import "QMAlert.h"
//#import "QMManager.h"

#import <UMMobClick/MobClick.h>

@interface MainTabBarVC ()<UITabBarControllerDelegate>

@property (nonatomic, strong) BorrowVC       * vcBorrow;
@property (nonatomic, strong) QBMHomeVC       * vcQBMHome;
@property (nonatomic, strong) RepayVC        * vcRepayMent;
@property (nonatomic, strong) MeVC           * vcMe;

@property (nonatomic, assign) BOOL isPushed;
@property (nonatomic, assign) BOOL isConnecting;
@property (nonatomic, copy) NSDictionary * dictionary;

@end

@implementation MainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isConnecting = NO;
    self.isPushed = NO;
    
    [self setUpViewController];
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpTabItem) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:@"loginOut" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerQimo) name:@"registerQimo" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginOut" object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:CUSTOM_LOGIN_SUCCEED object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:CUSTOM_LOGIN_ERROR_USER object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"registerQimo" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isPushed = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isPushed = YES;
}

- (void)loginOut{
    [UserDefaults setObject:@"1" forKey:@"Setp"];
    self.selectedIndex = 0;
}

- (void)jumpTabItem{
    [UserDefaults setObject:@"3" forKey:@"Setp"];
    self.selectedIndex = 2;
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
}

- (void)setUpViewController {
    self.view.backgroundColor = Color_Background;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:Font_Tabbar_Title,
                                                        NSForegroundColorAttributeName:Color_Tabbar_Normal}
                                             forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:Font_Tabbar_Title,
                                                        NSForegroundColorAttributeName:Color_Tabbar_Selected}
                                             forState:UIControlStateSelected];
    
    //the color for selected icon
//    [[UITabBar appearance] setSelectedImageTintColor:Color_Tabbar_Selected];
    [UITabBar appearance].tintColor = Color_Tabbar_Selected;
    [[UITabBar appearance] setBarTintColor:Color_White];
    
    _vcQBMHome = [[QBMHomeVC alloc] init];
//    UINavigationController *navigaitonVCHome = [self createNavigationControllerWithRootViewController:_vcQBMHome title:@"借款" image:ImageNamed(@"tabicon_01")];
    UINavigationController *navigaitonVCHome = [self createNavigationControllerWithRootViewController:_vcQBMHome title:@"借款" image:ImageNamed(@"tabicon_01") ];
    [navigaitonVCHome.tabBarItem setSelectedImage:[ImageNamed(@"tabicon_01_pressed") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    UINavigationController *navigaitonVCHome = [self createNavigationControllerWithRootViewController:_vcRepayMent title:@"还款" image:ImageNamed(@"tabicon_01") selectedImv:ImageNamed(@"tabicon_01_pressed")];

//    [[UINavigationController alloc] initWithRootViewController:_vcBorrow];
//    navigaitonVCHome.tabBarItem.title = @"借款";
//    navigaitonVCHome.tabBarItem.image = ImageNamed(@"tabicon_01");
    
    _vcRepayMent = [[RepayVC alloc] init];
//    UINavigationController *navigaitonVCBookService = [self createNavigationControllerWithRootViewController:_vcRepayMent title:@"还款" image:ImageNamed(@"tabicon_02")];
    UINavigationController *navigaitonVCBookService = [self createNavigationControllerWithRootViewController:_vcRepayMent title:@"还款" image:ImageNamed(@"tabicon_02") selectedImv:ImageNamed(@"tabicon_02_pressed")];

//    [[UINavigationController alloc] initWithRootViewController:_vcRepayMent];
//    navigaitonVCBookService.tabBarItem.title = @"还款";
//    navigaitonVCBookService.tabBarItem.image = ImageNamed(@"tabicon_02");
    
    _vcMe = [[MeVC alloc] init];
//    UINavigationController *navigaitonVCMe = [self createNavigationControllerWithRootViewController:_vcMe title:@"我的" image:ImageNamed(@"tabicon_03")];
    
    UINavigationController *navigaitonVCMe = [self createNavigationControllerWithRootViewController:_vcMe title:@"我的" image:ImageNamed(@"tabicon_03") selectedImv:ImageNamed(@"tabicon_03_pressed")];
 

//    [[UINavigationController alloc] initWithRootViewController:_vcMe];
//    navigaitonVCMe.tabBarItem.title = @"我的";
//    navigaitonVCMe.tabBarItem.image = ImageNamed(@"tabicon_03");
    
    self.tabBar.translucent = NO;
    self.viewControllers = @[navigaitonVCHome,navigaitonVCBookService,/**navigaitonVCMoments,*/navigaitonVCMe];
    
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    vLine.backgroundColor = Color_Tabbar_LineColor;
    [self.tabBar addSubview:vLine];
}

- (UINavigationController *)createNavigationControllerWithRootViewController:(UIViewController *)viewController title:(NSString *)title image:(UIImage *)image {
    NSAssert(nil != viewController, @"rootViewController 参数不对");
    
    UINavigationController *result = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    result.tabBarItem.title = title;
//    result.tabBarItem.image = image;
    result.tabBarItem.image = [image  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    result.interactivePopGestureRecognizer.enabled = YES;
    result.interactivePopGestureRecognizer.delegate = [InteractivePopGestureDelegate interactivePopGestureDelegateWithNavigationViewController:result];
    
    return result;
}

- (UINavigationController *)createNavigationControllerWithRootViewController:(UIViewController *)viewController title:(NSString *)title image:(UIImage *)image selectedImv:(UIImage *)imvSelected{
    NSAssert(nil != viewController, @"rootViewController 参数不对");
    
    UINavigationController *result = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    result.tabBarItem.title = title;
    
    result.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    result.tabBarItem.selectedImage = [imvSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [result.tabBarItem setSelectedImage:[imvSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    result.interactivePopGestureRecognizer.enabled = YES;
    result.interactivePopGestureRecognizer.delegate = [InteractivePopGestureDelegate interactivePopGestureDelegateWithNavigationViewController:result];
    
    return result;
}


#pragma mark -- tabBarController delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    UINavigationController *nav = (UINavigationController *)viewController;
    if ([nav.viewControllers[0] isKindOfClass:[QBMHomeVC class]]) {
        [UserDefaults setObject:@"1" forKey:@"Setp"];
        [MobClick endEvent:UmengEvent_Lend];
    }else    if ([nav.viewControllers[0] isKindOfClass:[RepayVC class]]) {
        [UserDefaults setObject:@"2" forKey:@"Setp"];
        [MobClick endEvent:UmengEvent_Repayment];
    }else    if ([nav.viewControllers[0] isKindOfClass:[MeVC class]]) {
        [UserDefaults setObject:@"3" forKey:@"Setp"];
        [MobClick endEvent:UmengEvent_My];
    }
    if([nav.viewControllers[0] isKindOfClass:[MeVC class]])
    {
        if(![[UserManager sharedUserManager]isLogin])
        {
            
            [[UserManager sharedUserManager]showLoginPage:viewController];
            
            //            __weak typeof(self) weakSelf = self;
            
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

//获取当前显示在最前面的页面的vc
- (id)getCurrentViewController
{
    UINavigationController *navNow = [self.viewControllers objectAtIndex:self.selectedIndex];
    return [navNow.viewControllers objectAtIndex:[navNow.viewControllers count] - 1];
}

- (void)showLoading:(NSString *)msg{
    [SVProgressHUD setMinimumDismissTimeInterval:5.0f];
    [SVProgressHUD showLoading];
}

- (void)hideLoading{
    [SVProgressHUD dismiss];
}

- (instancetype)init {
    self = [super init];
    if (self) {
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerSuccess:) name:CUSTOM_LOGIN_SUCCEED object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerFailure:) name:CUSTOM_LOGIN_ERROR_USER object:nil];
    }
    return self;
}

- (void)registerSuccess:(NSNotification *)sender {
    NSLog(@"注册成功");
//    if ([QMManager defaultManager].selectedPush) {
//        [self showChatRoomViewController:@"" processType:@"" entranceId:@""]; //
//    }else{
//        // 页面跳转控制
//        if (self.isPushed) {
//            return;
//        }
//
//        [QMConnect sdkGetWebchatScheduleConfig:^(NSDictionary * _Nonnull scheduleDic) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.dictionary = scheduleDic;
//                if ([self.dictionary[@"scheduleEnable"] intValue] == 1) {
//                    NSLog(@"日程管理");
//                    [self starSchedule];
//                }else{
//                    NSLog(@"技能组");
//                    [self getPeers];
//                }
//            });
//        } failBlock:^{
//
//        }];
//    }
    
//    [QMManager defaultManager].selectedPush = NO;
}

- (void)registerFailure:(NSNotification *)sender {
    NSLog(@"注册失败::%@", sender.object);
    self.isConnecting = NO;
    [self hideLoading];
}

- (void)registerQimo {
    if (self.isConnecting) {
        return;
    }
    self.isConnecting = YES;
    
    [self showLoading:@""];
    /**
     accessId:  接入客服系统的密钥， 登录web客服系统（渠道设置->移动APP客服里获取）
     userName:  用户名， 区分用户， 用户名可直接在后台会话列表显示
     userId:    用户ID， 区分用户（只能使用  数字 字母(包括大小写) 下划线）
     */
//    [QMConnect registerSDKWithAppKey:kQiMoAppKey userName:[UserManager sharedUserManager].userInfo.username userId:[UserManager sharedUserManager].userInfo.uid];
}

#pragma mark - 技能组选择
- (void)getPeers {
//    [QMConnect sdkGetPeers:^(NSArray * _Nonnull peerArray) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"%@", peerArray);
//            NSArray *peers = peerArray;
//            self.isConnecting = NO;
//            [self hideLoading];
//            if (peers.count == 1 && peers.count != 0) {
//                [self showChatRoomViewController:[peers.firstObject objectForKey:@"id"] processType:@"" entranceId:@""];
//            }else {
//                //                [self showPeersWithAlert:peers messageStr:@"选择您咨询的类型或业务部门(对应技能组)"];
//                [self showPeersWithAlert:peers messageStr:NSLocalizedString(@"title.type", nil)];
//            }
//        });
//    } failureBlock:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.isConnecting = NO;
//            [self hideLoading];
//        });
//    }];
}

#pragma mark - 日程管理
- (void)starSchedule {
    self.isConnecting = NO;
    [self hideLoading];
    if ([self.dictionary[@"scheduleId"]  isEqual: @""] || [self.dictionary[@"processId"]  isEqual: @""] || [self.dictionary objectForKey:@"entranceNode"] == nil || [self.dictionary objectForKey:@"leavemsgNodes"] == nil) {
        //        [QMAlert showMessage:@"对不起，由于在线咨询配置错误，暂时无法进行咨询"];
//        [QMAlert showMessage:NSLocalizedString(@"title.sorryconfigurationiswrong", nil)];
    }else{
        NSDictionary *entranceNode = self.dictionary[@"entranceNode"];
        NSArray *entrances = entranceNode[@"entrances"];
        if (entrances.count == 1 && entrances.count != 0) {
            [self showChatRoomViewController:[entrances.firstObject objectForKey:@"processTo"] processType:[entrances.firstObject objectForKey:@"processType"] entranceId:[entrances.firstObject objectForKey:@"_id"]];
        }else{
            //            [self showPeersWithAlert:entrances messageStr:@"选择您咨询的日程管理类型"];
            [self showPeersWithAlert:entrances messageStr:NSLocalizedString(@"title.schedule_type", nil)];
        }
    }
}

- (void)showPeersWithAlert: (NSArray *)peers messageStr: (NSString *)message {
    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择您咨询的类型或业务部门(对应技能组)" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"title.type", nil) preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button.cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.isConnecting = NO;
    }];
    [alertController addAction:cancelAction];
    for (NSDictionary *index in peers) {
        UIAlertAction *surelAction = [UIAlertAction actionWithTitle:[index objectForKey:@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([self.dictionary[@"scheduleEnable"] integerValue] == 1) {
                [self showChatRoomViewController:[index objectForKey:@"processTo"] processType:[index objectForKey:@"processType"] entranceId:[index objectForKey:@"_id"]];
            }else{
                [self showChatRoomViewController:[index objectForKey:@"id"] processType:@"" entranceId:@""];
            }
        }];
        [alertController addAction:surelAction];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 跳转聊天界面
- (void)showChatRoomViewController:(NSString *)peerId processType:(NSString *)processType entranceId:(NSString *)entranceId {
//    QMChatRoomViewController *chatRoomViewController = [[QMChatRoomViewController alloc] init];
//    chatRoomViewController.peerId = peerId;
//    chatRoomViewController.isPush = NO;
//    chatRoomViewController.avaterStr = @"";
//    if ([self.dictionary[@"scheduleEnable"] intValue] == 1) {
//        chatRoomViewController.isOpenSchedule = true;
//        chatRoomViewController.scheduleId = self.dictionary[@"scheduleId"];
//        chatRoomViewController.processId = self.dictionary[@"processId"];
//        chatRoomViewController.currentNodeId = peerId;
//        chatRoomViewController.processType = processType;
//        chatRoomViewController.entranceId = entranceId;
//    }else{
//        chatRoomViewController.isOpenSchedule = false;
//    }
    
//    [self dsPushViewController:chatRoomViewController animated:YES];
    
    //隐藏tabbar
//    chatRoomViewController.hidesBottomBarWhenPushed = YES;
//    [((UINavigationController *)self.selectedViewController) pushViewController:chatRoomViewController animated:YES];
}

- (NSMutableAttributedString *)setSpace:(CGFloat)line kern:(NSNumber *)kern font:(UIFont *)font text:(NSString *)text {
    NSMutableParagraphStyle * paraStyle = [NSMutableParagraphStyle new];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = line;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *attributes = @{
                                 NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paraStyle,
                                 NSKernAttributeName: kern
                                 };
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributeStr;
}

@end
