//
//  ChangePasswordVC.m
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "FindPasswordVC.h"
#import "FindPayPassWordVC.h"
#import "UserManager.h"
#import "KDKeyboardView.h"
#import "DXAlertView.h"
#import "ChangePassWordRequest.h"
#import "ForgetPassWordRequest.h"

@interface ChangePasswordVC ()<KDTextfieldDelegate>

@property(nonatomic,retain)UILabel* titleLabel;
@property (nonatomic, retain)UILabel* tipLabel;
@property(nonatomic,retain)UITextField* intrinsicPswTf;
@property(nonatomic,retain)UITextField* pswTf;
@property(nonatomic,retain)UITextField* againNewPswTf;
@property(nonatomic,retain)UIScrollView *baseView;
@property(nonatomic,retain)UIButton* button;
@property (nonatomic, strong) ChangePassWordRequest *requestChangePassWord;
@property (nonatomic, strong)ForgetPassWordRequest *requestForgetPassWord;

@end

@implementation ChangePasswordVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_passwordType == loginChange) {
        self.navigationItem.title = @"修改登录密码";
        _tipLabel.text = @"登录密码须为6~16位字符，区分大小写";
    }
    if (_passwordType == payChange) {
        self.navigationItem.title = @"修改交易密码";
        _intrinsicPswTf.keyboardType = UIKeyboardTypeNumberPad;
        _pswTf.keyboardType = UIKeyboardTypeNumberPad;
        _againNewPswTf.keyboardType = UIKeyboardTypeNumberPad;
        _tipLabel.text = @"交易密码为6位数字";
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
    _baseView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - 64);
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    UIBarButtonItem *rightBtn1 = [[UIBarButtonItem alloc]initWithTitle:@"忘记" style:UIBarButtonItemStylePlain target:self action:@selector(pressRight1)];
    [rightBtn1 setTitleTextAttributes:@{NSForegroundColorAttributeName: Color_White} forState:normal];
    self.navigationItem.rightBarButtonItem = rightBtn1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAllKeyBoards)];
    [self.view addGestureRecognizer:tap];
    
    NSString* name = [[UserManager sharedUserManager].userInfo username];
    if (name.length>0) {
        name = [NSString stringWithFormat:@"%@****%@",[name substringToIndex:3],[name substringWithRange:NSMakeRange(7, 4)]];
    }
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, self.view.frame.size.width, 25)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = [NSString stringWithFormat:@"%@",name];
    _titleLabel.font = [UIFont systemFontOfSize:25];
    [_baseView addSubview:_titleLabel];
    
    _intrinsicPswTf = [self makeTextFieldWIthFrame:CGRectMake(15, 68, self.view.frame.size.width-30, 44) placeholder:@"请输入原密码"];
    [_baseView addSubview:_intrinsicPswTf];
    
    _pswTf = [self makeTextFieldWIthFrame:CGRectMake(15, 68 + 44 + 7, self.view.frame.size.width-30, 44) placeholder:@"请输入新密码"];
    [_baseView addSubview:_pswTf];
    
    _againNewPswTf = [self makeTextFieldWIthFrame:CGRectMake(15, 68 + 44 + 7 + 44 + 7,  self.view.frame.size.width-30, 44) placeholder:@"请确认新密码"];
    [_baseView addSubview:_againNewPswTf];
    
    if (_passwordType == payChange) {
        
        [KDKeyboardView KDKeyBoardWithKdKeyBoard:PAYPASSWORD target:self textfield:_intrinsicPswTf delegate:self valueChanged:@selector(textfieldChanged:)];
        [KDKeyboardView KDKeyBoardWithKdKeyBoard:PAYPASSWORD target:self textfield:_pswTf delegate:self valueChanged:@selector(textfieldChanged:)];
        [KDKeyboardView KDKeyBoardWithKdKeyBoard:PAYPASSWORD target:self textfield:_againNewPswTf delegate:self valueChanged:@selector(textfieldChanged:)];
        
    }
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _againNewPswTf.frame.origin.y + _againNewPswTf.frame.size.height + 10, SCREEN_WIDTH, 20)];
    _tipLabel.font = [UIFont systemFontOfSize:13];
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.textColor = [UIColor colorWithHex:0x999999];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [_baseView addSubview:_tipLabel];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(15, _tipLabel.frame.size.height + _tipLabel.frame.origin.y + 10,  self.view.frame.size.width-30, 44)];
    _button.backgroundColor = [UIColor colorWithHex:0xb7b7b7];
    [_button setTitle:@"完成" forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:17];
    [_button.layer setMasksToBounds:YES];
    [_button.layer setCornerRadius:3.0f];
    _button.userInteractionEnabled = NO;
    [_button addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_button];
}

#pragma mark - 初始化数据源

- (void)setUpDataSource{
    
}

