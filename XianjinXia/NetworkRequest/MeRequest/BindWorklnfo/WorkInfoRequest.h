//
//  WorkInfoRequest.h
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseRequest.h"

@interface WorkInfoRequest : BaseRequest


/**
 获取工作信息

 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void)getWorkInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;

- (void)saveWorkInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
@end
