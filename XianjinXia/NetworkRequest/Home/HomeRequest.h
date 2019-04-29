//
//  HomeRequest.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/7.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseRequest.h"

@interface HomeRequest : BaseRequest

//首页
- (void)getHomeDataWithDict:(NSDictionary*)paramDict onSuccess:(void(^)(NSDictionary *dictResult))successCb andFailed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
//用户借款详细信息
- (void)userApplyBorrowWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
//取消失败状态
- (void)cancenUserBorrowFailureWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
//获取费用详情
- (void)fetchServiceChargeWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
//上报app列表
- (void)upAppsInfoWithDictionary:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
//获取首页广告页弹框
- (void)getHomeAdsWithDict:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
//向后台发送个推id信息
- (void)updateCliendIdWithDic:(NSDictionary *)paramDict success:(void(^)(NSDictionary *dictResult))successCb failed:(void(^)(NSInteger code,NSString *errorMsg))failCb;
@end
