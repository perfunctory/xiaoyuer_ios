//
//  WXShareManager.m
//  KDLC
//
//  Created by haoran on 16/4/22.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "WXShareManager.h"
#import "WXApi.h"
#import "KDShareHeader.h"
#import "SecurityStrategy.h"
#import "UIImageView+Additions.h"

@interface WXShareManager ()<WXApiDelegate>

@end
@implementation WXShareManager

+(WXShareManager *)shareInstance
{
    static WXShareManager *sharedManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManager = [[WXShareManager alloc]init];
    });
    return sharedManager;
}

//注册应用
+(BOOL)resigterWXApp:(NSString *)appid
{
    return [WXApi registerApp:appid];
}
//处理微信的请求
+(BOOL)wxHandleOpenURL:(NSURL *)url delegate:(id<WXApiDelegate>)delegate
{
    return [WXApi handleOpenURL:url delegate:delegate];
}
//是否安装微信
+(BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}
- (void)wxLoginWithViewController:(UIViewController *)vc
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_base,snsapi_userinfo"; // @"post_timeline,sns"
    req.state = @"0744";
    [WXApi sendAuthReq:req viewController:vc delegate:self];
}

//带回调的分享
- (void)shareToWXWithShare:(KDShare *)share withType:(NSInteger)scence withCallBackBlock:(weixinCallBack)resp
{
    if (share) {
        WXMediaMessage *message = [[WXMediaMessage alloc]init];
        message.title = share.shareTitle;
        if (scence == 1) {
            message.title = [NSString stringWithFormat:@"【%@】 %@",share.shareTitle,share.shareContent];
        }
        message.description = share.shareContent;
        [message setThumbImage:share.shareImage];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = share.shareUrl;
        
        message.mediaObject = ext;
        message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.message =  message;
        req.bText = NO;
        req.scene = (int)scence;
        
        [WXApi sendReq:req];
        
        self.callback = [resp copy];
    }
}
#pragma mark - 分享重构后增加的API 老的不动先
- (void)shareToWXNewWithShare:(KDShareEntity *)entity withType:(NSInteger)scence withCallBackBlock:(weixinCallBack)resp
{
    
    if (entity) {
        WXMediaMessage *message = [[WXMediaMessage alloc]init];
        message.title = entity.share_title;
        if (scence == 1) {
            message.title = [NSString stringWithFormat:@"【%@】 %@",entity.share_title,entity.share_body];
        }
        message.description = entity.share_body;
        
        if (![entity.share_logo isEqualToString:@"share.jpg"]) {
              [message setThumbImage:[UIImageView cacheImageWithURL:entity.share_logo]];
        } else {
            [message setThumbImage:[UIImage imageNamed:@"share.jpg"]];
        }
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = entity.share_url;
        
        message.mediaObject = ext;
        message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.message =  message;
        req.bText = NO;
        req.scene = (int)scence;
        
        [WXApi sendReq:req];
        
        self.callback = [resp copy];
    }

}


#pragma mark -
#pragma mark -WXApiDelegate
/*! @brief 接收并处理来自微信终端程序的事件消息
 *
 * 接收并处理来自微信终端程序的事件消息，期间微信界面会切换到第三方应用程序。
 * WXApiDelegate 会在handleOpenURL:delegate:中使用并触发。
 */
- (void)onReq:(BaseReq *)req
{
}
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * 具体请求内容，是自动释放的
 */
- (void)onResp:(BaseResp *)resp
{
    [SecurityStrategy removeBlurEffect];
    if (self.callback) {
        self.callback(resp);
    }
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
    
    }
}

@end
