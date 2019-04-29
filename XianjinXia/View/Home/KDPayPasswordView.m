//
//  KDPayPasswordView.m
//  KDLC
//
//  Created by 闫涛 on 15/3/5.
//  Copyright (c) 2015年 llyt. All rights reserved.
//

#import "KDPayPasswordView.h"
//#import "KDFindPasswordViewController.h"
#import "UserManager.h"
#import "KDKeyboardView.h"
//#import "KDFindTradePwdVC.h"
//#import "KDTabBarController.h"

#define viewWidth (SCREEN_WIDTH == 320.0 ? 260.0 : (SCREEN_WIDTH == 375.0 ? 300.0 : 340.0))

@interface KDPayPasswordView ()<KDTextfieldDelegate>



@property (nonatomic, retain) UIView *keyBack;              //密码盘部分背景

@property (nonatomic, retain) UILabel *keyDescLabel;        //密码盘说明
@property (nonatomic, retain) UIView  *topLine;             //分割线
@property (nonatomic, retain) UILabel *borrowTypeLabel;     //借款/还款区分
@property (nonatomic, retain) UILabel *payMoneyLabel;       //钱

@property (nonatomic, retain) UIView *bankLine1;            //银行分割线1
@property (nonatomic, retain) UIImageView *bankIcon;        //银行logo
@property (nonatomic, retain) UILabel *bankInfo;            //银行卡名以及尾号
@property (nonatomic, retain) UIView *bankLine2;            //银行分割线2

@property (nonatomic, retain) UIButton *closeBtn;           //关闭按钮
@property (nonatomic, retain) UIButton *forgetPassword;     //忘记密码

@property (nonatomic, retain) NSMutableArray *keyArray;     //记录KEYlabel

@property (nonatomic, assign) moneyType type;

@end

@implementation KDPayPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(moneyType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self loadUI];
    }
    return self;
}

- (void)loadUI
{
    _textfield = [[UITextField alloc] init];
    _textfield.keyboardType = UIKeyboardTypeNumberPad;
    _textfield.secureTextEntry = YES;
    [_textfield addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_textfield];
    
    [KDKeyboardView KDKeyBoardWithKdKeyBoard:PAYPASSWORD target:self textfield:_textfield delegate:self valueChanged:@selector(textfieldChange:)];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.3f];
    [self addSubview:backView];
    
    _keyBack = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - viewWidth) / 2.0, iPhone4? 11 : 50.0*WIDTHRADIUS, viewWidth,0)];
    _keyBack.layer.masksToBounds = YES;
    _keyBack.layer.cornerRadius = 8.0;

    _keyBack.layer.cornerRadius = 10.0;
    CGFloat labelWidth = (viewWidth - 34.0) / 6;
    _keyBack.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardUp)];
    [_keyBack addGestureRecognizer:gesture];
    [self addSubview:_keyBack];
    
    _keyDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10*WIDTHRADIUS, viewWidth, 20)];
    _keyDescLabel.text =  @"请输入交易密码";
    _keyDescLabel.backgroundColor = [UIColor clearColor];
    _keyDescLabel.font = [UIFont systemFontOfSize:15];
    _keyDescLabel.textColor = [UIColor colorWithHex:0x333333];
    _keyDescLabel.textAlignment = NSTextAlignmentCenter;
    [_keyBack addSubview:_keyDescLabel];
    
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_keyDescLabel.frame) + 10*WIDTHRADIUS, viewWidth, 0.5)];
    _topLine.backgroundColor = [UIColor colorWithHex:0xD7D7D7];
    [_keyBack addSubview:_topLine];
    
    _borrowTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topLine.frame)+(iPhone4 ? 10 : 15)*WIDTHRADIUS, viewWidth, 14)];
    _borrowTypeLabel.font = [UIFont systemFontOfSize:13.f];
    _borrowTypeLabel.textColor = [UIColor colorWithHex:0x999999];
    _borrowTypeLabel.textAlignment = NSTextAlignmentCenter;
    _borrowTypeLabel.text = _type == borrow ? @"借款金额" : @"还款金额";
    [_keyBack addSubview:_borrowTypeLabel];
    
    _payMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_borrowTypeLabel.frame)+10.f*WIDTHRADIUS, viewWidth, 31)];
    _payMoneyLabel.font = [UIFont systemFontOfSize:30.f];
    _payMoneyLabel.textColor = [UIColor colorWithHex:0x000000];
    _payMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [_keyBack addSubview:_payMoneyLabel];
    
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth - 40, 0, 40, 20*WIDTHRADIUS+20)];
    [_closeBtn setImage:[UIImage imageNamed:@"borrow_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [_keyBack addSubview:_closeBtn];
    
    
    _bankLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_payMoneyLabel.frame)+(iPhone4 ? 10 : 15)*WIDTHRADIUS, CGRectGetWidth(_keyBack.frame), .5f)];
    _bankLine1.backgroundColor = [UIColor colorWithHex:0xD7D7D7];
    [_keyBack addSubview:_bankLine1];
    
    _bankIcon = [[UIImageView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(_bankLine1.frame)+7.5, 25, 25)];
