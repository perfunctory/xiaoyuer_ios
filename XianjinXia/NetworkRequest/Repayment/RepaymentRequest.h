//
//  RepaymentRequest.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/8.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseRequest.h"

@interface RepaymentRequest : BaseRequest
/**
 * 还款-还款列表
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */
- (void)getLoanDataWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
@end
