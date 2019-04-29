//
//  LoginOrRegistRequest.m
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "LoginOrRegistRequest.h"

@implementation LoginOrRegistRequest

- (void)checkPhoneNumberWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{

    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,KUserRegGetCode];
    [self doHttpWithUrl:strUrl andMetohd:kHttpRequestPost andParameters:paramDict andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"1000"]) {
                    failCb(1000,DSStringValue(dictResult[@"message"]));
                }else{
                    failCb(statusCode,DSStringValue(dictResult[@"message"]));
                }
                
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode,errorMsg);
    }];
}

- (void)LoginOutWihtDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,kKDLogoutKey];
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


- (void)LoginWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,kKDLoginKey];
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

- (void)getRegisterWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{

    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,KUserRegGetCode];
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

- (void)commitRegisterWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb{

    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,kKDZhuceKey];
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
