//
//  FindPayPassWordVC.h
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SecondLevelViewController.h"

typedef enum {
    loginPay,
    payPay
}ForgetPayType;

@interface FindPayPassWordVC : SecondLevelViewController

@property(nonatomic,assign)ForgetPayType forgetType;
@property(nonatomic,retain)NSString* phoneNumber;
@property(nonatomic,retain)NSString* isRealName;

@end
