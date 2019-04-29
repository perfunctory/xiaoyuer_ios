//
//  BaseViewController.m
//  Demo
//
//  Created by FengDongsheng on 15/5/28.
//  Copyright (c) 2015年 FengDongsheng. All rights reserved.
//

#import "BaseViewController.h"
#import "UserManager.h"
#import "SVProgressHUD.h"
#import <UMMobClick/MobClick.h>

#define kBtnChoosePictureHeight         50

#define Font_Choose_PictureItem         FontSystem(17.0f)
#define Color_Moments_ChooseBg          UIColorFromRGB(0xe5e5e5)

@interface BaseViewController () {
    BOOL isNotShowStatusBar;
    UIImageView *navBarHairlineImageView;
}

@property (strong, nonatomic) MBProgressHUD             *progressHud;
@property (assign, nonatomic) BOOL                      isHeadQuarter;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}
- (void)configUI{
    
    //设置UINavigationbar
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
        [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    self.navigationController.navigationBar.translucent = NO;
    _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHud.bezelView.alpha = 0.5;
    
    self.isRequestProcessing = NO;
    self.navigationController.navigationBar.barTintColor = Color_Tabbar_Selected;
}

//找到UINavigationBar下面的线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置title颜色和大小
//    self.navigationController.navigationBar.alpha = 1;
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:Color_Title_Black,NSFontAttributeName:Font_Navigationbar_Title};
//    self.navigationController.navigationBar.barTintColor = Color_White;
////    self.navigationController.navigationBar.tintColor = Color_Tabbar_Selected;
//    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    [NotificationCenter addObserver:self selector:@selector(showLogin) name:kNotificationNeedLogin object:nil];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    DLog(@"ViewController ====== %@",NSStringFromClass([self class]));
}

- (void)viewWillDisappear:(BOOL)animated{
    [NotificationCenter removeObserver:self name:kNotificationNeedLogin object:nil];
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)showLogin{
    [[UserManager sharedUserManager] showLoginPage:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showMessage:(NSString *)msg{
    if ([msg isEqualToString:@""]) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeText;
//    hud.label.text = [TipMessage shared].tipMessage.tipTitle;
    hud.detailsLabel.text = msg;
    hud.detailsLabel.font = FONT(18);
    hud.margin = 15;
    hud.backgroundView.alpha = 0.8;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

- (void)showLoading:(NSString *)msg{

    [SVProgressHUD setMinimumDismissTimeInterval:5.0f];
    [SVProgressHUD showLoading];
    
//    [self.view addSubview:self.progressHud];
//    self.progressHud.label.text = msg;
//    self.progressHud.removeFromSuperViewOnHide = YES;
//    [self.progressHud showAnimated:YES];
    
}

- (void)hideLoading{
    [SVProgressHUD dismiss];
}

#pragma --mark 页面基本设置
/**
 *  页面基本设置,页面背景颜色、页面是否包含返回按钮、对返回按钮做相应的处理
 *
 *  @param gobackType 页面返回类型
 */
- (void)baseSetup:(PageGobackType)gobackType{
    
    //设置页面背景
    self.view.backgroundColor = Color_Background;
    
    //设置返回按钮
    if (gobackType != PageGobackTypeNone) {
        UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [btnLeft setTitle:@"" forState:UIControlStateNormal];
        [btnLeft setBackgroundImage:ImageNamed(@"navigationBar_popBack") forState:UIControlStateNormal];
        
        if (gobackType == PageGobackTypePop) {
            [btnLeft addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
        }else if (gobackType == PageGobackTypeDismiss){
            [btnLeft addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
        }else if (gobackType == PageGobackTypeRoot){
            [btnLeft addTarget:self action:@selector(popToRoot) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -5;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer,leftItem]];
    }else{
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
}

/**
 *  dimiss页面
 */
- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.tabBarController.tabBar.hidden = NO;
}

/**
 *返回任意一个页面
 */
- (void)popToViewControllerAtIndex:(NSInteger)index{
    if (self.navigationController.viewControllers.count > index) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:YES];
    }
}
/**
 *popToRoot页面
 */
- (void)popToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  pop页面
 */
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dsPushViewController:(UIViewController*)vc animated:(BOOL)animated{
    if (self.navigationController.viewControllers.count == 1) {
        vc.hidesBottomBarWhenPushed = YES;
    }
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

-(void)umengEvent:(NSString *)eventId{
    [MobClick event:eventId];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#if DEBUG
- (void)dealloc {
    
    NSLog(@"%@ class release", NSStringFromClass([self class]));
    [NotificationCenter removeObserver:self];
    
}
#endif

@end
