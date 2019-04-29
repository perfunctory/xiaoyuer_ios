//
//  FindPasswordVC.m
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "FindPasswordVC.h"
#import "KDCustomTextField.h"
#import "UserManager.h"
#import "NSString+Frame.h"
#import "KDKeyboardView.h"
#import "DXAlertView.h"
#import "NewPasswordVC.h"
#import "IQKeyboardManager.h"
#import "ForgetPassWordRequest.h"
#import <UIImageView+WebCache.h>

@interface FindPasswordVC ()<KDTextfieldDelegate,UITextFieldDelegate>

@property(nonatomic,retain)UIScrollView *baseView;
@property(nonatomic,retain)UILabel* tipLabel;
@property(nonatomic,retain)UITextField* phoneNum;
@property(nonatomic,retain)UITextField* trueName;
@property(nonatomic,retain)UITextField* idCard;
@property(nonatomic,retain)UITextField* messageKey;
@property (nonatomic, retain) UITextField *graphTextfield;
@property(nonatomic,retain)UIButton* getMessageKey;
@property(nonatomic,retain)UIView* lineView;
@property(nonatomic,retain)UIView* backView;
@property(nonatomic,retain)UIView* graphView;
@property(nonatomic,retain)NSString* tempStr;
@property(nonatomic,retain)UIButton* button;
@property(nonatomic,assign)int timeText;
@property(nonatomic,retain)NSTimer* timer;

@property (nonatomic, strong)ForgetPassWordRequest *requestForgetPassWord;

@end

@implementation FindPasswordVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.phoneNum.text = self.phoneNumber;
    if (_forgetType == login) {
        self.navigationItem.title = @"找回登录密码";
                __weak typeof(self) weakSelf = self;
        if ([self.getMessageKey.titleLabel.text isEqualToString:@"重新发送"]||[self.getMessageKey.titleLabel.text isEqualToString:@"获取验证码"]) {
                [_getMessageKey setTitleColor:[UIColor colorWithHex:0xdddddd] forState:UIControlStateNormal];
            [UIButton startRunSecond:_getMessageKey stringFormat:@"%@秒" finishBlock:^{
                weakSelf.getMessageKey.userInteractionEnabled = YES;
                [weakSelf.getMessageKey setTitle:@"重新发送" forState:UIControlStateNormal];
                [_getMessageKey setTitleColor:Color_Red forState:UIControlStateNormal];
            }];
        }
    }
    if (_forgetType == pay) {
        self.navigationItem.title = @"找回交易密码";
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    //delegate 置为nil
    
    //删除通知
    
}

#pragma mark - View创建与设置

