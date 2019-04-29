//
//  ApplicationUtil.h
//  Demo
//
//  Created by FengDongsheng on 12/6/8.
//  Copyright (c) 2012年 FengDongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationUtil : NSObject

@property (strong, nonatomic, readonly) NSDateFormatter *dateFormatter; /**< 时间格式 */

+ (instancetype)sharedApplicationUtil;

/**
 *  拨打电话
 *
 *  @param telNumber 电话号码
 */
- (void)makeTelephoneCall:(NSString *)telNumber;

/**
 *  注册push通知
 */
- (void)registerNotification;

/**
 *  判断用户是否开启了定位服务
 *
 *  @return YES 开启了 NO 未开启
 */
- (BOOL)bIsOpenLocationService;

/**
 *  跳转到系统设置页面，iOS8之后可用
 */
- (void)gotoSettings;

/**
 *  检查当前版本是否需要更新 0 是最新 1 需要选择更新 2 需要强制更新
 */
- (void)checkVersionIsTheLatest:(void(^)(NSInteger updateType, NSString *updateContent, NSString *updateUrl))completeBlock;

@end
