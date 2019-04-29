//
//  NWebView.m
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/20.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "NWebView.h"
#import <MBProgressHUD.h>
#import "UIView+Additions.h"
#import "UIView+Frame.h"
#import "ZFBRequset.h"

//用户信息
static NSString *ZFBPath = @"KDZFB";
@interface NWebView ()
/**
 支付宝数据抓取进度
 */
@property (nonatomic, copy)  NSString  * progress;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) UIButton * stopBtn;

@property (nonatomic, strong) UIView * topView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) NSMutableDictionary  * captureDic;

@property (nonatomic, strong) ZFBRequset *requestZFB;

@end;

@implementation NWebView

- (void)addCookie:(NSDictionary *)param
{
    NSString *name = @"";
    NSString *value = @"";
    NSString *domain = @"";
    NSString *path = @"";
    if (param[@"name"]) {
        name = param[@"name"];
    }
    if (param[@"value"]) {
        value = param[@"value"];
    }
    if (param[@"domain"]) {
        domain = param[@"domain"];
    }
    if (param[@"path"]) {
        path = param[@"path"];
    }
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[NSHTTPCookie cookieWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:value, NSHTTPCookieValue,name,
                                                                                                 NSHTTPCookieName, path , NSHTTPCookiePath, domain, NSHTTPCookieDomain, nil]]];
}

- (void)RefreshAccountList:(NSDictionary *)param{
    
}

- (void)shareMethod:(NSString *)paramStr
{
    NSString *jsonString = [paramStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *param = nil;
    if (jsonData) {
        param = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    }
    DXAlertView * alertV = [[DXAlertView alloc] initWithTitle:@"分享" contentText:@"分享" leftButtonTitle:@"确定" rightButtonTitle:@""];
    [alertV show];
//    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
//        weakSelf.entity = [[KDShareEntity alloc] initWithDic:param];
//        
//        if ([weakSelf.entity.type integerValue] == 1) {
//            weakSelf.viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClick)];
//            
//        } else {
//            [weakSelf shareBtnClick];
//        }
    });
}

- (void)shareMethod {
    DXAlertView * alertV = [[DXAlertView alloc] initWithTitle:@"分享" contentText:@"分享" leftButtonTitle:@"确定" rightButtonTitle:@""];
    [alertV show];
}

- (void)shareBtnClick
{
//    [[KDShareManager shareManager] showWithShareEntity:_entity];
}

- (void)pageJump:(NSDictionary *)param
{
    //  [[KDShortURLJumpManager shareURLJump] jumpWithParam:[[ShortURLJumpEntity alloc] initWithDic:param]];
}

- (void)returnNativeMethod:(NSString *)paramStr
{
    NSString *jsonString = [paramStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *param = nil;
    if (jsonData) {
        NSError *serializationError = nil;
        param = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&serializationError];
        if (serializationError) {
            NSLog(@"%@",serializationError.userInfo);
            return;
        }
    }
}
#pragma mark - 去qq
//- (void)contactQQ
//{
//    BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqqwpa://im/chat?chat_type=crm&uin=938179310&version=1&src_type=web&web_src=file:://"]]];
//    [self performSelector:@selector(alertShow:) withObject:success ? @"1" : @"0" afterDelay:0.5];
//}

//- (void)alertShow:(NSString *)success
//{
//    if ([success isEqualToString:@"0"]) {
//        [[[DXAlertView alloc] initWithTitle:@"" contentText:@"跳转异常，请确认是否安装过qq" leftButtonTitle:nil rightButtonTitle:@"确认"] show];
//    }
//}
#pragma mark - 复制粘贴版
- (void)copyTextMethod:(NSString *)paramStr
{
    NSString *jsonString = [paramStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *param = nil;
    if (jsonData) {
        NSError *serializationError = nil;
        param = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&serializationError];
        if (serializationError) {
            NSLog(@"%@",serializationError.userInfo);
            return;
        }
    }
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    KDPastEntity *entity = [[KDPastEntity alloc]initWithDic:param];
//    if (![entity.text isEqualToString:@""]&&![entity.tip isEqualToString:@""]) {
//        pasteboard.string = entity.text;
//        [[iToast makeText:entity.tip]show];
//    }
    NSLog(@"%@",param);
}

