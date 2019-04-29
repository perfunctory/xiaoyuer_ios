//
//  LoginSecVC.h
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SecondLevelViewController.h"
/*
    该VC表示,用户输入的手机号,在平台已经注册
 */
@interface LoginSecVC : SecondLevelViewController
@property (nonatomic, copy) void (^reLoginSetUserName)(NSString *userName);
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *tipStr;
@end
