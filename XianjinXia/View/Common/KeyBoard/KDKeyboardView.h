//
//  KDKeyboardView.h
//  KDLC
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kdKeyBoardType)
{
    KDIDNUM = 1,    //身份证号
    
    TELEPHONE,      //手机号
    PHONECODE,      //验证码
    PAYPASSWORD,    //交易密码
    BANKCARDNUM,    //银行卡号
    DATE,           //期限
    KDNUMBERKEYBOARD,//只有数字的
    
    KDFLOATKEYBOARD  //有小数点的
};
@class KDKeyboardView;
@protocol KDTextfieldDelegate <NSObject>

@optional
- (void)hideKeyBoard:(KDKeyboardView *)keyboardView;

@end

@interface KDKeyboardView : UIView
//输入框
@property (nonatomic, retain) UITextField *textfield;

+(instancetype)KDKeyBoardWithKdKeyBoard:(kdKeyBoardType )type target:(id)target textfield:(UITextField *)textfield delegate:(id<KDTextfieldDelegate>)delegate valueChanged:(SEL)selector ;
@end
