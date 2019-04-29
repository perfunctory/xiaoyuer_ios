//
//  ApplyForLoanRequest.h
//  XianjinXia
//
//  Created by sword on 13/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import "BaseRequest.h"

@interface ApplyForLoanRequest : BaseRequest

//提交用户借款信息
- (void)confirmUserBorrowWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;


//获取合同签名状态
- (void)getAgreementStatus:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

@end
