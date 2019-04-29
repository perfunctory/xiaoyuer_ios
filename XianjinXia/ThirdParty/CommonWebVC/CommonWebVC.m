//
//  CommonWebVC.m
//  Daidaibao
//
//  Created by FengDongsheng on 16/4/20.
//  Copyright © 2016年 FengDongsheng. All rights reserved.
//

#import "CommonWebVC.h"
#import "UserManager.h"
#import "DSUtils.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "NSString+Url.h"
#import "NSString+GetParam.h"
#import "KDShareEntity.h"
#import "KDShareManager.h"
#import "MeRequest.h"
#import "MeModel.h"
#import "MessageTool.h"

@interface CommonWebVC()<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) UIWebView     *wvMainWeb;
@property (nonatomic)UIBarButtonItem* closeButtonItem;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic)NJKWebViewProgress* progressProxy;
@property (nonatomic)NJKWebViewProgressView* progressView;
@property (nonatomic, strong) UIBarButtonItem *rightBarItem;
//是否可越界滑动（默认不可越界）
@property (assign, nonatomic) BOOL canScroll;
@property (nonatomic, strong) MeRequest     * request;
@property (nonatomic, strong) MeModel * meModel;
@property (nonatomic, strong) UIBarButtonItem * shareBtn;
@property (nonatomic, strong) NSMutableURLRequest *requestMessage;
@end

@implementation CommonWebVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    _progressViewColor = Color_White;
    [self.navigationController.navigationBar addSubview:self.progressView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
    [_from isEqualToString:@"home"]?([[NSNotificationCenter defaultCenter]postNotificationName:@"isUpdate" object:nil]):(nil);
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![self.strAbsoluteUrl isEmptyOrWhitespace] && [self.strAbsoluteUrl containsString:@"lnkj/goto_sign"]) {
        __weak __typeof(self)weakSelf = self;
        !weakSelf.getAgreementStatus ? : weakSelf.getAgreementStatus();//获取合同签名状态
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    //防止webview内存泄露
    if (_topWebView) {
        [_topWebView loadHTMLString:@"" baseURL:nil];
        [_topWebView stopLoading];
        _topWebView.delegate = nil;
        [_topWebView removeFromSuperview];
    }

    [self.wvMainWeb loadHTMLString:@"" baseURL:nil];
    [self.wvMainWeb stopLoading];

    self.wvMainWeb.delegate = nil;
   
    
    [self.wvMainWeb removeFromSuperview];
}

