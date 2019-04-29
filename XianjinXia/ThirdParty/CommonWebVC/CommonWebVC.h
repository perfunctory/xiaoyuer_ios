//
//  CommonWebVC.h
//  Daidaibao
//
//  Created by FengDongsheng on 16/4/20.
//  Copyright © 2016年 FengDongsheng. All rights reserved.
//

#import "SecondLevelViewController.h"
#import "NWebView.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "NWebViewDelegate.h"

typedef NS_ENUM (NSInteger,CommonWebType){
    CommonWebTypeNormal,
    CommonWebTypeFundLogin,
    CommonWebTypeFundDetail
};

@interface CommonWebVC : SecondLevelViewController<NJKWebViewProgressDelegate>

//最上层webview
@property (nonatomic, retain) NWebView *topWebView;
//代理
@property (nonatomic, retain) NWebViewDelegate *delegate;
@property (nonatomic, copy) NSString      *strType;              //类型
@property (nonatomic, copy) NSString      *strTitle;              //标题
@property (nonatomic, copy) NSString      *strAbsoluteUrl;        //绝对地址,直接加载网页时使用
@property (nonatomic, copy) NSString      *strHtmlBody;           //加载带标签的html代码时使用
@property (nonatomic, assign) CommonWebType  commonWebType;          //网页类型
@property (nonatomic)         UIColor       *progressViewColor;
@property (nonatomic, assign  ) BOOL         webType;              //需要一键返回
@property (nonatomic, copy) NSString      *navTitle;
@property (nonatomic,strong) NSString *from;
@property (nonatomic, copy) void (^blockChoose)();
@property (nonatomic, copy) void (^bindBankcardSuccess)();
@property (nonatomic, copy) void (^getAgreementStatus)();
@property (nonatomic, copy) void (^isAgreementSignErr)();
@end
