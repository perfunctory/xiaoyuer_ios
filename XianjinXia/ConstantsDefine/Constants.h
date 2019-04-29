//
//  Constants.h
//  EveryDay
//
//  Created by FengDongsheng on 15/7/2.
//  Copyright (c) 2015年 FengDongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//侧边距
extern CGFloat    const kPaddingLeft;
//上边距
extern CGFloat    const kPaddingTop;
//textfield 高度
extern CGFloat    const kTextFieldHeight;
//按钮高度
extern CGFloat    const kButtonHeight;
//分割线高度
extern CGFloat    const kSeparatorHeight;
//view距顶部距离
extern CGFloat    const kViewTop;

//通知
extern NSString * const kNotificationNeedLogin;     //需要用户登录

//错误描述
extern NSString * const kErrorUnknown;

//http请求方式
extern NSString * const kHttpRequestPost;
extern NSString * const kHttpRequestGet;


//其他常量
extern NSString * const kSouyijieURL;//搜易借落地页注册
extern NSString * const kBuglyAppId;//buglyId

extern NSString * const kQiMoAppKey;//七陌客服

//友盟统计
extern NSString * const kUmengAppKey ;

//appstore 跳转地址
extern NSString * const kAppStoreUrl ;

//服务器地址
extern NSString *       Url_Server;

@end