- (void)setUpView{
    [self baseSetup:PageGobackTypePop];
    [self setUpDataSource];
    //创建视图等
    self.view.backgroundColor = [UIColor whiteColor];
    _baseView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAllKeyBoards)];
    [self.view addGestureRecognizer:tap];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _tipLabel.font = [UIFont systemFontOfSize:13.0f];
    _tipLabel.textColor = [UIColor colorWithHex:0x333333];
    [_baseView addSubview:_tipLabel];
    _phoneNum = [[KDCustomTextField alloc] initWithFrame:CGRectMake(15, 30, self.view.frame.size.width-30, 44) andGap:40];
    [_phoneNum.layer setMasksToBounds:YES];
    [_phoneNum.layer setCornerRadius:3.0f];
    [_phoneNum.layer setBorderColor:[UIColor colorWithHex:0xb7b7b7].CGColor];
    [_phoneNum addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_phoneNum.layer setBorderWidth:0.5f];
    _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNum.placeholder = @"请输入手机号";
    _phoneNum.delegate = self;
    [_baseView addSubview:_phoneNum];
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65/2, 44)];
    UIImageView* imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone"]];
    imageview1.frame = CGRectMake(12, 13, 11.5, 20);
    [view1 addSubview:imageview1];
    _phoneNum.leftView = view1;
    _phoneNum.leftViewMode = UITextFieldViewModeAlways;
    
    if (_forgetType == login) {
        _phoneNum.text = _phoneNumber;
    }else{
        _phoneNum.text = [UserManager sharedUserManager].userInfo.username;
        _phoneNumber = [UserManager sharedUserManager].userInfo.username;
    }
    if (_phoneNum.text.length>0) {
        _phoneNum.text = [NSString stringWithFormat:@"%@****%@",[_phoneNum.text substringToIndex:3],[_phoneNum.text substringFromIndex:7]];
    }
    
    [_phoneNum setUserInteractionEnabled:NO];
    
        if (_forgetType == login&&_captchaUrl.length!=0) {//双重条件
    _graphView = [[UIView alloc] initWithFrame:CGRectMake(15, 30 + 44 + 8, self.view.frame.size.width-30, 44)];
    [_graphView.layer setMasksToBounds:YES];
    [_graphView.layer setBorderWidth:0.5f];
    [_graphView.layer setCornerRadius:3.0f];
    [_graphView.layer setBorderColor:[UIColor colorWithHex:0xb7b7b7].CGColor];
    [_baseView addSubview:_graphView];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_graphView.frame)+8, self.view.frame.size.width-30, 44)];
        }else{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(15, 30 + 44 + 8, self.view.frame.size.width-30, 44)];
        }
    [_backView.layer setMasksToBounds:YES];
    [_backView.layer setBorderWidth:0.5f];
    [_backView.layer setCornerRadius:3.0f];
    [_backView.layer setBorderColor:[UIColor colorWithHex:0xb7b7b7].CGColor];
    [_baseView addSubview:_backView];
    
    _messageKey = [[KDCustomTextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30 - 70, 44) andGap:40];
    [_messageKey.layer setMasksToBounds:YES];
    [_messageKey.layer setCornerRadius:3.0f];
    [_messageKey addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _messageKey.keyboardType = UIKeyboardTypeNumberPad;
    _messageKey.placeholder = @"请输入短信验证码";
    _messageKey.clearButtonMode = UITextFieldViewModeWhileEditing |UITextFieldViewModeUnlessEditing;
    _messageKey.delegate = self;
    [_backView addSubview:_messageKey];
    
    [KDKeyboardView KDKeyBoardWithKdKeyBoard:PHONECODE target:self textfield:_messageKey delegate:self valueChanged:@selector(textFieldChanged:)];
    
    UIView* view4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65/2, 44)];
    UIImageView* imageview4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messageregist"]];
    imageview4.frame = CGRectMake(7, 16, 19, 13.5);
    [view4 addSubview:imageview4];
    _messageKey.leftView = view4;
    _messageKey.leftViewMode = UITextFieldViewModeAlways;
    
    NSString *title = @"获取验证码";
    CGFloat twidth = [title widthWithFontSize:12.f];
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40-twidth, 0, 0.5, _messageKey.frame.size.height)];
    _lineView.backgroundColor = [UIColor colorWithHex:0xb7b7b7];
    [_backView addSubview:_lineView];
    
    _getMessageKey = [[UIButton alloc] initWithFrame:CGRectMake(_lineView.frame.origin.x+4, _messageKey.frame.origin.y, twidth, 44)];
    [_getMessageKey setTitle:title forState:UIControlStateNormal];
    [_getMessageKey setTitleColor:Color_Red forState:UIControlStateNormal];
    _getMessageKey.titleLabel.font = [UIFont systemFontOfSize:12];
    [_getMessageKey addTarget:self action:@selector(getMessagekeyTouch) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_getMessageKey];
    
    
    _graphTextfield = [[KDCustomTextField alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width-30, 44) andGap:40];
    [_graphTextfield.layer setMasksToBounds:YES];
    [_graphTextfield.layer setCornerRadius:3.0f];
    _graphTextfield.keyboardType = UIKeyboardTypeASCIICapable;
    _graphTextfield.placeholder = @"请输入图形验证码";
    _graphTextfield.clearButtonMode = UITextFieldViewModeWhileEditing |UITextFieldViewModeUnlessEditing;
    _graphTextfield.delegate = self;
    [_graphView addSubview:_graphTextfield];
   [_graphTextfield addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
//    [KDKeyboardView KDKeyBoardWithKdKeyBoard:PHONECODE target:self textfield:_graphTextfield delegate:self valueChanged:@selector(textFieldChanged:)];
    
    UIView* view5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65/2, 44)];
    UIImageView* imageview5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_123"]];
    imageview5.frame = CGRectMake(7, 16, 19, 13.5);
    [view5 addSubview:imageview5];
    _graphTextfield.leftView = view5;
    _graphTextfield.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 75, 45)];
    NSURL *urlStr = [NSURL URLWithString:_captchaUrl];
    
    UIImageView *imgViewRight = [[UIImageView alloc]init];
    [imgViewRight sd_setImageWithURL:urlStr];
    imgViewRight.frame = CGRectMake(0, 5, 62, 35);
    imgViewRight.contentMode = UIViewContentModeCenter;
    [rightView addSubview:imgViewRight];
    _graphTextfield.rightView = rightView;
    _graphTextfield.rightViewMode = UITextFieldViewModeAlways;
    
    
            if (_forgetType == login&&_captchaUrl.length!=0) {//双重条件
    _button = [[UIButton alloc] initWithFrame:CGRectMake(15, 30 + 44 + 8 + 44 + 8+52, self.view.frame.size.width-30, 44)];
            }else{
    _button = [[UIButton alloc] initWithFrame:CGRectMake(15, 30 + 44 + 8 + 44 + 8, self.view.frame.size.width-30, 44)];
            }
    [_button setTitle:@"下一步" forState:UIControlStateNormal];
    [_button setBackgroundColor:[UIColor colorWithHex:0xb7b7b7]];
    _button.titleLabel.font = [UIFont systemFontOfSize:17];
    [_button.layer setCornerRadius:3.0];
    _button.userInteractionEnabled = NO;
    [_button addTarget:self action:@selector(nextTouch) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_button];
    
}

