//
//  NewPasswordVC.m
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "NewPasswordVC.h"
#import "DXAlertView.h"
#import "KDKeyboardView.h"
#import "NSString+Frame.h"
#import "ForgetPassWordRequest.h"
#import "PayPassWordRequest.h"

@interface NewPasswordVC ()<KDTextfieldDelegate,UITextFieldDelegate>

@property(nonatomic,retain)UITextField* password;
@property(nonatomic,retain)UITextField* rPassword;
@property(nonatomic,retain)UIButton* button;

@property(nonatomic,retain)UIView* baseView;

@property(nonatomic,retain)UILabel* label;

@property (nonatomic, strong)ForgetPassWordRequest *requestForgetPassWord;

@property (nonatomic, strong)PayPassWordRequest *requestPayPassWord;

@end

@implementation NewPasswordVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshUI];
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
    self.navigationItem.title = @"输入新密码";
    self.view.backgroundColor = [UIColor whiteColor];
    _baseView = [[UIView alloc] initWithFrame:self.view.bounds];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAllKeyBoards)];
    [_baseView addGestureRecognizer:tap];
    if (IOS7) {
        _password = [[UITextField alloc] initWithFrame:CGRectMake(15, 30, self.view.frame.size.width - 30, 44)];
    }else
    {
        _password = [[UITextField alloc] initWithFrame:CGRectMake(15, 20, self.view.frame.size.width - 30, 44)];
    }
    
    [_password.layer setMasksToBounds:YES];
    [_password.layer setCornerRadius:3.0f];
    [_password.layer setBorderColor:[UIColor colorWithHex:0x999999].CGColor];
    [_password addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_password.layer setBorderWidth: .5f];
    _password.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    _password.placeholder = @"请输入新密码";
    _password.secureTextEntry = YES;
    _password.delegate = self;
    [_baseView addSubview:_password];
    
    if ([_forgetType isEqualToString:@"pay"]) {
        
        [KDKeyboardView KDKeyBoardWithKdKeyBoard:PAYPASSWORD target:self textfield:_password delegate:self valueChanged:@selector(textFieldChanged:)];
    }
    
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    _password.leftView = view1;
    _password.leftViewMode = UITextFieldViewModeAlways;
    if (IOS7) {
        _rPassword = [[UITextField alloc] initWithFrame:CGRectMake(15, 30 + 44 + 8, self.view.frame.size.width - 30, 44)];
    }else
    {
        _rPassword = [[UITextField alloc] initWithFrame:CGRectMake(15, 30 + 34 + 8, self.view.frame.size.width - 30, 44)];
    }
    
    [_rPassword.layer setMasksToBounds:YES];
    [_rPassword.layer setCornerRadius:3.0f];
    _rPassword.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    [_rPassword.layer setBorderColor:[UIColor colorWithHex:0x999999].CGColor];
    [_rPassword addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_rPassword.layer setBorderWidth:.5f];
    _rPassword.placeholder = @"确认新密码";
    _rPassword.secureTextEntry = YES;
    _rPassword.delegate = self;
    [_baseView addSubview:_rPassword];
    
    if ([_forgetType isEqualToString:@"pay"]) {
        [KDKeyboardView KDKeyBoardWithKdKeyBoard:PAYPASSWORD target:self textfield:_rPassword delegate:self valueChanged:@selector(textFieldChanged:)];
    }
    
    UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    _rPassword.leftView = view2;
    _rPassword.leftViewMode = UITextFieldViewModeAlways;
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.textColor = [UIColor colorWithHex:0x666666];
    _label.font = [UIFont systemFontOfSize:12];
    [_baseView addSubview:_label];
    
    if (IOS7) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(15,  30 + 44 + 8 + 44 + 8 + 12 + 12 + 12, self.view.frame.size.width - 30, 45)];
    }else
    {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(15,  30 + 44 + 8 + 44 + 8 + 12 + 12 + 12-15, self.view.frame.size.width - 30, 45)];
    }
    
    _button.backgroundColor = [UIColor colorWithHex:0xb7b7b7];
    [_button.layer setMasksToBounds:YES];
    [_button.layer setCornerRadius:3.0f];
    [_button setTitle:@"完成" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(changePasswordTouch) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_button];

}

