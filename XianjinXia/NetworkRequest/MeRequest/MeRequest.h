//
//  MeRequest.h
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseRequest.h"

@interface MeRequest : BaseRequest
/**
 获取我的页面数据
 
 @param paramDict 参数字典
 @param successCb 成功回调
 @param failCb 失败回调
 */
- (void) getUserInfoWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
@end
