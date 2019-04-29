//
//  SettingVC.h
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SecondLevelViewController.h"
#import "MeModel.h"

@interface SettingVC : SecondLevelViewController

@property (nonatomic, assign) NSInteger real_verify_status;
@property (nonatomic, assign) NSInteger real_pay_pwd_status;
@property (nonatomic,strong) MeModel *meModel;

@end
