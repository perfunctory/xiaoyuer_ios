//
//  MyAwardRequest.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "MyAwardRequest.h"

@implementation MyAwardRequest
/**
 * 我的-抽奖码
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)getAwardDataWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,KDrawAwardList];
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
@end
