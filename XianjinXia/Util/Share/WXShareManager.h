//
//  WXShareManager.h
//  KDLC
//
//  Created by haoran on 16/4/22.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDShare.h"
#import "WXApi.h"
#import "KDShareEntity.h"
typedef void (^weixinCallBack)(BaseResp *resp);

@interface WXShareManager : NSObject

@property(nonatomic,copy) weixinCallBack callback;

+(WXShareManager *)shareInstance;

/*! @brief WXApi的成员函数，向微信终端程序注册第三方应用。
 *
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现。
 * iOS7及以上系统需要调起一次微信才会出现在微信的可用应用列表中。
 * @attention 请保证在主线程中调用此函数
 * @param appid 微信开发者ID
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) resigterWXApp:(NSString *)appid;

/*! @brief 处理微信通过URL启动App时传递的数据
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url 微信启动第三方应用时传递过来的URL
 * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
 * @return 成功返回YES，失败返回NO。
 */

+(BOOL) wxHandleOpenURL:(NSURL *) url delegate:(id) delegate;

/*! @brief 检查微信是否已被用户安装
 *
 * @return 微信已安装返回YES，未安装返回NO。
 */
+(BOOL) isWXAppInstalled;

//微信授权登陆
- (void)wxLoginWithViewController:(UIViewController *)vc;

/**
 *  分享到微信 增加block回调方法
 *
 *  @param share  分享实体
 *  @param scence 分享的场景  0微信分享 1微信朋友圈分享
 *  @param resp   微信回调block
 */
- (void)shareToWXWithShare:(KDShare *)share withType:(NSInteger)scence withCallBackBlock:(weixinCallBack )resp;

/**
 *  分享到微信 增加block回调方法
 *
 *  @param entity  分享实体
 *  @param scence 分享的场景  0微信分享 1微信朋友圈分享
 *  @param resp   微信回调block
 */
- (void)shareToWXNewWithShare:(KDShareEntity *)entity withType:(NSInteger)scence withCallBackBlock:(weixinCallBack )resp;
@end
