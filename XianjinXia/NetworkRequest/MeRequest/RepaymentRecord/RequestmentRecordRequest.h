//
//  RequestmentRecordRequest.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseRequest.h"

@interface RequestmentRecordRequest : BaseRequest
/**
 * 我的-借款列表
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void) getRepaymentRecordInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
@end
