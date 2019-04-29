//
//  NWebView.h
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/20.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseRequest.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol jsApiDelegate <JSExport>
//页面添加分享按钮
- (void)shareMethod:(NSString *)param;
- (void)shareMethod;
//页面跳转
- (void)pageJump:(NSDictionary *)param;
//页面刷新
- (void)RefreshAccountList:(NSDictionary *)param;
//js调用原生方法
- (void)returnNativeMethod: (NSString *)param;
//js调用剪贴板
- (void)copyTextMethod:(NSString *)param;

// JS调用此方法来调用OC的系统相册方法
- (void)callSystemCamera;

//支付宝爬虫
//遮罩
- (void)goneLayout:(NSString *)param;
//上报
- (void)submitText:(NSString *)param;
//取缓存
- (NSString *)getText:(NSString *)param;

//缓存
- (void)saveText:(NSString *)param  :(NSString *)text;
//进度条
-(void)setProgress:(NSString *)pararm;
@end
@interface NWebView : UIWebView<jsApiDelegate>

@property (nonatomic, retain) JSContext *js_Context;

//是否登录过
@property (assign, nonatomic) NSInteger uid;

@property (assign, nonatomic) BOOL isReload;

@property (nonatomic, retain) NSString *title;

//是否还认showshare
@property (assign, nonatomic) BOOL ignoreShowShare;

//右上角是否有长留按钮
@property (assign, nonatomic) BOOL haveRightButtonItem;

@end