#pragma mark - 按钮事件

-(void)pressRight1
{
    [self.baseView setContentOffset:CGPointMake(0, 0)];
    [self.intrinsicPswTf resignFirstResponder];
    [self.pswTf resignFirstResponder];
    [self.againNewPswTf resignFirstResponder];
    if (_passwordType == loginChange) {
        
        NSDictionary *params;
        NSString *strCaptcha = @"";
        
        params = [NSDictionary dictionaryWithObjectsAndKeys:[UserManager sharedUserManager].userInfo.username, @"phone",@"find_pwd",@"type",@"0",@"type2",strCaptcha,@"captcha",nil];
        
        
        [self.requestForgetPassWord resetPwdCodeWithDict:params onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            FindPasswordVC *vcFindPassword = [[FindPasswordVC alloc]init];
            vcFindPassword.forgetType = _passwordType == loginChange ?login :pay;
            vcFindPassword.phoneNumber = [UserManager sharedUserManager].userInfo.username;
            //    gester.isRealName = [NSString stringWithFormat:@"%zd",[UserManager sharedUser].isRealCert];
            [self dsPushViewController:vcFindPassword animated:YES];
            
            
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
            
        }];
        

        
//        FindPasswordVC *vcFindPassword = [[FindPasswordVC alloc]init];
//        vcFindPassword.forgetType = _passwordType == loginChange ?login :pay;
//        vcFindPassword.phoneNumber = [UserManager sharedUserManager].userInfo.username;
//        //    gester.isRealName = [NSString stringWithFormat:@"%zd",[UserManager sharedUser].isRealCert];
//        [self dsPushViewController:vcFindPassword animated:YES];
//        [self.navigationController pushViewController:vcFindPassword animated:YES];
    }else if (_passwordType == payChange){
        FindPayPassWordVC *vcFindPayPassWord = [[FindPayPassWordVC alloc]init];
        vcFindPayPassWord.forgetType = payPay;
        vcFindPayPassWord.phoneNumber = [UserManager sharedUserManager].userInfo.username;
        //    gester.isRealName = [NSString stringWithFormat:@"%zd",[UserManager sharedUser].isRealCert];
        [self dsPushViewController:vcFindPayPassWord animated:YES];
//        [self.navigationController pushViewController:vcFindPayPassWord animated:YES];
    }
}

-(void) hideAllKeyBoards{
    NSMutableArray *subviews = [NSMutableArray arrayWithArray:[_baseView subviews]];
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

-(void)changePassword
{
    //    [GToolUtil textfieldResignFirstResponder:self.view];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    DXAlertView* alertView;
    
    NSString *contentText = @"密码长度要在6~16位哦";
    if (_intrinsicPswTf.text.length < 6 || _pswTf.text.length < 6 || _againNewPswTf.text.length < 6) {
        if (_passwordType != loginChange) {
            contentText = @"密码长度为6位数字哦";
        }
    }else if (![_pswTf.text isEqualToString:_againNewPswTf.text]) {
        contentText = @"两次新密码输入不一致哦";
    }else{
        
        if (_passwordType == loginChange) {
            if(![self checkLoginCondition]){
                return;
            }
        }
        NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:_againNewPswTf.text,@"new_pwd",_intrinsicPswTf.text,@"old_pwd", nil];
        [self showLoading:@""];
         if (_passwordType == loginChange) {
             
        [self.requestChangePassWord changePassWordWithDict:param onSuccess:^(NSDictionary *dictResult) {
                 [self hideLoading];
            DXAlertView* alertView = [[DXAlertView alloc] initWithTitle:nil contentText:@"登录密码修改成功！" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alertView.rightBlock = ^{
                [self popVC];
            };
            [self hideAllKeyBoards];
            [alertView show];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
        } isLoginPassWord:@"1"];
         }else if (_passwordType == payChange){
             [self.requestChangePassWord changePassWordWithDict:param onSuccess:^(NSDictionary *dictResult) {
                 [self hideLoading];
                 DXAlertView* alertView = [[DXAlertView alloc] initWithTitle:nil contentText:@"交易密码修改成功！" leftButtonTitle:nil rightButtonTitle:@"确定"];
                 alertView.rightBlock = ^{
                     [self popVC];
                 };
                 [self hideAllKeyBoards];
                 [alertView show];
             } andFailed:^(NSInteger code, NSString *errorMsg) {
                 [self hideLoading];
                 [self showMessage:errorMsg];
             } isLoginPassWord:@"0"];
         }
//        self.getData.param = param;
//        __weak typeof(self) weakSelf = self;
//        [self.getData loadDataWithSuccess:^(NSDictionary *data) {
//            
//        [self getInfoSucess:@{@"message":@"13213",@"code":@"0"}];
//        } falid:^(NSString *msg) {
//            
//            if (nil == msg || ![msg isKindOfClass:[NSString class]]) {
//                msg = @"当前网络断开啦，请检查网络连接";
//            }
//            [[iToast makeText:msg] show];
//        }];
        [self baseViewToHome];
        return;
    }
    alertView = [[DXAlertView alloc] initWithTitle:nil contentText:contentText leftButtonTitle:nil rightButtonTitle:@"确定"];
    alertView.rightBlock = ^{
        [self baseViewToHome];
    };
    [alertView show];
}


#pragma mark - Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField.layer setBorderColor:Color_Red.CGColor];
    if (SCREEN_HEIGHT <= 568) {
        [_baseView setContentOffset:CGPointMake(0, _intrinsicPswTf.frame.origin.y) animated:YES];
    }
    textField.text = @"";
    if (SCREEN_HEIGHT <= 480) {
        if (textField == _pswTf||textField == _againNewPswTf) {
            [_baseView setContentOffset:CGPointMake(0, _pswTf.frame.origin.y) animated:YES];
        }
    }
    [self buttonToGray];
}

