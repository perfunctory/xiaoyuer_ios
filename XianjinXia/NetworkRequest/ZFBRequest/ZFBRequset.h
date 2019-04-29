//
//  ZFBRequset.h
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/20.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseRequest.h"

@interface ZFBRequset : BaseRequest

/**
 *  上传支付宝信息
 *
 *  @param paramDict 参数字典
 *  @param successCb 成功回调
 *  @param failCb    失败回调
 */

- (void)ZFBWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

@end