#pragma mark - 初始化数据源

- (void)setUpDataSource{
    
}

#pragma mark - 按钮事件

-(void) hideAllKeyBoards{
    NSMutableArray *subviews = [NSMutableArray arrayWithArray:[_baseView subviews]];
    [subviews addObjectsFromArray:[_backView subviews]];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
                [_baseView setContentOffset:CGPointMake(0, 0) animated:YES];
                break;
            }
        }
    }
}

-(void)nextTouch
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view endEditing:YES];
        _baseView.frame = self.view.bounds;
    }];
    
    if (_messageKey.text.length == 6) {
        NSDictionary *params;
        if (_forgetType == login) {
            NSString *strCaptcha = @"";
            if (_captchaUrl.length!=0&&_graphTextfield.text.length!=0) {
                strCaptcha = DSStringValue(_graphTextfield.text);
            }
            params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber, @"phone",_messageKey.text,@"code",@"find_pwd",@"type",strCaptcha,@"captcha",nil];
        }else{
            params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber, @"phone",_messageKey.text,@"code",@"find_pay_pwd",@"type",[[UserManager sharedUserManager].userInfo realname],@"realname",_idCard.text,@"id_card",nil];//_trueName.text
            
        }
        [self showLoading:@""];
        [self.requestForgetPassWord forgetPassWordWithDict:params onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            NewPasswordVC *newPasswordVC = [[NewPasswordVC alloc] init];
            if (_forgetType == login) {
                newPasswordVC.forgetType = @"login";
            }else{
                newPasswordVC.forgetType = @"pay";
            }
            newPasswordVC.phoneNumber = _phoneNumber;
            newPasswordVC.code = _messageKey.text;
            newPasswordVC.realName = _trueName.text;
            newPasswordVC.idCard = _idCard.text;
            [self dsPushViewController:newPasswordVC animated:YES];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
        }];
        
//        self.verification.param = params;
//        __weak typeof(self) weakSelf = self;
//        [self.verification loadDataWithSuccess:^(NSDictionary *data) {
//            
//            [self postSucess:@{@"code":@"0",@"message":@"123"}];
//        } falid:^(NSString *msg) {
//            
//            if (nil == msg || ![msg isKindOfClass:[NSString class]]) {
//                msg = @"当前网络断开啦，请检查网络连接";
//            }
//            [[iToast makeText:msg] show];
//        }];
    }else{
        [self showMessage:@"验证码格式不正确，请重新输入"];
    }
}

