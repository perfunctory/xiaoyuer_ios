//
//  LoginOrRegistRequest.h
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseRequest.h"

@interface LoginOrRegistRequest : BaseRequest


/**
 手机号登陆 -- 判断该手机号是否注册
 
 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void)checkPhoneNumberWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 用户输入密码登入
 
 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void)LoginWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 退出登录
 
 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void)LoginOutWihtDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 获取注册验证码
 
 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void)getRegisterWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
/**
 用户注册
 
 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void)commitRegisterWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

@end