//    NSArray *cardIdArr = [UserManager sharedUser].card_list;
//    if (cardIdArr.count > 0 ) {
//        BankEntity *entity = [UserManager sharedUser].card_list[0];
//        [_bankIcon setImageWithURL:entity.url placeholderImage:[UIImage imageNamed:@""]];
//        [_keyBack addSubview:_bankIcon];
//    }
    
    _bankInfo = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_bankIcon.frame)+5, CGRectGetMaxY(_bankLine1.frame), 200, 40.f)];
    _bankInfo.textColor = [UIColor colorWithHex:0x333333];
    _bankInfo.font = [UIFont systemFontOfSize:15.f];
    [_keyBack addSubview:_bankInfo];
    
    _bankLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bankInfo.frame), CGRectGetWidth(_keyBack.frame), .5f)];
    _bankLine2.backgroundColor = [UIColor colorWithHex:0xD7D7D7];
    [_keyBack addSubview:_bankLine2];
    
    if (self.type == borrow) {
        _bankIcon.hidden = YES;
        _bankInfo.hidden = YES;
        _bankLine2.frame = CGRectMake(0, CGRectGetMaxY(_bankLine1.frame), CGRectGetWidth(_bankLine2.frame), CGRectGetHeight(_bankLine2.frame));
        _bankLine1.hidden = YES;
    }
    
    _keyArray = [@[] mutableCopy];
    
    for (int i = 0; i < 6; i ++) {
        UILabel *passwordKey = [[UILabel alloc] initWithFrame:CGRectMake(15 + i * labelWidth, CGRectGetMaxY(_bankLine2.frame) + 15*WIDTHRADIUS, labelWidth + 1, labelWidth)];
        passwordKey.font = [UIFont systemFontOfSize:24];
        passwordKey.textColor = [UIColor colorWithHex:0x000000];
        passwordKey.layer.masksToBounds = YES;
        passwordKey.layer.borderColor = [UIColor colorWithHex:0xDDDDDD].CGColor;
        passwordKey.layer.borderWidth = .5f;
        passwordKey.textAlignment = NSTextAlignmentCenter;
        [_keyArray addObject:passwordKey];
        [_keyBack addSubview:passwordKey];
    }
    
     _keyBack.frame = CGRectMake(_keyBack.frame.origin.x, _keyBack.frame.origin.y, viewWidth, CGRectGetMaxY(_bankLine2.frame)+  15*WIDTHRADIUS+labelWidth+15*WIDTHRADIUS);
}

- (void)keyBoardUp
{
    [_textfield becomeFirstResponder];
}

- (void)refreshUI
{
    _textfield.text = @"";
    for (UILabel *label in _keyArray) {
        label.text = @"";
    }
    [_textfield becomeFirstResponder];
    

    _payMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[_payMoneyNum doubleValue]];
    if (self.type == repay) {
        _bankInfo.text = _bankInfoStr;
        CGFloat wid = [_bankInfoStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} context:nil].size.width;
        _bankIcon.frame = CGRectMake((viewWidth-25-wid-5)/2, CGRectGetMinY(_bankIcon.frame), CGRectGetWidth(_bankIcon.frame), CGRectGetHeight(_bankIcon.frame));
        _bankInfo.frame = CGRectMake(CGRectGetMaxX(_bankIcon.frame)+5, CGRectGetMinY(_bankInfo.frame), wid, CGRectGetHeight(_bankInfo.frame));
    }

    if (_payMoneyLabel.text.length>1) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_payMoneyLabel.text];
        if (SCREEN_WIDTH == 320.0) {
            [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 1)];
        }else if(SCREEN_WIDTH == 414.0){
            [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 1)];
        }else{
            [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 1)];
        }
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x999999] range:NSMakeRange(0, 1)];
        _payMoneyLabel.attributedText = attri;
    }
}

- (void)removeSelf
{
    [_textfield resignFirstResponder];
//    self.hidden = YES;
    [self removeFromSuperview];
}

- (void)findPassword
{
//    [[KDTabBarController shareTabController] pushToViewController:[KDFindTradePwdVC new]];
}

#pragma mark 键盘代理方法
- (BOOL)commitBtnClick:(KDKeyboardView *)keyboardView
{
    return NO;
}

- (void)hideKeyBoard:(KDKeyboardView *)keyboardView
{
    
}

#pragma mark textfield相关
- (void)textfieldChange:(UITextField *)textfield
{
    
    for (UILabel *label in _keyArray) {
        if ([_keyArray indexOfObject:label] < _textfield.text.length) {
            label.text = @"●";
        } else {
            label.text = @"";
        }
    }
    
    if (_textfield.text.length >= 6) {
        
        [self performSelector:@selector(login) withObject:self afterDelay:0.0];
    }
}
- (void)login
{
    [self removeSelf];
    
    if (self.allPasswordPut) {
        if (_textfield.text.length>=6) {
            self.allPasswordPut([self.textfield.text substringToIndex:6]);
        }
    }
}
@end
