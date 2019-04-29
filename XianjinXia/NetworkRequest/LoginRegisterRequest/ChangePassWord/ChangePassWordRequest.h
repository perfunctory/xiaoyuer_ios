//
//  ChangePassWordRequest.h
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/15.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseRequest.h"

@interface ChangePassWordRequest : BaseRequest

/**
 *  修改登录密码（isLoginPassWord = 1）
 *  修改交易密码 (isLoginPassWord = 0）
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */

- (void)changePassWordWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb isLoginPassWord:(NSString *)isLoginPassWord;

@end
