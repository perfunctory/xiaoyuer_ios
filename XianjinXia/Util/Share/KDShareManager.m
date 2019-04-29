//
//  KDShareManager.m
//  KDLC
//
//  Created by haoran on 16/6/2.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "KDShareManager.h"
#import "WXShareManager.h"
#import "QQShareManager.h"
#import "KDShareEntity.h"
#import "KDShareBounceView.h"
#import "KDShareFloatWindow.h"
#import <MessageUI/MessageUI.h>
#import "KDShare.h"
#import "UserManager.h"
#import "UIImageView+Additions.h"
#import "KDShareFloatWindow.h"
@interface KDShareManager ()<KDShareBounceDelegate>
//分享的数据
@property (nonatomic, retain) KDShareEntity *entity;
//分享展示框
@property (nonatomic, retain) KDShareBounceView *shareView;
//分享平台
@property (nonatomic, retain) NSArray *titleArr;
@property (nonatomic, retain) NSArray *imageArr;
//分享上报的渠道
@property (nonatomic, retain) NSString *platform;
//上报
//@property (nonatomic, retain) KDBaseRequestNew *request;
//邀请发送短信
//@property (nonatomic, retain) KDBaseRequestNew *inviteRequest;

@end


@implementation KDShareManager

- (instancetype)init
{
  if (self = [super init]) {
    self.platform = @"";
  }
  return self;
}

+ (instancetype)shareManager
{
  static dispatch_once_t once;
  static KDShareManager *shareManager = nil;
  dispatch_once(&once, ^{
    shareManager = [[KDShareManager alloc]init];
  });
  return shareManager;
}

- (void)showWithShareEntity:(KDShareEntity *)entity
{
  self.entity = entity;
  //分享渠道处理
  NSMutableArray *imgArray = [@[@"wechat",@"wechatf",@"qq",@"qqzone"] mutableCopy];
  NSMutableArray *titleArray = [@[@"微信",@"微信朋友圈",@"QQ",@"QQ空间"] mutableCopy];
  
  if (entity.sharePlatform.count > 0) {
    [imgArray removeAllObjects];
    [titleArray removeAllObjects];
    
    [entity.sharePlatform enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
      //添加微信渠道
      if ([obj isEqualToString:@"wx"]) {
        [imgArray addObject:@"wechat"];
        [titleArray addObject:@"微信"];
      }
      //添加朋友圈渠道
      if ([obj isEqualToString:@"wechatf"]) {
        [imgArray addObject:@"wechatf"];
        [titleArray addObject:@"微信朋友圈"];
      }
      
      //添加qq渠道
      if ([obj isEqualToString:@"qq"]) {
        [imgArray addObject:@"qq"];
        [titleArray addObject:@"QQ"];
      }
      //添加qq空间渠道
      if ([obj isEqualToString:@"qqzone"]) {
        [imgArray addObject:@"qqzone"];
        [titleArray addObject:@"QQ空间"];
      }
    }];
  }
  self.titleArr = [titleArray mutableCopy];
  self.imageArr = [imgArray mutableCopy];
  
  self.shareView = [[KDShareBounceView alloc]initWithTitleArray:self.titleArr ImageArray:self.imageArr ActivityName:entity.sharePageTitle Delegate:self];
  [self.shareView show];
  
}

#pragma mark - 点击代理事件
- (void)KDShareButtonAction:(NSInteger)buttonIndex
{
  
  if ([_imageArr[buttonIndex] isEqualToString:@"wechat"]) {
    _platform = @"1";
    [self wxShare];
    return;
  }else if ([_imageArr[buttonIndex] isEqualToString:@"wechatf"])
  {
    _platform = @"2";
    [self wxZoneShare];
    return;
  }else if ([_imageArr[buttonIndex] isEqualToString:@"qq"])
  {
    _platform = @"3";
    [self qqShare];
    return;
  }else if ([_imageArr[buttonIndex] isEqualToString:@"qqzone"])
  {
    _platform = @"4";
    [self qqZoneShare];
    return;
  }
}