#pragma mark - 初始化数据源

- (void)setUpDataSource{
    
}

#pragma mark - 按钮事件

//点击外面隐藏键盘
-(void) hideAllKeyBoards{
    NSArray *allSubviews = [_baseView subviews];
    for (id objInput in allSubviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
                break;
            }
        }
    }
}

- (BOOL)commitBtnClick:(KDKeyboardView *)keyboardView
{
    if (_password.text.length > 0 && _rPassword.text.length > 0) {
        
        [self changePasswordTouch];
        return YES;
    }
    return NO;
}

#pragma mark - Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = Color_Red.CGColor;
    if (textField == _password) {
        _password.text =@"";
    }
    if (textField == _rPassword) {
        _rPassword.text =@"";
    }
    _button.backgroundColor = [UIColor colorWithHex:0xb7b7b7];
    _button.userInteractionEnabled =NO;
}

- (void)hideKeyBoard:(KDKeyboardView *)keyboardView
{
    [self hideAllKeyBoards];
}

-(void)textFieldChanged:(UITextField*)textfield
{
    if (_password.text.length > 0 && _rPassword.text.length > 0) {
        _button.backgroundColor = Color_Red;
        _button.userInteractionEnabled = YES;
    }else{
        _button.backgroundColor = [UIColor colorWithHex:0xb7b7b7];
        _button.userInteractionEnabled = NO;
    }
    
    if ([_forgetType isEqualToString:@"login"]) {
        if (textfield.text.length > 16) {
            [textfield.undoManager removeAllActions];
            textfield.text = [textfield.text substringToIndex:16];
        }
    }else{
        if (_password.text.length > 6) {
            _password.text = [_password.text substringToIndex:6];
        }
        if (_rPassword.text.length > 6) {
            [_rPassword.undoManager removeAllActions];
            _rPassword.text = [_rPassword.text substringToIndex:6];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1111) {
        
    }else{
        
    }
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    textField.layer.borderColor = Color_Red.CGColor;
//    return YES;
//}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = [UIColor colorWithHex:0xb7b7b7].CGColor;
    return YES;
}
#pragma mark - 请求数据

#pragma mark - Other

-(ForgetPassWordRequest *)requestForgetPassWord{
    if (!_requestForgetPassWord) {
        _requestForgetPassWord = [ForgetPassWordRequest new];
    }
    return _requestForgetPassWord;
}

-(PayPassWordRequest *)requestPayPassWord{
    if (!_requestPayPassWord) {
        _requestPayPassWord = [PayPassWordRequest new];
    }
    return _requestPayPassWord;
}
-(void)refreshUI
{
    if ([_forgetType isEqualToString:@"login"]) {
        self.navigationItem.title = @"输入新登录密码";
        CGFloat width = [@"登录密码须为6~16位字符，区分大小写" widthWithFontSize:12];;
        if (IOS7) {
            _label.frame = CGRectMake((self.view.frame.size.width - width)/2, 30 + 44 + 8 + 44 + 8 + 12, width, 12);
        }else
        {
            _label.frame = CGRectMake((self.view.frame.size.width - width)/2, 30 + 44 + 8 + 44 + 8 + 12-15, width, 12);
        }
        
        _label.text = @"登录密码须为6~16位字符，区分大小写";
    }else{
        self.navigationItem.title = @"输入新交易密码";
        CGFloat width = [@"交易密码由6位数字组成" widthWithFontSize:12];;
        if (IOS7) {
            _label.frame = CGRectMake((self.view.frame.size.width - width)/2, 30 + 44 + 8 + 44 + 8 + 12, width, 12);
        }else
        {
            _label.frame = CGRectMake((self.view.frame.size.width - width)/2, 30 + 44 + 8 + 44 + 8 + 12-15, width, 12);
        }
        _label.text = @"交易密码由6位数字组成";
    }
    
    if (![_forgetType isEqualToString:@"login"]) {
        _password.keyboardType = UIKeyboardTypeNumberPad;
        _rPassword.keyboardType = UIKeyboardTypeNumberPad;
    }
}

-(void)changePasswordTouch
{
    [self hideAllKeyBoards];
    if (![_password.text isEqualToString:_rPassword.text]) {
        [self showMessage:@"您输入的两次密码不一致哦"];
        return;
    }
    if ([_forgetType isEqualToString:@"login"]) {
        if (_password.text.length < 6 || _password.text.length > 16) {
            [self showMessage:@"登录密码须由6~16位字母或数字组成"];
            return;
        }
        
    }else{
        if (_password.text.length != 6) {
            [self showMessage:@"交易密码为六位数字"];
            return;
        }
    }
    
    NSDictionary *params;
    if (!_idCard) {
        _idCard =@"";
    }
    if (!_realName) {
        _realName =@"";
    }
    if ([_forgetType isEqualToString:@"login"]) {
        
        if (![self checkLoginCondition]) {
            return;
        }
        params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber, @"phone",_code, @"code",_rPassword.text, @"password",nil];//,_idCard, @"id_card",_realName, @"realname"
        
        [self showLoading:@""];
        [self.requestForgetPassWord resetPasswordWithDict:params onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            DXAlertView* alertView = [[DXAlertView alloc] initWithTitle:nil contentText:@"您的密码修改成功！" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alertView.tag = 1111;
            [self hideAllKeyBoards];
            [alertView show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hideAlertView) userInfo:nil repeats:NO];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
        }];
        
    }else{
        params = [NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber, @"phone",_code, @"code",_rPassword.text, @"password",nil];//,_idCard, @"id_card",_realName, @"realname"
        [self showLoading:@""];
        [self.requestPayPassWord resetPayPasswordWithDict:params onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            DXAlertView* alertView = [[DXAlertView alloc] initWithTitle:nil contentText:@"您的密码修改成功！" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alertView.tag = 1111;
            [self hideAllKeyBoards];
            [alertView show];
            [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hideAlertView) userInfo:nil repeats:NO];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
        }];
    }

