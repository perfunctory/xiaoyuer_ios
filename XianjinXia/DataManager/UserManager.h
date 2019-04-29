//
//  UserManager.h
//  EveryDay
//
//  Created by FengDongsheng on 15/6/25.
//  Copyright (c) 2015年 FengDongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserManager : NSObject

@property (nonatomic, strong) UserModel     *userInfo;

//交易密码状态
@property (nonatomic, assign) NSInteger real_pay_pwd_status;
@property (nonatomic, assign) BOOL countDownStateOfLoan; /**< 还款倒计时状态（本地缓存） */

+ (UserManager*)sharedUserManager;

//判断用户是否登录，没登陆会弹出登录按钮
- (BOOL)checkLogin:(UIViewController *)viewController;

//是否已经登录
- (BOOL)isLogin;

//弹出登录页面
- (void)showLoginPage:(UIViewController *)viewController;

//退出登录
- (void)logout;

//登录
- (void)updateUserInfo:(NSDictionary *)uInfo;

//获取用户信息
- (void)getUserInfoSuccess:(void(^)(UserModel* userInfo))successCb andFailed:(void(^)(NSInteger code, NSString *errorMsg))failCb;

//获取用户融云token
- (void)getUserRongyunTokenSuccess:(void(^)(NSString* rongyunToken))successCb andFailed:(void(^)(NSInteger code, NSString *errorMsg))failCb;

//更新交易密码信息
- (void)updatePayPassWordtatus:(NSInteger)status;


@end