#pragma mark - 微信分享
- (void)wxShare
{
  if ([WXShareManager isWXAppInstalled]) {
    [[WXShareManager shareInstance]shareToWXNewWithShare:self.entity withType:0 withCallBackBlock:^(BaseResp *resp) {
      if (resp) {
        if (resp.errCode == 0) {
          [self.shareView TapCancelAction];
          [self postUp];
        }
      }
    } ];
  }else
  {
    DXAlertView *alertView = [[DXAlertView alloc]initWithTitle:@"" contentText:@"未安装微信客户端 !" leftButtonTitle:nil rightButtonTitle:@"确定"];
    [alertView show];
  }
  
}

#pragma mark - 微信盆友圈分享
- (void)wxZoneShare
{
  if ([WXShareManager isWXAppInstalled]) {
    [[WXShareManager shareInstance]shareToWXNewWithShare:self.entity withType:1 withCallBackBlock:^(BaseResp *resp) {
      if (resp) {
        if (resp.errCode == 0) {
          [self.shareView TapCancelAction];
          [self postUp];
        }
      }
    } ];
  }else
  {
    DXAlertView *alertView = [[DXAlertView alloc]initWithTitle:@"" contentText:@"未安装微信客户端 !" leftButtonTitle:nil rightButtonTitle:@"确定"];
    [alertView show];
  }
}

#pragma mark - QQ分享
- (void)qqShare
{
  if ([QQShareManager isQQInstalled]) {
    [[QQShareManager shareInstance]shareToQQNewWithShareContent:self.entity andWithType:3 withCallBackBlock:^(QQBaseResp *resp) {
      SendMessageToQQResp * sendQQResp = (SendMessageToQQResp *)resp;
      if ([sendQQResp.result isEqualToString:@"0"])
      {
        [self postUp];
        [self.shareView TapCancelAction];
      }
    }];
    
  }else
  {
    DXAlertView *alertView = [[DXAlertView alloc]initWithTitle:@"" contentText:@"未安装QQ客户端 !" leftButtonTitle:nil rightButtonTitle:@"确定"];
    [alertView show];
  }
}
#pragma mark - QQ空间分享
- (void)qqZoneShare
{
  if ([QQShareManager isQQInstalled]) {
    [[QQShareManager shareInstance]shareToQQNewWithShareContent:self.entity andWithType:4 withCallBackBlock:^(QQBaseResp *resp) {
      SendMessageToQQResp * sendQQResp = (SendMessageToQQResp *)resp;
      if ([sendQQResp.result isEqualToString:@"0"])
      {
        [self postUp];
        [self.shareView TapCancelAction];
      }
    }];
  }else
  {
    DXAlertView *alertView = [[DXAlertView alloc]initWithTitle:@"" contentText:@"未安装QQ客户端 !" leftButtonTitle:nil rightButtonTitle:@"确定"];
    [alertView show];
  }
}


#pragma mark - 我的邀请
- (void)smsInvite
{
  [self.shareView TapCancelAction];
 }



- (void)postUp
{
  if (self.entity.block && ![[NSString stringWithFormat:@"%@",self.entity.block] isEqualToString:@""]) {
    self.entity.block();
  }
  if ([UserManager sharedUserManager].isLogin) {
    if ([self.entity.shareIsUp integerValue] == 1) {
//      [self.request loadDataWithSuccess:^(NSDictionary *data) {
//        if (data[@"code"] && [data[@"code"] isEqual:@(0)]) {
//          NSLog(@"分享上报成功");
//          NSString *shareTitle = @"分享成功";
//          if (data[@"message"]) {
//            if (![data[@"message"]isEqualToString:@""]) {
//              shareTitle = [shareTitle stringByAppendingString:[NSString stringWithFormat:@"\n%@",data[@"message"]]];
//            }
//          }
//          [[KDShareFloatWindow makeText:shareTitle] show];
//        }else
//        {
//          if (data[@"message"]&&[data[@"message"]isKindOfClass:[NSString class]]) {
//            [[iToast makeText:data[@"message"]]show];
//          }
//        }
//      } falid:^(NSString *msg) {
//        [[iToast makeText:msg]show];
//      }];
    }else
    {
      [[KDShareFloatWindow makeText:[NSString stringWithFormat:@"分享成功"]] show];
    }
  }
}
@end