#pragma mark - 支付宝爬虫相关
// Js调用了callSystemCamera
- (void)callSystemCamera {
    NSLog(@"JS调用了OC的方法，调起系统相册");
    
    // JS调用后OC后，又通过OC调用JS，但是这个是没有传参数的
    JSValue *jsFunc = self.js_Context[@"jsFunc_callSystemCamera"];
    [jsFunc callWithArguments:@[@"jsFunc_callSystemCamera传参数"]];
}
//==========支付宝爬虫相关========
//遮罩 liang882288  13949102946
- (void)goneLayout:(NSString *)param
{
    __weak typeof(self) weakSelf = self;
    if (!self.hud) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            weakSelf.hud.backgroundColor=[UIColor grayColor];
            [weakSelf certTopview];
            
        });
    }
    
}
//上报数据
- (void)submitText:(NSString *)param
{
    
//    __weak typeof(self) weakSelf = self;
    NSLog(@"%@",param);
    
    
    NSData  *data = [NSJSONSerialization dataWithJSONObject:_captureDic options:NSJSONWritingPrettyPrinted error:nil ];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    if ([param isEqualToString:@"zhifubao"]) {
        [self upLoadZhifubao_ALIPAYJSESSIONID:jsonString];
//    }else if([param isEqualToString:@"taobao"]) {
////        [self upLoadTaobao_htoken:jsonString];
//    }
    
    
    
    
    return;
    
}
//取缓存
- (NSString *)getText:(NSString *)param
{
    
    return [self getCacheObjectWithKey:param andDirectory:ZFBPath]?[self getCacheObjectWithKey:param andDirectory:ZFBPath]:@"";
}
//缓存
- (void)saveText:(NSString *)param  :(NSString *)text
{
    NSLog(@"%@ %@",param,text);
    
    [self.captureDic setObject:text forKey:param];
    
    [self cacheObject:text withKey:param andDirectory:ZFBPath];
}
//进度条
-(void)setProgress:(NSString *)pararm
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        
        self.hud.label.text = NSLocalizedString(@"验证中,请耐心等待...", @"HUD loading title");
        [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow ].progress = pararm.floatValue/100.f;
        if (pararm.floatValue==100.f) {
            [self.hud hideAnimated:YES];
            
        }
        
    });
}
#pragma mark - 创建假导航栏
-(void)certTopview
{
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 64.f)];
    self.topView.backgroundColor=Color_Red;
    [self.hud addSubview:self.topView];
    
    self.stopBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    self.stopBtn.frame=CGRectMake(0, 22, 36, 36);
    [self.stopBtn setImage:[UIImage imageNamed:@"webview_back"] forState:UIControlStateNormal];
    [self.topView addSubview:self.stopBtn];
    [self.stopBtn addTarget:self action:@selector(stopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.hud.centerX-60.f, 24.f, 160.f, 30.f)];
    self.titleLabel.text=@"支付宝数据验证";
    self.titleLabel.textColor=[UIColor whiteColor];
    [self.topView addSubview:self.titleLabel];
}
-(void)stopBtnClick
{
    __weak typeof(self) weakSelf = self;
    DXAlertView * alerView=[[DXAlertView alloc]initWithTitle:@"提示" contentText:@"返回操作将中断支付宝认证,确认要退出吗？"leftButtonTitle:@"继续认证" rightButtonTitle:@"取消认证" buttonType:LeftGray];
    DXAlertView * __block alerView1= alerView;
    [alerView show];
    alerView.rightBlock=^(){
        [weakSelf.viewController.navigationController popViewControllerAnimated:YES];
        weakSelf.hud.hidden=YES;
        [weakSelf.hud removeFromSuperview];
    };
    alerView.leftBlock=^(){
        alerView1.hidden=YES;
    };
    
}
#pragma mark - 上报支付宝爬虫信息(英科)
//上报支付宝爬虫信息(英科)
- (void)upLoadZhifubao_ALIPAYJSESSIONID:(NSString *)param
{
    [self.requestZFB ZFBWithDict:@{@"data":param} onSuccess:^(NSDictionary *dictResult) {
                DXAlertView * alerView=[[DXAlertView alloc]initWithTitle:@"提示" contentText: dictResult[@"message"] leftButtonTitle:nil rightButtonTitle:@"确定"];
                [alerView show];
                alerView.rightBlock=^(){
                    //    UIViewController *vc = self.viewController;
                    [self.viewController.navigationController popViewControllerAnimated:YES];
                };
    } andFailed:^(NSInteger code, NSString *errorMsg) {
                DXAlertView * alerView=[[DXAlertView alloc]initWithTitle:@"提示" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
                [alerView show];
                alerView.rightBlock=^(){
                    [self.viewController.navigationController popViewControllerAnimated:YES];
                };
    }];
}
////上报TaoBao宝爬虫信息(英科)
//- (void)upLoadTaobao_htoken:(NSString *)param
//{
//    __weak typeof(self) weakSelf = self;
//    self.upRequest = [[KDBaseRequestNew alloc]initWithURLKey:kTaobaoUpKeyYK method:HttpRequestMethodPOST param:@{@"data":param}];
//    
//    [self.upRequest loadDataWithSuccess:^(NSDictionary *data) {
//        // [[iToast makeText:data[@"data"][@"message"]]show];
//        DXAlertView * alerView=[[DXAlertView alloc]initWithTitle:@"提示" contentText: data[@"data"][@"message"] leftButtonTitle:nil rightButtonTitle:@"确定"];
//        [alerView show];
//        alerView.rightBlock=^(){
//            [weakSelf.viewController.navigationController popViewControllerAnimated:YES];
//        };
//        
//    } falid:^(NSString *msg) {
//        // [[iToast makeText:msg]show];
//        DXAlertView * alerView=[[DXAlertView alloc]initWithTitle:@"提示" contentText:msg leftButtonTitle:nil rightButtonTitle:@"确定"];
//        [alerView show];
//        alerView.rightBlock=^(){
//            [weakSelf.viewController.navigationController popViewControllerAnimated:YES];
//        };
//        
//    }];
//    
//}

#pragma mark - lazy
- (NSMutableDictionary *)captureDic{
    if (!_captureDic) {
        _captureDic = [NSMutableDictionary dictionary];
    }
    return _captureDic;
}

//新增根据目录来取
- (id)getCacheObjectWithKey:(NSString *)key andDirectory:(NSString *)path{
    if (!key || [key isEqualToString:@""]) {
        NSLog(@"缓存key不能为空！！");
        return nil;
    }
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:[self getPathWithKey:key andDicretory:path]];
    if (data && ![data isKindOfClass:[NSNull class]]) {
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        return [unArchiver decodeObjectForKey:[NSString stringWithFormat:@"%@shyy",key]];
    }
    return nil;
}

