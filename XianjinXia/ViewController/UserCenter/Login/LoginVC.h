//
//  LoginVC.h
//  XianjinXia
//
//  Created by lxw on 17/1/23.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SecondLevelViewController.h"

@interface LoginVC : SecondLevelViewController<UITextFieldDelegate>
@property (nonatomic, copy) void (^reLoginSetUserName)(NSString *userName,NSString *tipStr);
@end
