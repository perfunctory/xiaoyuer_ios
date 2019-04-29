//
//  ApplyForLoanRequest.m
//  XianjinXia
//
//  Created by sword on 13/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import "ApplyForLoanRequest.h"

@implementation ApplyForLoanRequest

- (void)confirmUserBorrowWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, newkCreditLoanApplyLoan] andMetohd:kHttpRequestPost andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
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

- (void)getAgreementStatus:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb {
    
    [self doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kCreditLoanGetAgreementStatus] andMetohd:kHttpRequestPost andParameters:[paramDict copy] andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
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

@end