#pragma mark - View创建与设置
- (void)setUpView{
    self.navigationItem.title = self.strTitle;
//    [self baseSetup:PageGobackTypePop];
    
    //创建视图等
    self.navigationItem.leftBarButtonItem = self.backItem;
    __weak __typeof(self)weakSelf = self;
    self.delegate.afterLoadFinish = ^(UIWebView * webView) {
        [weakSelf updateNavigationItems];
        NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if (theTitle && ![theTitle isEqualToString:@""] && ![theTitle isEqualToString:APP_NAME]) {
            [weakSelf.navigationItem setTitle:theTitle];
        }
        if ([theTitle isEqualToString:@"页面找不到"]) {
            //清除UIWebView的缓存
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            NSURLCache * cache = [NSURLCache sharedURLCache];
            [cache removeAllCachedResponses];
            [cache setDiskCapacity:0];
            [cache setMemoryCapacity:0];
        }
        
        if ([theTitle isEqualToString:@"Page Not Found"]) {
            !weakSelf.isAgreementSignErr ? : weakSelf.isAgreementSignErr();
        }
        
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        context[@"shareMethod"] = ^() {
            [weakSelf getShareData];
            weakSelf.navigationItem.rightBarButtonItem = weakSelf.shareBtn;
        };
        NSString * webUrl = webView.request.URL.absoluteString;
        if ([webUrl rangeOfString:@"awardCenter/drawAwardIndex"].location != NSNotFound || [webUrl rangeOfString:@"share"].location != NSNotFound || [webUrl rangeOfString:@"gotoJujiuSong"].location != NSNotFound) {
            [weakSelf getShareData];
            weakSelf.navigationItem.rightBarButtonItem = weakSelf.shareBtn;
        }
    };
    
    self.delegate.afterLoadFaild = ^(UIWebView * webView){
        !weakSelf.isAgreementSignErr ? : weakSelf.isAgreementSignErr();
    };
    
    self.delegate.startLoadWithRequest = ^(UIWebView *webView,NSURLRequest *request,UIWebViewNavigationType type) {
//        NSLog(@"%@",request.URL.absoluteString);
       
        if ([request.URL.absoluteString hasPrefix:@"www.mobileApprove.com&result=YES"]) {
            [weakSelf showMessage:@"认证成功"];
            if (weakSelf.blockChoose) {
                [weakSelf performSelector:@selector(delayPost) withObject:nil afterDelay:1];
            }else{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            return NO;
        }else  if ([request.URL.absoluteString hasSuffix:@"www.mobileApprove.com&result=NO"]) {
            [weakSelf showMessage:@"认证失败"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            return NO;
        }else if ([request.URL.absoluteString rangeOfString:@"www.moreInfo.com"].location != NSNotFound) {
//            [weakSelf showMessage:@"认证成功"];
             [weakSelf performSelector:@selector(popVC) withObject:nil afterDelay:1];
            return NO;
        }else if ([request.URL.absoluteString rangeOfString:@"www.bindcardinfo.com"].location != NSNotFound) {
//            [weakSelf showMessage:@"操作完成"];
            [weakSelf performSelector:@selector(popNactive) withObject:nil afterDelay:1];
            !weakSelf.bindBankcardSuccess ? : weakSelf.bindBankcardSuccess();//绑定银行成功回调
            return NO;
        }else  if ([request.URL.absoluteString rangeOfString:@"www.mobileApprove.com&result=YES"].location !=NSNotFound){
            NSDictionary *dict = [weakSelf splitUrlStringToDictionary:request.URL.absoluteString];
            if ([[dict allKeys]containsObject:@"message"]) {
                NSString *str = dict[@"message"];
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"?"];
                str = [[str componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString:@""];
                [weakSelf showMessage:str];
                if (weakSelf.blockChoose) {
                    [weakSelf performSelector:@selector(delayPost) withObject:nil afterDelay:1];
                }else{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }else{
                [weakSelf showMessage:@"认证成功"];
                if (weakSelf.blockChoose) {
                    [weakSelf performSelector:@selector(delayPost) withObject:nil afterDelay:1];
                }
            }
            return NO;
        }else  if ([request.URL.absoluteString rangeOfString:@"www.iosMessage.com"].location !=NSNotFound){
            NSString *strUrl = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSArray *urlComponents =[strUrl  componentsSeparatedByString:@"&"];
            if (urlComponents.count>=3) {
                NSString *strContent = urlComponents[1];
                strContent =   [strContent stringByReplacingOccurrencesOfString:@"?" withString:@""];
                NSString *strPhone = urlComponents[2];
                
                if (!weakSelf.requestMessage) {
                weakSelf.requestMessage = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:weakSelf.strAbsoluteUrl]];
                }
                [weakSelf.wvMainWeb loadRequest:weakSelf.requestMessage];
                
                [[MessageTool sharedManager]sendMessagePhone:strPhone withMessageContent:strContent];
                            NSLog(@"%@",urlComponents);
            }
//            NSDictionary *dict = [weakSelf splitUrlStringToDictionary:];

        } else if ([request.URL.absoluteString rangeOfString:@"www.iosPhone.com"].location !=NSNotFound) {
            NSString *strUrl = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *urlComponents =[strUrl  componentsSeparatedByString:@"&"];
            if (urlComponents.count>=2) {
//                NSString *strContent = urlComponents[0];
                NSString *strPhone = urlComponents[1];
                NSString *phone = [strPhone stringByReplacingOccurrencesOfString:@"?" withString:@""];
                [weakSelf alert:phone];
            }
            return NO;
        } else if ([request.URL.absoluteString rangeOfString:@"www.xxxx.com"].location != NSNotFound) {
            [weakSelf popNactive];
            return NO;
        } else if ([request.URL.absoluteString rangeOfString:@"www.registerQimo.com"].location != NSNotFound) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"registerQimo" object:nil];
            return NO;
        }
        [weakSelf updateNavigationItems];
        return YES;
    };
    
    //进入支付宝爬数据
    if ([_strType isEqualToString:@"ZFB"]) {
        NWebView * webview = [[NWebView alloc] initWithFrame:self.view.bounds];
        webview.delegate = self.progressProxy;
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_strAbsoluteUrl]]];
        webview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [webview setBackgroundColor:[UIColor whiteColor]];
        [webview setUserInteractionEnabled:YES];
        [webview setMultipleTouchEnabled:YES];
        [webview setScalesPageToFit:YES];     //yes:根据webview自适应，NO：根据内容自适应
        
        webview.scrollView.bounces = _canScroll;
        webview.uid = [[UserManager sharedUserManager].userInfo.uid integerValue];
        webview.title = self.navTitle;