- (NSString *)getPathWithKey:(NSString *)key{
    return [NSString stringWithFormat:@"%@/%@.kdlc",[self getPath],key];
}

- (NSString *)getPath{
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/userKDLC"];
    NSLog(@"local cache path:%@------------",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
//新增
- (NSString *)getPathWithKey:(NSString *)key andDicretory:(NSString *)directory{
    return [NSString stringWithFormat:@"%@/%@.kdlc",[self getPathWithDirectory:directory],key];
}

//新增
- (NSString *)getPathWithDirectory:(NSString *)directory
{
    NSString *tempPath = [@"/Documents/" stringByAppendingString:[NSString stringWithFormat:@"%@",directory]];
    NSString *path = [NSHomeDirectory() stringByAppendingString:tempPath];
    NSLog(@"local cache path:%@------------",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

////新增根据目录来缓存
- (void)cacheObject:(id<NSCoding>)object withKey:(NSString *)key andDirectory:(NSString *)path
{
    if (!key || [key isEqualToString:@""]) {
        NSLog(@"缓存key不能为空！！");
        return;
    }
    if (object) {
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:object forKey:[NSString stringWithFormat:@"%@shyy",key]];
        [archiver finishEncoding];
        [data writeToFile:[self getPathWithKey:key andDicretory:path] atomically:YES];
    }
    
}

-(ZFBRequset *)requestZFB{
    if (!_requestZFB) {
        _requestZFB = [ZFBRequset new];
    }
    return _requestZFB;
}

@end
