//
//  KDPayPasswordView.h
//  KDLC
//
//  Created by 闫涛 on 15/3/5.
//  Copyright (c) 2015年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,moneyType){
    borrow,
    repay
};

@interface KDPayPasswordView : UIView <UITextFieldDelegate>


@property (nonatomic, retain) NSString *projectName;
@property (nonatomic, retain) NSString *payMoneyNum;

@property (nonatomic, retain) NSString *bankInfoStr;
@property (nonatomic, copy) void (^allPasswordPut)(NSString *password);
@property (nonatomic, retain) UITextField *textfield;       //隐藏的密码输入框
- (instancetype)initWithFrame:(CGRect)frame type:(moneyType)type;

- (void)refreshUI;

@end
