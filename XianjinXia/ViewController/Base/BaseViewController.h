//
//  BaseViewController.h
//  Demo
//
//  Created by FengDongsheng on 15/5/28.
//  Copyright (c) 2015年 FengDongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

typedef enum{
    PageGobackTypeNone,
    PageGobackTypeDismiss,
    PageGobackTypePop,
    PageGobackTypeRoot
}PageGobackType;

@interface BaseViewController : UIViewController

@property (assign, nonatomic) BOOL isRequestProcessing;//请求是否在处理中

/**
 *  页面基本设置
 *
 *  @param gobackType 页面返回类型
 */
- (void)baseSetup:(PageGobackType)gobackType;

/**
 *  现实提示信息
 *
 *  @param msg 要显示的消息内容
 */
- (void)showMessage:(NSString *)msg;

/**
 *  显示加载框
 *
 *  @param msg 提示内容
 */
- (void)showLoading:(NSString *)msg;

/**
 *  隐藏加载框
 */
- (void)hideLoading;

/**
 *  用于push vc 隐藏tabbar
 *
 *  @param vc       要push的vc
 *  @param animated 动画效果
 */
- (void)dsPushViewController:(UIViewController*)vc animated:(BOOL)animated;

/**
 *  dimiss页面
 */
- (void)dismissVC;

/**
 *popToRoot页面
 */
- (void)popToRoot;

/**
 *返回任意一个页面
 */
- (void)popToViewControllerAtIndex:(NSInteger)index;

/**
 *  pop页面
 */
- (void)popVC;

/**
 *  友盟
 */
-(void)umengEvent:(NSString *)eventId;

@end
