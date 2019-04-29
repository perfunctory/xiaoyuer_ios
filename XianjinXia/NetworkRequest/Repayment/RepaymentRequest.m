//
//  RepaymentRequest.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/8.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "RepaymentRequest.h"

@implementation RepaymentRequest
/**
 * 还款-还款列表
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)getLoanDataWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,kUserLoan];
    [self doHttpWithUrl:strUrl andMetohd:kHttpRequestPost andParameters:paramDict andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb([dictResult[@"code"] integerValue],DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}
@end
