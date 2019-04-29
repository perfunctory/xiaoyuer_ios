//
//  NWebViewDelegate.h
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/20.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWebViewDelegate : NSObject<UIWebViewDelegate>

/**
 *  webview相关
 */
@property (nonatomic, copy) BOOL (^startLoadWithRequest)(UIWebView *webView,NSURLRequest *request,UIWebViewNavigationType type);
@property (nonatomic, copy) void (^didStartLoadWithRequest)(UIWebView *webView);
@property (nonatomic, copy) void (^afterLoadFinish)(UIWebView *webView);
@property (nonatomic, copy) void (^afterLoadFaild)(UIWebView *webView);

//跳转的时候要用到
@property (nonatomic, weak) UIViewController *viewController;

/**
 *  积分商城
 */
//积分兑换商品id，只用于积分兑换
@property (nonatomic, retain) NSString *integralGoodsId;
//商品名
@property (nonatomic, retain) NSString *goodsName;
//兑换所需积分数
@property (nonatomic, retain) NSString *integralNum;

////兼容老的h5的分享传参方式
//@property (nonatomic, retain) KDShare *shareData;

@end
