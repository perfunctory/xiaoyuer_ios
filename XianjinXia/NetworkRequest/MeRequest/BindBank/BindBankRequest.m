//
//  BindBankModel.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BindBankRequest.h"

@implementation BindBankRequest
/**
 * 收款银行卡-获取短信验证码
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)getVCodeDataWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,kCreditCardGetCode];
    [self doHttpWithUrl:strUrl andMetohd:kHttpRequestPost andParameters:paramDict andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
                successCb(dictResult);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}

/**
 * 收款银行卡-选择银行列表
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)getBankListDataWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,kCreditCardBankCardInfo];
    [self doHttpWithUrl:strUrl andMetohd:kHttpRequestPost andParameters:paramDict andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}

/**
 * 收款银行卡-保存信息
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)SaveBankDataWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,kCreditCardAddBankCard];
    [self doHttpWithUrl:strUrl andMetohd:kHttpRequestPost andParameters:paramDict andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
                successCb(dictResult);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}

@end
