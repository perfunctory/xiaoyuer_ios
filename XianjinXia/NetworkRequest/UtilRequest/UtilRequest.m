//
//  UtilRequest.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "UtilRequest.h"

@implementation UtilRequest

- (void)appDeviceReportWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,kReportKey];
    [self doHttpWithUrl:strUrl andMetohd:kHttpRequestPost andParameters:paramDict andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
                successCb(dictResult[@"result"]);
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

- (void)logoutWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *dictResult))successCb andFailed:(void (^)(NSInteger code, NSString *errorMsg))failCb {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,kKDLogoutKey];
    [self doHttpWithUrl:strUrl andMetohd:kHttpRequestPost andParameters:paramDict andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
                successCb(dictResult[@"result"]);
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

- (void)uploadLocationWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *dictResult))successCb andFailed:(void (^)(NSInteger code, NSString *errorMsg))failCb {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,KUserLocation];
    [self doHttpWithUrl:strUrl andMetohd:kHttpRequestPost andParameters:paramDict andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue(dictResult[@"code"]) isEqualToString:@"0"]) {
                successCb(dictResult[@"result"]);
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
