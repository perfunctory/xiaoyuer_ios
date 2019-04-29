//
//  Constants.m
//  EveryDay
//  定义常量
//  Created by FengDongsheng on 15/7/2.
//  Copyright (c) 2015年 FengDongsheng. All rights reserved.
//

#import "Constants.h"

@implementation Constants

CGFloat    const kPaddingLeft                           = 15.0f;
CGFloat    const kPaddingTop                            = 5.0f;
CGFloat    const kTextFieldHeight                       = 44.0f;
CGFloat    const kButtonHeight                          = 45.0f;
CGFloat    const kSeparatorHeight                       = 0.5f;
CGFloat    const kViewTop                               = 15.0f;

NSString * const kNotificationNeedLogin                 = @"NotificationNeedLogin";

NSString * const kErrorUnknown                          = @"未知错误";


NSString * const kHttpRequestPost                       = @"post";
NSString * const kHttpRequestGet                        = @"get";

//搜易借  改为   弹溜溜现金贷超市
NSString * const kSouyijieURL                           = @"http://www.tan66.com/?plat=jx&flag=1";//tan66

//腾讯bugly
NSString * const kBuglyAppId                            = @"c31bde45b6";

//七陌客服
NSString * const kQiMoAppKey                            = @"3ae60120-58e4-11e8-b127-dd1aa026841e";

//友盟统计
NSString * const kUmengAppKey                           = @"5c4ea1d4f1f5561d77000811";//@"5a1cd9fb8f4a9d338100015d";

//appstore 跳转地址
NSString * const kAppStoreUrl                           = @"https://itunes.apple.com/cn/app/%E5%80%9F%E4%BA%AB%E9%92%B1%E5%8C%85/id1318157961?mt=8&ign-mpt=uo%3D4";

//服务器地址
//NSString *       Url_Server                             = @"http://api.jx-money.com/"; //正式
//NSString *       Url_Server                             = @"http://apitest.jx-money.com/"; //测试
NSString *       Url_Server                             = @"http://47.97.97.48:8081/"; //测试


@end
