//
//  HomeRequest.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/7.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "HomeRequest.h"

@implementation HomeRequest

- (void)getHomeDataWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",Url_Server,newKCreditAppIndex];
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

- (void)userApplyBorrowWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, newkCreditLoanGetConfirmLoan] andMetohd:kHttpRequestPost andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
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
        failCb(statusCode, errorMsg);
    }];
}

- (void)cancenUserBorrowFailureWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kCreditConfirmFailedLoan] andMetohd:kHttpRequestPost andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        
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
        
        failCb(statusCode, errorMsg);
        
    }];
}

- (void)fetchServiceChargeWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, newkCreditServiceCharge] andMetohd:kHttpRequestPost andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue([dictResult[@"code"] description]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
        
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        
        failCb(statusCode, errorMsg);
        
    }];
}
- (void)upAppsInfoWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, KUserAppInfo] andMetohd:kHttpRequestPost andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue([dictResult[@"code"] description]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        
        failCb(statusCode, errorMsg);
        
    }];
}

- (void)getHomeAdsWithDict:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kAds] andMetohd:kHttpRequestPost andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *dictResult = responseObject;
            if ([DSStringValue([dictResult[@"code"] description]) isEqualToString:@"0"]) {
                successCb(dictResult[@"data"]);
            }else{
                failCb(statusCode,DSStringValue(dictResult[@"message"]));
            }
        }else{
            failCb(statusCode,kErrorUnknown);
        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

//向后台发送个推id信息
- (void)updateCliendIdWithDic:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb{
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@",Url_Server,CliendId] andMetohd:kHttpRequestPost andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        NSLog(@"+++++++++++++++%@",responseObject);
        //        if (statusCode == 200) {
        NSDictionary *dictResult = responseObject;
        if ([DSStringValue([dictResult[@"successed"] description]) isEqualToString:@"1"]) {
            successCb(dictResult);
        }else{
            failCb(statusCode,DSStringValue(dictResult[@"msg"]));
        }
        //        }else{
        //            failCb(statusCode,kErrorUnknown);
        //        }
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        failCb(statusCode, errorMsg);
    }];
}

@end
