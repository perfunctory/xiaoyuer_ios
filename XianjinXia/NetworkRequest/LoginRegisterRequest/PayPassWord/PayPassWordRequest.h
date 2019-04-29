//
//  PayPassWordRequest.h
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/15.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseRequest.h"

@interface PayPassWordRequest : BaseRequest

/**
 * 初次设置交易密码
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */

- (void)setPaypasswordWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 找回密码获取验证码
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */

- (void)resetPwdCodeWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 找回密码验证个人信息
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */

- (void)userVerifyResetPasswordWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

/**
 * 找回交易密码设置新密码
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */

- (void)resetPayPasswordWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

@end
