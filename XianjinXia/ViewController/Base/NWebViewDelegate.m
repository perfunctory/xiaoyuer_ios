//
//  NWebViewDelegate.m
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/20.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "NWebViewDelegate.h"
#import "NWebView.h"
#import "CommonWebVC.h"
#import "UserManager.h"
#import "NSString+Url.h"
#import "NSString+Additions.h"
#import "GToolUtil.h"

static NSString * const AppNAME = @"信合宝";
@interface NWebViewDelegate ()

@property (nonatomic, retain) JSContext *context;
@property (nonatomic, strong) UIBarButtonItem   *closeButtonItem;
@property (nonatomic, strong) UIBarButtonItem   *backItem;

@end

@implementation NWebViewDelegate

//代理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    // NOTE: ------  对alipays:相关的scheme处理 -------
    // NOTE: 若遇到支付宝相关scheme，则跳转到本地支付宝App
    NSString* reqUrl = request.URL.absoluteString;
    if ([reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
        // NOTE: 跳转支付宝App
        BOOL bSucc = [[UIApplication sharedApplication]openURL:request.URL];
        
        // NOTE: 如果跳转失败，则跳转itune下载支付宝App
        if (!bSucc) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"未检测到支付宝客户端，请安装后重试。"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"立即安装",nil];
            [alert show];
        }
        return NO;
    }
    
    NSDictionary *dicURLParam = [request.URL.absoluteString urlParam];
    if ([[GToolUtil getNetworkType] isEqualToString:@""] && dicURLParam[@"_bid"]) {
        //        [[iToast makeText:@"当前网络断开啦，请检查网络连接"] show];
        [self showMessage:@"当前网络断开啦，请检查网络连接"];
    }
    
    BOOL isShortUrl = [self shortUrlAction:webView request:request];
    if (!isShortUrl) {
        return NO;
    }
    
    BOOL startBlock = YES;
    if (self.startLoadWithRequest) {
        startBlock = self.startLoadWithRequest(webView,request,navigationType);
    }
    if (!startBlock) {
        return NO;
    }
    
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked && [request.URL.absoluteString rangeOfString:@".pdf"].location != NSNotFound) {
        CommonWebVC *webViewVC = [[CommonWebVC alloc] init];
        webViewVC.strAbsoluteUrl = request.URL.absoluteString;
        [self.viewController.navigationController pushViewController:webViewVC animated:YES];
        return NO;
    }
    
    //写cookie  写入参数交给KDURLProtocol处理
    //    [[UserManager sharedUserManager] writeCookie:[request URL].absoluteString];
    
    NSString *weburl = [request URL].absoluteString;
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:weburl]];
    NSEnumerator *enumerator = [cookies objectEnumerator];
    NSHTTPCookie *cookie;
    while (cookie = [enumerator nextObject]) {
        NSLog(@"COOKIE{name: %@, value: %@}", [cookie name], [cookie value]);
        if([[cookie name] isEqualToString:@"ALIPAYJSESSIONID"]){
            
            NSLog(@"COOKIE{name: %@, value: %@}", [cookie name], [cookie value]);
        }
    }
    
    
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"nativeMethod"] = webView;
    if ([[webView class] isSubclassOfClass:[NWebView class]]) {
        ((NWebView * )webView).js_Context  = _context ;
    }
    _context[@"shareMethod"] = ^() {
        NSArray * arr = [JSContext currentArguments];
        for (id obj in arr) {
            NSLog(@"%@",obj);
        }
    };
    NSLog(@"%@",request.URL);
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            case 1:
        {
            // NOTE: 跳转itune下载支付宝App
            NSString* urlStr = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
            NSURL *downloadUrl = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication]openURL:downloadUrl];
        }
            break;
            
        default:
            break;
    }
    
}