-(void)getMessagekeyTouch
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.view endEditing:YES];
        _baseView.frame = self.view.bounds;
    }];
    
    [_getMessageKey setTitleColor:[UIColor colorWithHex:0xdddddd] forState:UIControlStateNormal];
    if (_phoneNumber.length == 11) {
        NSDictionary *params;
        if (_forgetType == login) {
            NSString *strCaptcha = @"";
            if (_captchaUrl.length!=0&&_graphTextfield.text.length!=0) {
                strCaptcha = DSStringValue(_graphTextfield.text);
            }
//            params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber, @"phone",@"find_pwd",@"type",@"1",@"type2",strCaptcha,@"captcha",nil];
            params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber, @"phone",@"find_pwd",@"type",@"0",@"type2",strCaptcha,@"captcha",nil];

        }else{
            params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber, @"phone",@"find_pay_pwd",@"type",nil];
        }
                [self showLoading:@""];
        [self.requestForgetPassWord resetPwdCodeWithDict:params onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            _timeText = 60;
            [self showTime];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showTime) userInfo:nil repeats:YES];
            _tempStr = @"短信验证码已发送";
            [self refreshUI];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
            _getMessageKey.userInteractionEnabled = YES;
            [_getMessageKey setTitle:@"重新发送" forState:UIControlStateNormal];
            [_getMessageKey setTitleColor:Color_Red forState:UIControlStateNormal];
        }];
//        self.getData.param = params;
//        __weak typeof(self) weakSelf = self;
//        [self.getData loadDataWithSuccess:^(NSDictionary *data) {
//            
//        [self postGesterSucess:@{@"code":@"0",@"message":@"123"}];
//        } falid:^(NSString *msg) {
//            
//            if (nil == msg || ![msg isKindOfClass:[NSString class]]) {
//                msg = @"当前网络断开啦，请检查网络连接";
//            }
//            [[iToast makeText:msg] show];
//        }];
        _getMessageKey.userInteractionEnabled = NO;
    }else{
        DXAlertView* alertView = [[DXAlertView alloc] initWithTitle:nil contentText:@"手机号码格式不正确"  leftButtonTitle:nil rightButtonTitle:@"确定"];
        [self hideAllKeyBoards];
        [alertView show];
    }
}

#pragma mark - Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField.layer setBorderColor:Color_Red.CGColor];
    if (textField == _messageKey) {
        _lineView.backgroundColor = Color_Red;
        _backView.layer.borderColor = Color_Red.CGColor;
        _graphView.layer.borderColor = [UIColor colorWithHex:0xb7b7b7].CGColor;
        
    }else    if (textField == _graphTextfield) {
        _lineView.backgroundColor = [UIColor colorWithHex:0xb7b7b7];
        _backView.layer.borderColor = [UIColor colorWithHex:0xb7b7b7].CGColor;
        _graphView.layer.borderColor = Color_Red.CGColor;
    }
    
    if (SCREEN_HEIGHT <= 568) {
        if (textField == _trueName) {
            [_baseView setContentOffset:CGPointMake(0, _phoneNum.frame.origin.y + 50) animated:YES];
        } else if (textField == _idCard) {
            [_baseView setContentOffset:CGPointMake(0, _phoneNum.frame.origin.y + 50) animated:YES];
        } else {
            [_baseView setContentOffset:CGPointMake(0, _trueName.frame.origin.y) animated:YES];
        }
    }
    
    if (_phoneNum.text.length > 0 && _trueName.text.length > 0 &&_idCard.text.length > 0 &&_messageKey.text.length > 0 ) {
        [self buttonToRed];
    }else{
        [self buttonToGray];
    }
}

-(void)textFieldChanged:(UITextField*)textfield
{
    if (_messageKey.text.length > 6) {
        _messageKey.text = [_messageKey.text substringToIndex:6];
        [_messageKey.undoManager removeAllActions];
    }
    if (_graphTextfield.text.length > 4) {
        _graphTextfield.text = [_graphTextfield.text substringToIndex:4];
        [_graphTextfield.undoManager removeAllActions];
    }
    
    if (_phoneNum.text.length > 0 && _messageKey.text.length > 0 ) {
        [self buttonToRed];
    }else{
        [self buttonToGray];
    }
    if (_idCard.text.length > 18) {
        _idCard.text = [_idCard.text substringToIndex:18];
        [_idCard.undoManager removeAllActions];
    }
    
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    [textField.layer setBorderColor:Color_Red.CGColor];
//    if (textField == _messageKey) {
//        _lineView.backgroundColor = Color_Red;
//        _backView.layer.borderColor = Color_Red.CGColor;
//    }
//    
//    if (SCREEN_HEIGHT <= 568) {
//        if (textField == _trueName) {
//            [_baseView setContentOffset:CGPointMake(0, _phoneNum.frame.origin.y + 50) animated:YES];
//        } else if (textField == _idCard) {
//            [_baseView setContentOffset:CGPointMake(0, _phoneNum.frame.origin.y + 50) animated:YES];
//        } else {
//            [_baseView setContentOffset:CGPointMake(0, _trueName.frame.origin.y) animated:YES];
//        }
//    }
//    return YES;
//}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL basic = NO;
    if (textField == _trueName) {
        basic = YES;
    }
    if (textField == _idCard) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"Xx0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        basic = [string isEqualToString:filtered];
    }
    
    if (textField == _messageKey) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        basic = [string isEqualToString:filtered];
    }
    if (textField == _graphTextfield) {
        basic = YES;
    }
    return basic;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField.layer setBorderColor:[UIColor colorWithHex:0xb7b7b7].CGColor];
    if (textField == _messageKey) {
        _lineView.backgroundColor = [UIColor colorWithHex:0xb7b7b7];
        _backView.layer.borderColor = [UIColor colorWithHex:0xb7b7b7].CGColor;
        _graphView.layer.borderColor = [UIColor colorWithHex:0xb7b7b7].CGColor;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)commitBtnClick:(KDKeyboardView *)keyboardView
{
    if (_phoneNum.text.length > 0 && _messageKey.text.length > 0 ) {
        [self nextTouch];
        return YES;
    }
    
    return NO;
}