//        webview.haveRightButtonItem = self.rightBarButtonItem || self.rightBarButtonItems;
//        [self.webViewArray addObject:webview];
        
        self.topWebView = webview;
        [self.view addSubview:self.topWebView];
    }else{
        _wvMainWeb = [[UIWebView alloc] initWithFrame:self.view.bounds];
        self.wvMainWeb.delegate = self.progressProxy;
        self.wvMainWeb.scalesPageToFit = YES;
        self.wvMainWeb.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.wvMainWeb];
    
    }
}

#pragma mark - 初始化数据源
- (void)setStrTitle:(NSString *)strTitle{
    _strTitle = strTitle;
    self.navigationItem.title = _strTitle;
}

- (void)setStrAbsoluteUrl:(NSString *)strAbsoluteUrl{
    if (!strAbsoluteUrl || [strAbsoluteUrl isEqualToString:@""]) {
        _strAbsoluteUrl = @"http://api.miledai.net";
    } else {
        _strAbsoluteUrl = strAbsoluteUrl;
    }
    _strAbsoluteUrl = [NSString addQueryStringToUrl:_strAbsoluteUrl params:@{@"appName":@"mld",@"fromapp": [NSNumber numberWithInt:1],@"clientType":@"ios",@"deviceId":[DSUtils getUUIDString],@"mobilePhone":DSStringValue([UserManager sharedUserManager].userInfo.username), @"appVersion":CurrentAppVersion}];
    _strAbsoluteUrl = [_strAbsoluteUrl urlClear];
    [self loadData];
}

- (void)setStrHtmlBody:(NSString *)strHtmlBody{
    _strHtmlBody = strHtmlBody;
    [self.wvMainWeb loadHTMLString:_strHtmlBody baseURL:nil];
}

-(void)setProgressViewColor:(UIColor *)progressViewColor{
    _progressViewColor = progressViewColor;
    self.progressView.progressColor = progressViewColor;
}

- (void)setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
}

#pragma mark - 点击事件

// 呼叫客服电话
- (void)alert:(NSString *)phone {
    
    NSString *phone1 = [NSString stringWithFormat:@"telprompt://%@", phone];
    NSURL *phoneU = [NSURL URLWithString:phone1];
    if (IOS_VERSION >= 10) {
        [[UIApplication sharedApplication] openURL:phoneU options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:phoneU];
    }
}

