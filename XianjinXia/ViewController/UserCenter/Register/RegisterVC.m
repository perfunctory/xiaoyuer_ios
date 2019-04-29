//
//  RegisterVC.m
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "RegisterVC.h"
#import "UITextField+lyt.h"
#import "KDXieYiBtn.h"
#import "CommonWebVC.h"
#import <Lyt.h>
#import "LoginOrRegistRequest.h"
#import "UserModel.h"
#import <YYModel/YYModel.h>
#import "UserManager.h"
#import "XJXKeychain.h"
#import "DXAlertView.h"
#import <UIImageView+WebCache.h>

@interface RegisterVC ()
@property (nonatomic, retain) UITextField *graphTextfield;
@property (nonatomic, retain) UITextField *codeTextfield;
@property (nonatomic, retain) UIButton *getCodeBtn;
@property (nonatomic, retain) UITextField *pwdTextfield;
@property (nonatomic, retain) UITextField *inviteTextfield;//邀请框
@property (nonatomic, retain) UIButton *commitBtn;
@property (nonatomic, retain) UIButton *hiddenBtn;
@property (nonatomic, retain) KDXieYiBtn *btn;
@property (assign, nonatomic) registerOrForgetPwd type;

@property (nonatomic,strong) LoginOrRegistRequest *request; //获取验证码
@end

@implementation RegisterVC

- (instancetype)initWithPageType:(registerOrForgetPwd)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (LoginOrRegistRequest *)request{
    
    if (!_request) {
        _request = [[LoginOrRegistRequest alloc] init];
    }
    return _request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backArrowSet];
    [self umengEvent:UmengEvent_Register];
    self.navigationItem.title = @"注册";
    UIScrollView *scvMain = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scvMain;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUIView];
    [self viewAddEndEditingGesture];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_commitBtn setTitle:self.type == forgetPwd ? @"确定" : @"注册" forState:UIControlStateNormal];
    if (self.type == registerSec) {
        __weak typeof(self) weakSelf = self;
        if ([weakSelf.getCodeBtn.titleLabel.text isEqualToString:@"重新发送"]||[weakSelf.getCodeBtn.titleLabel.text isEqualToString:@"发送验证码"]) {
            [UIButton startRunSecond:_getCodeBtn stringFormat:@"%@秒后重试" finishBlock:^{
                weakSelf.getCodeBtn.userInteractionEnabled = YES;
                [weakSelf.getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [weakSelf.getCodeBtn setTitleColor:Color_Red forState:UIControlStateNormal];
            }];
        }
        
    } else {
        [self.getCodeBtn setTitleColor:Color_Red forState:UIControlStateNormal];
    }
//        [_commitBtn lyt_placeBelowView:_pwdTextfield margin:20];
//    if(self.type == forgetPwd)
//    {
//        [_commitBtn lyt_placeBelowView:_pwdTextfield margin:20];
//        _inviteTextfield.hidden = YES;
//    }else{
//        [_commitBtn lyt_placeBelowView:_inviteTextfield margin:20];
//        _inviteTextfield.hidden = YES;
//    }
}

