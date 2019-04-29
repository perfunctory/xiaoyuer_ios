//
//  RegisterVC.h
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SecondLevelViewController.h"
typedef NS_ENUM(NSInteger,registerOrForgetPwd){
    registerSec, //注册
    forgetPwd //忘记密码
};
@interface RegisterVC : SecondLevelViewController
@property(nonatomic,retain)NSString* phoneNumber;
@property(nonatomic,retain)NSString* captchaUrl;

- (instancetype)initWithPageType:(registerOrForgetPwd)type;

@end