- (void)showMessage:(NSString *)msg{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.mode = MBProgressHUDModeText;
    //    hud.label.text = [TipMessage shared].tipMessage.tipTitle;
    hud.detailsLabel.text = msg;
    hud.detailsLabel.font = FONT(18);
    hud.margin = 25;
    hud.backgroundView.alpha = 0.8;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.didStartLoadWithRequest) {
        self.didStartLoadWithRequest(webView);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.afterLoadFinish) {
        self.afterLoadFinish(webView);
    }
    
    NSNotification *noti = [[NSNotification alloc] initWithName:@"bid_notification" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    //添加js交互context
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"nativeMethod"] = webView;
    if ([[webView class] isSubclassOfClass:[NWebView class]]) {
        ((NWebView * )webView).js_Context  = _context ;
    }
    //    //处理title
    //    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    //    if (theTitle && ![theTitle isEqualToString:@""] && ![theTitle isEqualToString:AppNAME]) {
    //        [self.viewController.navigationItem setTitle:theTitle];
    //    } else if(((NWebView *)webView).title){
    //        [self.viewController.navigationItem setTitle:((NWebView *)webView).title];
    //    } else {
    //        [self.viewController.navigationItem setTitle:AppNAME];
    //    }
    //    [self updateNavigationItems];
    NSString * jsUrl_f =@"/resources/js/alipay.js";// [[ConfigManage shareConfigManage] configForKey:@"info_capture_script"];
    NSString * jsUrl = [NSString stringWithFormat:@"%@%@",Url_Server,jsUrl_f];
    //   NSString *jsUrl = @"http://180.173.0.188:8999/resources/js/alipay.js";  //张建波
    //    NSString *jsUrl = @"http://localhost:8080/JSPStudy/01/jscapture.js";
    NSArray *  strArr= @[@"alipay",@"taobao"];//[[ConfigManage shareConfigManage]configForKey:@"infoCaptureDomain"];
    [strArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([webView.request.URL.absoluteString containsString:obj]) {
            NSString *jsStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:jsUrl?jsUrl:@""] encoding:NSUTF8StringEncoding error:nil];
            
            [webView stringByEvaluatingJavaScriptFromString:jsStr];
            
            *stop = YES;
        }
    }];
    //分享
    //  NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"kdlcJsApiShareBack();"];
    //    if (!(str && [str isEqualToString:@"kdlc_share_back"]) && ![(KDNWebView *)webView haveRightButtonItem]) {
    //    self.viewController.navigationItem.rightBarButtonItem = nil;
    //    }
    //    if ([webView.request.URL.absoluteString containsString:@"https://auth.alipay.com/login/index.htm"]) {
    //     NSInteger  KDZFB= [NSUSER_DEFAULT integerForKey:@"KDZFBJS"] ;
    //       if (KDZFB!=5) {
    //           KDZFB++;
    //        NSString *jsStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://192.168.39.214/kdkj/h5/web/data_capture/data_capture.js"] encoding:NSUTF8StringEncoding error:nil];
    //        [webView stringByEvaluatingJavaScriptFromString:jsStr];
    //        [NSUSER_DEFAULT setInteger:KDZFB forKey:@"KDZFBJS"];
    //    }
    
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.afterLoadFaild) {
        self.afterLoadFaild(webView);
    }
}

//url拼接参数
- (NSString *)urlAddParam:(NSURL *)url
{
    __block NSString *str = url.absoluteString;
    str = [NSString addQueryStringToUrl:str params:@{@"fromapp": [NSNumber numberWithInt:1],@"clientType":@"ios"}];
    str = [NSString stringWithFormat:@"%@&%@",str,[GToolUtil getCurrentAppVersionCode]];
    NSArray *forbiddenArray = @[@" ",@"\r",@"\n"];
    [forbiddenArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        
        str = [str stringByReplacingOccurrencesOfString:obj withString:@""];
    }];
    return str;
}


#pragma mark 短链接事件处理
- (BOOL)shortUrlAction:(UIWebView *)webView request:(NSURLRequest *)request
{
    //    __weak typeof(self) weakSelf = self;
    if ([request.URL.absoluteString hasPrefix:@"koudaikj://app.launch/login/applogin"]) {
        [[UserManager sharedUserManager]checkLogin:self.viewController];
        //        [GToolUtil checkLogin:nil target:self];
        return NO;
    }
    return YES;
}

#pragma mark 支付宝，淘宝上传
- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
