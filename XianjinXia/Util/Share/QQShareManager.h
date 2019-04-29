//
//  QQShareManager.h
//  KDLC
//
//  Created by haoran on 16/4/22.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "KDShare.h"
#import "KDShareEntity.h"
typedef void (^qqCallBack)(QQBaseResp *resp);

@interface QQShareManager : NSObject

@property(nonatomic,copy)qqCallBack callBack;
+(QQShareManager *)shareInstance;
/**
 检测是否已安装QQ
 \return 如果QQ已安装则返回YES，否则返回NO
 */
+ (BOOL)isQQInstalled;
/**
 处理由手Q唤起的跳转请求
 \param url 待处理的url跳转请求
 \param delegate 第三方应用用于处理来至QQ请求及响应的委托对象
 \return 跳转请求处理结果，YES表示成功处理，NO表示不支持的请求协议或处理失败
 */
//处理qq的请求
+ (BOOL)qqHandleOpenURL:(NSURL *)url delegate:(id<QQApiInterfaceDelegate>)delegate;

//认证
- (void)qqauthrize;

//增加带block回调的分享
- (void)shareToQQWithShareContent:(KDShare *)share andWithType:(NSInteger)type withCallBackBlock:(qqCallBack)callback;

/**
 *  新增分享API  老的不动先  地方太多
 *
 *  @param entity   分享更换成实体
 *  @param type     分享场景 3qq 4qq空间
 *  @param callback 分享回调
 */
- (void)shareToQQNewWithShareContent:(KDShareEntity *)entity andWithType:(NSInteger)type withCallBackBlock:(qqCallBack)callback;
@end
