//
//  UtilRequest.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseRequest.h"

@interface UtilRequest : BaseRequest

//上报app信息
- (void)appDeviceReportWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
//退出登陆
- (void)logoutWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
//上传用户位置信息
- (void)uploadLocationWithDict:(NSDictionary *)paramDict onSuccess:(void (^)(NSDictionary *dictResult))successCb andFailed:(void (^)(NSInteger code, NSString *errorMsg))failCb;

@end