//    self.changePasswordAct.param = params;
//    __weak typeof(self) weakSelf = self;
//    [self.changePasswordAct loadDataWithSuccess:^(NSDictionary *data) {
    
//        [self postSucess:@{@"code":@"0",@"message":@"123"}];
//    } falid:^(NSString *msg) {
//        
//        if (nil == msg || ![msg isKindOfClass:[NSString class]]) {
//            msg = @"当前网络断开啦，请检查网络连接";
//        }
//        [[iToast makeText:msg] show];
//    }];
}

//-(void)postSucess:(NSDictionary*)datas
//{
//    [self hideAllKeyBoards];
//    if([[NSString stringWithFormat:@"%@",datas[@"code"]] isEqualToString:@"0"]){
//        DXAlertView* alertView = [[DXAlertView alloc] initWithTitle:nil contentText:@"您的密码修改成功！" leftButtonTitle:nil rightButtonTitle:@"确定"];
//        alertView.tag = 1111;
//        [self hideAllKeyBoards];
//        [alertView show];
//        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hideAlertView) userInfo:nil repeats:NO];
//    }else{
//        [self showMessage:[NSString stringWithFormat:@"%@",datas[@"message"]]];
//    }
//}

-(void)hideAlertView
{
    [[self.view viewWithTag:1111] removeFromSuperview];
    NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
    if (index >= 4) {
        NSString *str =[NSString stringWithFormat:@"%@",[[self.navigationController.viewControllers objectAtIndex:index-3] class]];
        //     //当控制器中又账户中心，判断然后跳转
        if ([str isEqualToString:@"KDMySetVC"]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-3]animated:YES];
        }else{
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-3]animated:YES];
        }
    }else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
    }
}


#pragma mark - new 新加正则匹配只能输入数字和字母
- (BOOL)checkLoginCondition{
    
    
    if (_rPassword.text.length > 0) {
        NSString *checkStr = _rPassword.text;
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


@end