- (void)hideKeyBoard:(KDKeyboardView *)keyboardView
{
    [self hideAllKeyBoards];
}

#pragma mark - 请求数据

#pragma mark - Other

-(ForgetPassWordRequest *)requestForgetPassWord{
    if (!_requestForgetPassWord) {
        _requestForgetPassWord = [ForgetPassWordRequest new];
    }
    return _requestForgetPassWord;
}

-(void)buttonToGray
{
    _button.backgroundColor = [UIColor colorWithHex:0xb7b7b7];
    _button.userInteractionEnabled = NO;
}

-(void)buttonToRed
{
    _button.backgroundColor = Color_Red;
    _button.userInteractionEnabled = YES;
}

//-(void)postSucess:(NSDictionary*)datas
//{
//    if([[NSString stringWithFormat:@"%@",datas[@"code"]] isEqualToString:@"0"]){
//        NewPasswordVC *newPasswordVC = [[NewPasswordVC alloc] init];
//        if (_forgetType == login) {
//            newPasswordVC.forgetType = @"login";
//        }else{
//            newPasswordVC.forgetType = @"pay";
//        }
//        newPasswordVC.phoneNumber = _phoneNumber;
//        newPasswordVC.code = _messageKey.text;
//        newPasswordVC.realName = _trueName.text;
//        newPasswordVC.idCard = _idCard.text;
//        [self.navigationController pushViewController:newPasswordVC animated:YES];
//    }else{
//        //        DXAlertView* alertView = [[DXAlertView alloc] initWithTitle:@"提示" contentText:[datas objectForKey:@"message"] leftButtonTitle:@"确定" rightButtonTitle:@"取消"];
//        DXAlertView* alertView = [[DXAlertView alloc]initWithTitle:nil contentText:[datas objectForKey:@"message"] leftButtonTitle:nil rightButtonTitle:@"确定"];
//        [self hideAllKeyBoards];
//        [alertView show];
//    }
//}

-(void)showTime
{
    if (_timeText <= 1) {
        _getMessageKey.userInteractionEnabled = YES;
        [_timer invalidate];
        [_getMessageKey setTitle:@"重新发送" forState:UIControlStateNormal];
        [_getMessageKey setTitleColor:Color_Red forState:UIControlStateNormal];
    }else{
        [_getMessageKey setTitle:[NSString stringWithFormat:@"%d秒",--_timeText] forState:UIControlStateNormal];
    }
}

////短信验证码发送成功失败
//-(void)postGesterSucess:(NSDictionary*)datas
//{
//    if([[NSString stringWithFormat:@"%@",datas[@"code"]] isEqualToString:@"0"]){
//        _timeText = 60;
//        [self showTime];
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showTime) userInfo:nil repeats:YES];
//        _tempStr = @"短信验证码已发送";
//        [self refreshUI];
//    }else{
//        [self showMessage:[NSString stringWithFormat:@"%@",[datas objectForKey:@"message"]]];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

-(void)refreshUI
{
    CGFloat width = [_tempStr widthWithFontSize:13.f];
    _tipLabel.frame = CGRectMake(15, 10, width, 13);
    _tipLabel.text = _tempStr;
}

@end
