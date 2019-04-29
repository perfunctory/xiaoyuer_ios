//
//  ChangePasswordVC.h
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SecondLevelViewController.h"
typedef enum {
    loginChange,
    payChange
}PasswordType;

@interface ChangePasswordVC : SecondLevelViewController<UITextFieldDelegate>

@property(nonatomic,assign)PasswordType passwordType;

@end
