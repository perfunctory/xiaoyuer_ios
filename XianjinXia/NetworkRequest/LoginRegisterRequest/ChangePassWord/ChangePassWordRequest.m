//
//  ChangePassWordRequest.m
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/15.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "ChangePassWordRequest.h"

@implementation ChangePassWordRequest

- (void)changePassWordWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb isLoginPassWord:(NSString *)isLoginPassWord{
    
    NSString *strUrl;
    if ([isLoginPassWord isEqualToString:@"1"]) {
        strUrl =  [NSString stringWithFormat:@"%@%@",Url_Server,KModifyLoginPassWord];
    }else if ([isLoginPassWord isEqualToString:@"0"]){
        strUrl =  [NSString stringWithFormat:@"%@%@",Url_Server,KModifyPayPassWord];
    }
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
