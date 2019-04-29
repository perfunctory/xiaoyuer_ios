//
//  QQShareManager.m
//  KDLC
//
//  Created by haoran on 16/4/22.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "QQShareManager.h"
#import "KDShareHeader.h"
#import "KDShare.h"
#import "SecurityStrategy.h"
#import "UIImageView+Additions.h"

@interface QQShareManager ()<QQApiInterfaceDelegate,TencentSessionDelegate>

@property(nonatomic,retain)NSString *qqAppID ;
@property(nonatomic,retain)NSString *accessToken;
@property(nonatomic,retain)NSString *openId;
@property(nonatomic,retain)NSDate *expirationDate;
@property(nonatomic,retain)TencentOAuth *auth;

@end


@implementation QQShareManager

+(QQShareManager *)shareInstance
{
    static dispatch_once_t predicate;
    static QQShareManager *sharedManager = nil;
    dispatch_once(&predicate, ^{
        sharedManager = [[QQShareManager alloc]init];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sharedManager.auth = [[TencentOAuth alloc]initWithAppId:QQAppID andDelegate:(id)self];
//        });
    });
    return sharedManager;
}

//判断qq是否安装
+(BOOL)isQQInstalled
{
    return [QQApiInterface isQQInstalled];
}

+(BOOL)qqHandleOpenURL:(NSURL *)url delegate:(id<QQApiInterfaceDelegate>)delegate
{
    return  [QQApiInterface handleOpenURL:url delegate:delegate];
}

//带回调的分享
- (void)shareToQQWithShareContent:(KDShare *)share andWithType:(NSInteger)type withCallBackBlock:(qqCallBack)callback
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"share"ofType:@"jpg"];
    NSData *imgData = [NSData dataWithContentsOfFile:imagePath];
    
    QQApiNewsObject *new = [QQApiNewsObject objectWithURL:[NSURL URLWithString:share.shareUrl] title:share.shareTitle description:share.shareContent previewImageData:imgData ];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:new];
    if (type==3) {
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        NSLog(@"qqResult:>>>>>>>%d",sent);
    }else
    {
        QQApiSendResultCode sent =  [QQApiInterface SendReqToQZone:req];
        NSLog(@"qqZoneResult:>>>>>>>%d",sent);
    }
    self.callBack = [callback copy];
}
#pragma mark - 新增QQ分享接口  
- (void)shareToQQNewWithShareContent:(KDShareEntity *)entity andWithType:(NSInteger)type withCallBackBlock:(qqCallBack)callback
{
    NSData *data;
    if (![entity.share_logo isEqualToString:@"share.jpg"]) {
        if (UIImagePNGRepresentation([UIImageView cacheImageWithURL:entity.share_logo])) {
            data = UIImagePNGRepresentation([UIImageView cacheImageWithURL:entity.share_logo]);
        }else
        {
            data = UIImageJPEGRepresentation([UIImageView cacheImageWithURL:entity.share_logo], 1);
        }
    } else {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"share"ofType:@"jpg"];
        data = [NSData dataWithContentsOfFile:imagePath];
    }
    QQApiNewsObject *new = [QQApiNewsObject objectWithURL:[NSURL URLWithString:entity.share_url] title:entity.share_title description:entity.share_body previewImageData:data ];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:new];
    if (type==3) {
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        NSLog(@"qqResult:>>>>>>>%d",sent);
    }else
    {
        QQApiSendResultCode sent =  [QQApiInterface SendReqToQZone:req];
        NSLog(@"qqZoneResult:>>>>>>>%d",sent);
    }
    self.callBack = [callback copy];
}

//qq授权
- (void)qqauthrize
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"1"ofType:@"jpg"];
    NSData *imgData = [NSData dataWithContentsOfFile:imagePath];
    
    QQApiNewsObject *new = [QQApiNewsObject objectWithURL:[NSURL URLWithString:@"http://www.baidu.com"] title:@"测试QQ" description:@"分享到qq" previewImageData:imgData ];
    uint64_t cflag = 1;
    [new setCflag:cflag];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:new];
    QQApiSendResultCode code =  [QQApiInterface sendReq:req];
    NSLog(@"%d",code);
}
-(BOOL)isLogin
{
    if (self.accessToken&&0!=self.accessToken.length&&self.openId&&![self isExpirationDate]) {
        return YES;
    }else
    {
        return NO;
    }
}
- (BOOL)isExpirationDate
{
    if (self.expirationDate) {
        
        NSDate *now = [NSDate date];
        return ([now compare:self.expirationDate] == NSOrderedDescending);
    }else
    {
        return YES;
    }
}
#pragma mark - 授权回调  暂时不用
#pragma mark -TencentSessionDelegate
- (void)tencentDidLogin
{
    
    if (_auth.accessToken && 0 != [_auth.accessToken length]){
        //  记录登录用户的OpenID、Token以及过期时间
        
        self.accessToken = _auth.accessToken;
        self.openId = _auth.openId;
        self.expirationDate = _auth.expirationDate;
        
    }else{
        
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(shared) userInfo:nil repeats:NO];
    
    UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:@"提示" message:@"授权成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
/**
 * @description 存储QQ认证信息
 */
- (void)qqStoreAuthData:(TencentOAuth *)author
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              author.accessToken, @"accessToken",
                              author.expirationDate, @"expirationDate",
                              author.openId, @"openId", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"QQAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)shared
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"share"ofType:@"jpg"];
    NSData *imgData = [NSData dataWithContentsOfFile:imagePath];
    QQApiNewsObject *new = [QQApiNewsObject objectWithURL:[NSURL URLWithString:@"http://www.baidu.com"] title:@"测试QQ" description:@"分享到qq" previewImageData:imgData ];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:new];
    [QQApiInterface sendReq:req];
}
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    NSString *str;
    if (cancelled){
        str = @"用户取消登录";
    }else{
        str = @"登录失败";
    }
}

-(void)tencentDidNotNetWork
{

}
#pragma mark - QQApiInterfaceDelegate

- (void)onResp:(QQBaseResp *)resp
{
    [SecurityStrategy removeBlurEffect];
    /**
     *  QQ回调
     */
    if ([resp isKindOfClass:[SendMessageToQQResp class]])
    {
        self.callBack(resp);
    }
    
}
- (void)onReq:(QQBaseReq *)req
{
}
- (void)isOnlineResponse:(NSDictionary *)response
{
}

@end