- (void)goShare {
    if ([[UserManager sharedUserManager] checkLogin:self]) {
        if (self.meModel == nil) {
            return;
        }
        [self share];
    }
}
- (void)share {
    KDShareEntity *entitys = [KDShareEntity yy_modelWithDictionary:@{
                                                                     @"shareBtnTitle":@"分享",
                                                                     @"isShare":@"1",
                                                                     @"share_title":self.meModel.share_title ? self.meModel.share_title : @"",
                                                                     @"share_body":self.meModel.share_body ? self.meModel.share_body :@"",
                                                                     @"share_logo":self.meModel.share_logo ? self.meModel.share_logo :@"",
                                                                     @"sharePlatform":@[@"wx",@"wechatf",@"qq",@"qqzone"],
                                                                     @"share_url":self.meModel.share_url ? self.meModel.share_url : @""}];
    [[KDShareManager shareManager]showWithShareEntity:entitys];
}

#pragma mark - 请求数据
- (void)getShareData {
    [self.request getUserInfoWithDict:nil onSuccess:^(NSDictionary *dictResult) {
        self.meModel = [MeModel yy_modelWithDictionary:dictResult[@"item"]];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"您的登录态已失效，请重新登录" leftButtonTitle:nil rightButtonTitle:@"确定"];
        alert.rightBlock = ^{
            [[UserManager sharedUserManager] checkLogin:self];
        };
        [alert show];
    }];
}

#pragma mark - Delegate


-(void)delayPost{
    [self.navigationController popViewControllerAnimated:YES];
    self.blockChoose();
}

- (NSDictionary*)splitUrlStringToDictionary:(NSString*)strUrl{
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSRange range = [strUrl rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return queryStringDictionary;
    }
    NSArray *urlComponents = [[strUrl substringFromIndex:(range.location + range.length)] componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents){
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"-"];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        [queryStringDictionary setObject:value forKey:key];
    }
    return queryStringDictionary;
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:NO];
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    if (progress ==1.0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}


#pragma mark - 请求数据
//加载网页
- (void)loadData{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.strAbsoluteUrl]];
    [self.wvMainWeb loadRequest:request];
}

#pragma mark - Other

- (void)updateNavigationItems {
    
    //使navigation顶端左右iteam更加靠近边框位置
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -5;
    
    if (self.wvMainWeb.canGoBack) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.backItem,self.closeButtonItem] animated:NO];
    }else{
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.backItem]];
    }
}

//关闭H5页面，直接回到原生页面
- (void)popNactive {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 判断   需要直接pop VC  还是  返回上一级web链接
 */
- (void)popVC{
    if ([_strType isEqualToString:@"ZCXY"]||[_strType isEqualToString:@"XYXY"]) {
    [self dismissVC];
        return;
    }
    if ([self.wvMainWeb canGoBack]) {
        [self.wvMainWeb goBack];
    }else {
        [self popNactive];
    }

}
#pragma mark - 懒加载返回对应对象 -
- (MeRequest *)request{
    if (!_request) {
        _request = [[MeRequest alloc] init];
    }
    return _request;
}

- (UIBarButtonItem *)shareBtn {
    if (!_shareBtn) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"分享" forState:normal];
        [button addTarget:self action:@selector(goShare) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.titleLabel.font = Font_Title;
        [button setTitleColor:Color_White forState:normal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _shareBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _shareBtn;
}

-(UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(popNactive)];
        [_closeButtonItem setTintColor:Color_White];
    }
    return _closeButtonItem;
}

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:ImageNamed(@"navigationBar_popBack") forState:UIControlStateNormal];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.frame = CGRectMake(-5, 0, 16, 16);
        _backItem.customView = btn;
    }
    return _backItem;
}

-(NJKWebViewProgressView *)progressView{
    if (!_progressView) {
        CGFloat progressBarHeight = 2.0f;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.progressColor = self.progressViewColor;
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _progressView;
}

-(NJKWebViewProgress *)progressProxy{
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = self.delegate;
        _progressProxy.progressDelegate = (id)self;
    }
    return _progressProxy;
}

- (NWebViewDelegate *)delegate
{
    if (!_delegate) {
        _delegate = [NWebViewDelegate new];
        _delegate.viewController = self;
    }
//    _delegate.shareData = _shareData;
    return _delegate;
}

@end