- (void)createUIView
{
    __weak typeof(self) weakSelf = self;
    _graphTextfield = [UITextField getTextFieldWithFontSize:15.0f textColorHex:0x333333 placeHolder:@"请输入图形验证码" superView:self.view masonrySet:^(UITextField *view, MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(15);
        //        make.right.equalTo(weakSelf.view).offset(-15);
        make.width.equalTo([self swithNumberWithFloat:SCREEN_WIDTH - 30]);
        make.top.equalTo(weakSelf.view).offset(50);
        make.height.mas_equalTo(45);
    }];
    _graphTextfield.keyboardType =UIKeyboardTypeASCIICapable;
    _graphTextfield.layer.masksToBounds = YES;
    _graphTextfield.layer.borderColor = Color_Red.CGColor;
    _graphTextfield.layer.borderWidth = .5f;
    _graphTextfield.layer.cornerRadius = 5;
    
    UIImageView *imgViewGraph = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_123"]];
    imgViewGraph.frame = CGRectMake(0, 0, 30, 44);
    imgViewGraph.contentMode = UIViewContentModeCenter;
    _graphTextfield.leftView = imgViewGraph;
    _graphTextfield.leftViewMode = UITextFieldViewModeAlways;
    [_graphTextfield addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _graphTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 75, 45)];
    NSURL *urlImage = [NSURL URLWithString:_captchaUrl];
    
    UIImageView *imgViewRight = [[UIImageView alloc]init];
    [imgViewRight sd_setImageWithURL:urlImage];
    imgViewRight.frame = CGRectMake(0, 5, 62, 35);
    imgViewRight.contentMode = UIViewContentModeCenter;
    [rightView addSubview:imgViewRight];
    _graphTextfield.rightView = rightView;
        _graphTextfield.rightViewMode = UITextFieldViewModeAlways;
    _codeTextfield = [UITextField getTextFieldWithFontSize:15.0f textColorHex:0x333333 placeHolder:@"请输入验证码" superView:self.view masonrySet:^(UITextField *view, MASConstraintMaker *make) {

        make.left.equalTo(weakSelf.view).offset(15);
        //        make.right.equalTo(weakSelf.view).offset(-15);
        make.width.equalTo([self swithNumberWithFloat:SCREEN_WIDTH - 30]);
        if (_captchaUrl.length!=0) {
            make.top.equalTo(weakSelf.graphTextfield.mas_bottom).offset(20);
            _graphTextfield.hidden = NO;
        }else{
            _graphTextfield.hidden = YES;
        make.top.equalTo(weakSelf.view).offset(50);
        }
        make.height.mas_equalTo(45);
    }];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"messageregist"]];
    imgView.frame = CGRectMake(0, 0, 30, 44);
    imgView.contentMode = UIViewContentModeCenter;
    _codeTextfield.leftView = imgView;
    _codeTextfield.leftViewMode = UITextFieldViewModeAlways;
    [_codeTextfield addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _codeTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextfield.keyboardType =UIKeyboardTypeASCIICapable;
    _getCodeBtn = [UIButton new];
    _getCodeBtn.frame = CGRectMake(0, 0, 80, 45);
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_getCodeBtn setTitleColor:[UIColor colorWithHex:0xcccccc] forState:UIControlStateNormal];
    [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    _getCodeBtn.layer.masksToBounds = YES;
    _getCodeBtn.layer.borderColor = [UIColor colorWithHex:0xFF5145].CGColor;
    _getCodeBtn.layer.borderWidth = 0.5f;
    [_getCodeBtn addTarget:self action:@selector(getRegisCode) forControlEvents:UIControlEventTouchUpInside];
    _codeTextfield.rightView = _getCodeBtn;
    _codeTextfield.rightViewMode = UITextFieldViewModeAlways;
    _codeTextfield.layer.masksToBounds = YES;
    _codeTextfield.layer.borderColor = Color_Red.CGColor;
    _codeTextfield.layer.borderWidth = .5f;
    _codeTextfield.layer.cornerRadius = 5;
    
    
    _pwdTextfield = [UITextField getTextFieldWithFontSize:15 textColorHex:0x333333 placeHolder:@"请设置新的6-16位登录密码" superView:self.view masonrySet:^(UITextField *view, MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        //        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.width.equalTo([self swithNumberWithFloat:SCREEN_WIDTH - 30]);
        make.top.equalTo(_codeTextfield.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    UIImageView *pwdLeftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pwd_icon"]];
    pwdLeftImg.frame = CGRectMake(0, 0, 30, 44);
    pwdLeftImg.contentMode = UIViewContentModeCenter;
    _pwdTextfield.leftView = pwdLeftImg;
    _pwdTextfield.leftViewMode = UITextFieldViewModeAlways;
    _pwdTextfield.secureTextEntry = YES;
    [_pwdTextfield addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _pwdTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdTextfield.layer.masksToBounds = YES;
    _pwdTextfield.layer.borderColor = Color_Red.CGColor;
    _pwdTextfield.layer.borderWidth = .5f;
    _pwdTextfield.layer.cornerRadius = 5;
    
    //邀请码按钮
    _hiddenBtn = [UIButton new];
        if (_captchaUrl.length!=0) {
    _hiddenBtn.frame = CGRectMake(15, 173+65, SCREEN_WIDTH, 16);
    }else{
    _hiddenBtn.frame = CGRectMake(15, 173, SCREEN_WIDTH, 16);
    }
    _hiddenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_hiddenBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_hiddenBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [_hiddenBtn setTitle:@"我有邀请码>>" forState:UIControlStateNormal];
    [_hiddenBtn addTarget:self action:@selector(hiddenClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hiddenBtn];
    
    _inviteTextfield = [UITextField getTextFieldWithFontSize:15 textColorHex:0x333333 placeHolder:@"请输入邀请码（可选）" superView:self.view masonrySet:^(UITextField *view, MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(15);
        //        make.right.equalTo(weakSelf.view).offset(-15);
        make.width.equalTo([self swithNumberWithFloat:SCREEN_WIDTH - 30]);
        make.top.equalTo(_pwdTextfield.mas_bottom).offset(20);
        make.height.mas_equalTo(0);
    }];
    
    UIView *zhan = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    zhan.contentMode = UIViewContentModeCenter;
    _inviteTextfield.leftView = zhan;
    _inviteTextfield.leftViewMode = UITextFieldViewModeAlways;
    [_inviteTextfield addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _inviteTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _inviteTextfield.layer.masksToBounds = YES;
    _inviteTextfield.layer.borderColor = Color_Red.CGColor;
    _inviteTextfield.layer.borderWidth = .5f;
    _inviteTextfield.layer.cornerRadius = 5;
    
    _commitBtn = [UIButton getButtonWithFontSize:15 TextColorHex:0xffffff backGroundColor:0xd9d9d9 superView:self.view masonrySet:^(UIButton *view, MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(15);
        //        make.right.equalTo(weakSelf.view).offset(-15);
        make.width.equalTo([self swithNumberWithFloat:SCREEN_WIDTH - 30]);
        make.top.equalTo(_inviteTextfield.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
    _commitBtn.userInteractionEnabled = NO;
    [_commitBtn setBackgroundImage:[UIImage imageNamed:@"button_gray_background"] forState:UIControlStateNormal];
    _commitBtn.layer.masksToBounds = YES;
    _commitBtn.layer.cornerRadius = 5.0f;
    [_commitBtn addTarget:self action:@selector(commitRegister) forControlEvents:UIControlEventTouchUpInside];
    
    _btn = [[KDXieYiBtn alloc]initWithXieyiName:@[@"《注册协议》",@"《信用授权协议》"] topView:self.commitBtn superView:self.view];
    [self.view addSubview:_btn];
    
    _btn.xieyiLabelTapBlock = ^{
        CommonWebVC *web = [[CommonWebVC alloc]init];
        web.strTitle = @"《注册协议》";
        web.strType = @"ZCXY";
        web.strAbsoluteUrl = [NSString stringWithFormat:@"%@%@",Url_Server,@"/act/light-loan-xjx/agreement"];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:web];
        [weakSelf presentViewController:nav animated:YES completion:nil];
//        [weakSelf dsPushViewController:web animated:YES];
    };
    
    _btn.xieyiLabel2TapBlock = ^{
        CommonWebVC *web = [[CommonWebVC alloc]init];
        web.strTitle = @"《信用授权协议》";
        web.strType = @"XYXY";
        web.strAbsoluteUrl = [NSString stringWithFormat:@"%@%@",Url_Server,@"/agreement/creditExtension"];
//        [weakSelf dsPushViewController:web animated:YES];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:web];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    };
    
    _btn.checkBlock = ^{
        [weakSelf refreshCommitBtnEnable];
    };
    
    if (_captchaUrl.length!=0) {
        [_graphTextfield becomeFirstResponder];
    }else{
        [_codeTextfield becomeFirstResponder];
    }

    _inviteTextfield.hidden = YES;
    
}
- (void)commitRegister{
    
    if (![self checkLoginCondition]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *strCaptcha = @"";
    if (_captchaUrl.length!=0&&_graphTextfield.text.length!=0) {
        strCaptcha = DSStringValue(_graphTextfield.text);
    }
    [self.request commitRegisterWithDict:@{@"phone":self.phoneNumber,
                                           @"code":self.codeTextfield.text,
                                           @"password":self.pwdTextfield.text,
                                           @"source":@"37",
                                           @"name":@"",
                                           @"invite_code":self.inviteTextfield.text,
                                           @"captcha":strCaptcha} onSuccess:^(NSDictionary *dictResult) {
                                               
                                               
                                               [[UserManager sharedUserManager] updateUserInfo:dictResult[@"item"]];
                                               //存储用户信息
                                               //如果没设置密码则 设定密码 并存储
                                               [XJXKeychain setPassword:self.pwdTextfield.text forService:kXJXKeychainErrorDomain account:self.phoneNumber];
                                               [self showMessage:@"注册成功"];
                                               [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterSuccess" object:nil];
                                               
                                           } andFailed:^(NSInteger code, NSString *errorMsg) {
//                                               DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
//                                               [alert show];
                                               [self showMessage:errorMsg];
                                           }];
}

- (void)textFieldValueChanged:(UITextField *)textfield
{
    if (_codeTextfield.text.length > 6) {
        _codeTextfield.text = [_codeTextfield.text substringToIndex:6];
    }
    if (_pwdTextfield.text.length > 16) {
        [_pwdTextfield.undoManager removeAllActions];
        _pwdTextfield.text = [_pwdTextfield.text substringToIndex:16];
    }
    if (_graphTextfield.text.length > 4) {
        [_graphTextfield.undoManager removeAllActions];
        _graphTextfield.text = [_graphTextfield.text substringToIndex:4];
    }
    
    [self refreshCommitBtnEnable];
}

- (void)refreshCommitBtnEnable{
    if ( _pwdTextfield.text.length >= 6 && _pwdTextfield.text.length <= 16&&_codeTextfield.text.length >0&&_btn.checked) {
        [self.commitBtn setBackgroundImage:[UIImage imageNamed:@"button_red_background"] forState:UIControlStateNormal];
        self.commitBtn.userInteractionEnabled = YES;
    } else {
        [self.commitBtn setBackgroundColor:Color_GRAY];
        [self.commitBtn setBackgroundImage:[UIImage imageNamed:@"button_gray_background"] forState:UIControlStateNormal];
        self.commitBtn.userInteractionEnabled = NO;
    }
}

-(void)hiddenClick{
//    _inviteTextfield.hidden = NO;
//    _hiddenBtn.hidden = YES;
//
//    
//    CGRect rect = _inviteTextfield.frame;
//    rect.size.height = rect.size.height+44;
//    _inviteTextfield.frame = rect;
//    
//    CGRect rect1 = _commitBtn.frame;
//    rect1.origin.y = rect1.origin.y+44;
//    _commitBtn.frame = rect1;
//    
//    [_btn chageFrame];
    
    
    _inviteTextfield.hidden = NO;
    _hiddenBtn.hidden = YES;
    
    
    //修改下边距约束
    [self.inviteTextfield mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(44);
    }];
    
    [self.commitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_inviteTextfield).offset(64);
        make.height.mas_equalTo(44);
        
        
    }];
    
    [_btn chageFrame];
    
    [self.view layoutIfNeeded];

}

-(void)frameChange:(UITextField*)tf{

}

-(void)frameAdd:(UIButton*)btn{

}

//获取验证码
- (void)getRegisCode
{
    [self.getCodeBtn setTitleColor:Color_Response forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    NSString *strCaptcha = @"";
    if (_captchaUrl.length!=0&&_graphTextfield.text.length!=0) {
        strCaptcha = DSStringValue(_graphTextfield.text);
    }
    [self.request getRegisterWithDict:self.type == forgetPwd ? @{@"phone":self.phoneNumber,@"type":@"find_pwd"} : @{@"phone":self.phoneNumber,@"type":@"1",@"captcha":strCaptcha} onSuccess:^(NSDictionary *dictResult) {
        [UIButton startRunSecond:_getCodeBtn stringFormat:@"%@秒后重试" finishBlock:^{
            weakSelf.getCodeBtn.userInteractionEnabled = YES;
            [weakSelf.getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            [weakSelf.getCodeBtn setTitleColor:Color_Red forState:UIControlStateNormal];
        }];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self showMessage:errorMsg];
    }];
}


- (NSNumber *)swithNumberWithFloat:(CGFloat)fValue {
    return [NSNumber numberWithFloat:fValue];
}
#pragma mark - new 新加正则匹配只能输入数字和字母
- (BOOL)checkLoginCondition{
    
    
    if (_pwdTextfield.text.length > 0) {
        NSString *checkStr = _pwdTextfield.text;
        //        NSString *regex = @"^(?![\\d]+$)(?![a-zA-Z]+$)(?![^\\da-zA-Z]+$).{6,16}$";
        
        NSString *regex = @"^[0-9A-Za-z]{6,}$";
        if (![self isValid:checkStr withRegex:regex]) {
            
            [self showMessage:@"密码只能包含数字或字母"];
            return NO;
            
        };
    }
    
    
    return YES;
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