-(void)textfieldChanged:(UITextField*)textfield
{
    if (_intrinsicPswTf.text.length > 0 && _pswTf.text.length && _againNewPswTf.text.length > 0) {
        _button.backgroundColor = Color_Red;
        _button.userInteractionEnabled = YES;
    }else{
        [self buttonToGray];
    }
    NSInteger textfieldLength = _passwordType == payChange ? 6 : 16;
    if (textfield.text.length > textfieldLength) {
        textfield.text = [textfield.text substringToIndex:textfieldLength];
    }
    if (_passwordType == payChange) {
        
        if (_intrinsicPswTf.text.length > 6) {
            _intrinsicPswTf.text = [_intrinsicPswTf.text substringToIndex:6];
        }
        if (_pswTf.text.length > 6) {
            _pswTf.text = [_pswTf.text substringToIndex:6];
        }
        if (_againNewPswTf.text.length > 6) {
            _againNewPswTf.text = [_againNewPswTf.text substringToIndex:6];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField.layer setBorderColor:[UIColor colorWithHex:0x999999].CGColor];
}

#pragma mark - 请求数据

#pragma mark - Other

-(ChangePassWordRequest *)requestChangePassWord{
    if (!_requestChangePassWord) {
        _requestChangePassWord = [ChangePassWordRequest new];
    }
    return _requestChangePassWord;
}

-(ForgetPassWordRequest *)requestForgetPassWord{
    if (!_requestForgetPassWord) {
        _requestForgetPassWord = [ForgetPassWordRequest new];
    }
    return _requestForgetPassWord;
}

-(void)baseViewToHome
{
    [UIView animateWithDuration:0.3 animations:^{
        _baseView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
    }];
}

-(UITextField*)makeTextFieldWIthFrame:(CGRect)frame placeholder:(NSString*)placeHolder
{
    UITextField* textfield = [[UITextField alloc] initWithFrame:frame];
    [textfield.layer setMasksToBounds:YES];
    [textfield.layer setCornerRadius:3.0f];
    [textfield.layer setBorderColor:[UIColor colorWithHex:0x999999].CGColor];
    [textfield.layer setBorderWidth:0.5f];
    textfield.delegate = self;
    textfield.placeholder = placeHolder;
    textfield.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing |UITextFieldViewModeUnlessEditing;
    textfield.font = [UIFont systemFontOfSize:16];
    textfield.secureTextEntry = YES;
    textfield.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25/2, 44)];
    textfield.leftViewMode = UITextFieldViewModeAlways;
    [textfield addTarget:self action:@selector(textfieldChanged:) forControlEvents:UIControlEventEditingChanged];
    return textfield;
}

- (BOOL)commitBtnClick:(KDKeyboardView *)keyboardView
{
    if (_intrinsicPswTf.text.length > 0 && _pswTf.text.length && _againNewPswTf.text.length > 0) {
        
        [self changePassword];
        return YES;
    }
    return NO;
}

- (void)hideKeyBoard:(KDKeyboardView *)keyboardView
{
    [self hideAllKeyBoards];
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
////    [textField.layer setBorderColor:Color_Red.CGColor];
////    if (SCREEN_HEIGHT <= 568) {
////        [_baseView setContentOffset:CGPointMake(0, _intrinsicPswTf.frame.origin.y) animated:YES];
////    }
//    return YES;
//}


-(void)buttonToGray
{
    _button.backgroundColor = [UIColor colorWithHex:0xb7b7b7];
    _button.userInteractionEnabled = NO;
}

#pragma mark - new 新加正则匹配只能输入数字和字母
- (BOOL)checkLoginCondition{
    
    if (_againNewPswTf.text.length > 0) {
        NSString *checkStr = _againNewPswTf.text;
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
