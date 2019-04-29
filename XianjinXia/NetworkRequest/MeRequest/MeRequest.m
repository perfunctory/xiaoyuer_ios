//
//  MeRequest.m
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "MeRequest.h"

@implementation MeRequest
- (void) getUserInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,kUserGetInfo];
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
