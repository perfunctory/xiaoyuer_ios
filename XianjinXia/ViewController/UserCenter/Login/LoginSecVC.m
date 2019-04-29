//
//  LoginSecVC.m
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "LoginSecVC.h"
#import "UIImageView+lyt.h"
#import "UILabel+lyt.h"
#import "UITextField+lyt.h"
#import "UIButton+lyt.h"
#import <Lyt.h>
#import "UserManager.h"
#import "LoginOrRegistRequest.h"
#import "UserModel.h"
#import <YYModel/YYModel.h>
#import "XJXKeychain.h"
#import "XJXKeychainQuery.h"
#import "DXAlertView.h"
#import "FindPasswordVC.h"
#import <UMMobClick/MobClick.h>
#import "GetContactsBook.h"
#import "ForgetPassWordRequest.h"

@interface LoginSecVC ()<UIActionSheetDelegate>
@property (nonatomic, retain) UIImageView *photoImg;
@property (nonatomic, retain) UILabel *userNameLabel;
@property (nonatomic, retain) UITextField *pwdTf;
@property (nonatomic, retain) UIButton *nextBtn;
@property (nonatomic, retain) UIButton *forgetPwdBtn;
@property (nonatomic, retain) UIButton *moreBtn;
@property (nonatomic, strong) LoginOrRegistRequest *commitRequest;
@property (nonatomic, strong)ForgetPassWordRequest *requestForgetPassWord;

@end

@implementation LoginSecVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self umengEvent:UmengEvent_Login_Sec];
    UIScrollView *scvMain = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scvMain;
    self.view.backgroundColor = Color_White;
    self.title = @"信合宝";
    [self backArrowSet];

    [self createUI];
    
    [self viewAddEndEditingGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_userName && ![_userName isEqualToString:@""]) {
        _userNameLabel.text = _userName.length > 7 ? [_userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"] : _userName;
    } else if([UserManager sharedUserManager].userInfo.username && ![[UserManager sharedUserManager].userInfo.username isEqualToString:@""]) {
        _userNameLabel.text =  [UserManager sharedUserManager].userInfo.username.length > 7 ? [[UserManager sharedUserManager].userInfo.username stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"] : [UserManager sharedUserManager].userInfo.username;
        _userName = [UserManager sharedUserManager].userInfo.username;
    }
    
    
    _pwdTf.placeholder = (_tipStr&&![_tipStr isEqualToString:@""]) ? _tipStr : @"请输入登录密码";
}

- (LoginOrRegistRequest *)commitRequest{
    
    if (!_commitRequest) {
        _commitRequest = [[LoginOrRegistRequest alloc] init];
    }
    return _commitRequest;
}


- (void)createUI{
    
    _photoImg = [UIImageView getImageViewWithImageName:@"user_photo" superView:self.view lytSet:^(UIImageView *imageView) {
        [imageView lyt_alignTopToParentWithMargin:50];
        [imageView lyt_centerXInParent];
        [imageView lyt_setSize:CGSizeMake(100, 100)];
    }];
    
    _userNameLabel = [UILabel getLabelWithFontSize:15 textColor:Color_BLACK superView:self.view lytSet:^(UILabel *label) {
        [label lyt_placeBelowView:_photoImg margin:10];
        [label lyt_centerXInParent];
    }];
    
    _pwdTf = [UITextField getTextFieldWithFontSize:17 textColorHex:0x333333 placeHolder:@"请输入登录密码" superView:self.view lytSet:^(UITextField *textfield) {
        [textfield lyt_placeBelowView:_userNameLabel margin:20];
        [textfield lyt_alignLeftToParentWithMargin:15];
//        [textfield lyt_alignRightToParentWithMargin:15];
        [textfield lyt_setWidth:SCREEN_WIDTH - 30];
        [textfield lyt_setHeight:44];
    }];
    _pwdTf.layer.masksToBounds = YES;
    _pwdTf.layer.cornerRadius = 5.0f;
    _pwdTf.layer.borderWidth = 0.5f;
    _pwdTf.layer.borderColor = Color_Red.CGColor;
    [_pwdTf addTarget:self action:@selector(textfieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    //左边的锁
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pwd_icon"]];
    imgView.frame = CGRectMake(0, 0, 30, 44);
    imgView.contentMode = UIViewContentModeCenter;
    _pwdTf.leftView = imgView;
    _pwdTf.leftViewMode = UITextFieldViewModeAlways;
    _pwdTf.secureTextEntry = YES;
    _pwdTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _nextBtn = [UIButton getButtonWithFontSize:15 TextColorHex:Color_White backGroundColor:Color_GRAY superView:self.view lytSet:^(UIButton *button) {
        [button lyt_alignLeftToParentWithMargin:15];
//        [button lyt_alignRightToParentWithMargin:15];
        [button lyt_setWidth:SCREEN_WIDTH - 30];
        [button lyt_placeBelowView:_pwdTf margin:20];
        [button lyt_setHeight:40];
    }];
    _nextBtn.userInteractionEnabled = NO;
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"button_gray_background"] forState:UIControlStateNormal];
    [_nextBtn setTitle:@"登录" forState:UIControlStateNormal];
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.layer.cornerRadius = 5.0f;
    [_nextBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _forgetPwdBtn = [UIButton getButtonWithFontSize:15 TextColorHex:Color_Red backGroundColor:Color_White superView:self.view lytSet:^(UIButton *button) {
        [button lyt_placeBelowView:_nextBtn margin:iPhone4 ? 5 : 10];
        [button lyt_centerXInParent];
        [button lyt_setWidth:150];
        [button lyt_setHeight:35];
    }];
    [_forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forgetPwdBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _moreBtn = [UIButton getButtonWithFontSize:15 TextColorHex:Color_Red backGroundColor:Color_White superView:self.view lytSet:^(UIButton *button) {
//        [button lyt_alignBottomToParentWithMargin:iPhone4 ? 40 : 100];
        [button lyt_placeAboveView:_forgetPwdBtn margin:iPhone4? -100 : -250];
        if (iPhone5) {
            [button lyt_placeAboveView:_forgetPwdBtn margin:-150];
        }
        [button lyt_centerXInParent];
        [button lyt_setWidth:100];
        [button lyt_setHeight:35];
    }];
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
}


- (void)moreBtnClick
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"注册",@"切换用户", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 || buttonIndex == 1) {
        //切换用户
        if (self.reLoginSetUserName) {
            self.reLoginSetUserName(@"");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark -- 忘记密码
- (void)forgetBtnClick
{
    //先发送短信
    if (_userName.length == 11) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_userName, @"phone",@"find_pwd",@"type",@"0",@"type2",nil];
        [self showLoading:@""];
        [self.requestForgetPassWord resetPwdCodeWithDict:params onSuccess:^(NSDictionary *dictResult) {
            [self hideLoading];
            [self umengEvent:UmengEvent_ForgetPwd];
            FindPasswordVC *vcFindPassword = [[FindPasswordVC alloc]init];
            vcFindPassword.forgetType = login;
            vcFindPassword.phoneNumber = _userName;
            vcFindPassword.captchaUrl =  dictResult[@"item"][@"captchaUrl"];
            [self dsPushViewController:vcFindPassword animated:YES];
            
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [self showMessage:errorMsg];
        }];
    }else{
        DXAlertView* alertView = [[DXAlertView alloc] initWithTitle:nil contentText:@"手机号码格式不正确"  leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alertView show];
    }   
}

-(ForgetPassWordRequest *)requestForgetPassWord{
    if (!_requestForgetPassWord) {
        _requestForgetPassWord = [ForgetPassWordRequest new];
    }
    return _requestForgetPassWord;
}

#pragma mark -- 提交
- (void)commitBtnClick
{
    
    if(![self checkLoginCondition]){
        return;
    }
    
    //隐藏键盘
    [_pwdTf resignFirstResponder];
    [self showLoading:@""];
    
    __weak typeof(self) weakSelf = self;
    [self.commitRequest LoginWithDict:@{@"username":_userName ? _userName : @"",@"password":_pwdTf.text} onSuccess:^(NSDictionary *dictResult) {
        
        
        [self hideLoading];
        //存储用户信息
        if (![XJXKeychain passwordForService:kXJXKeychainErrorDomain account:_userName]) {//查看本地是否存储指定 serviceName 和 account 的密码
            
            //如果没设置密码则 设定密码 并存储
            [XJXKeychain setPassword:_pwdTf.text forService:kXJXKeychainErrorDomain account:_userName];
            
            //打印密码信息
            NSString *retrieveuuid = [XJXKeychain passwordForService:kXJXKeychainErrorDomain account:_userName];
            NSLog(@"XJXKeychain存储显示: 未安装过:%@", retrieveuuid);
            
        }else{
            //曾经安装过 则直接能打印出密码信息(即使删除了程序 再次安装也会打印密码信息) 区别于 NSUSerDefault
            NSString *retrieveuuid = [XJXKeychain passwordForService:kXJXKeychainErrorDomain account:_userName];
            NSLog(@"XJXKeychain存储显示 :已安装过:%@", retrieveuuid);
            
        }
        [MobClick profileSignInWithPUID:_userName];
        [[UserManager sharedUserManager] updateUserInfo:dictResult[@"item"]];
//        [[GetContactsBook shareControl] upLoadAddressBook];
        //页面跳转到我的
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [[[DXAlertView alloc] initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"] show];
        [self hideLoading];
    }];
    

}

#pragma mark -- 监听textField
- (void)textfieldEditChanged:(UITextField *)tf
{
    if (tf.text.length > 16) {
        [tf.undoManager removeAllActions];
        tf.text = [tf.text substringToIndex:16];
    }
    
    if (tf.text.length >= 6) {
        _nextBtn.userInteractionEnabled = YES;
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"button_red_background"] forState:UIControlStateNormal];
    } else {
        _nextBtn.userInteractionEnabled = NO;
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"button_gray_background"] forState:UIControlStateNormal];
    }
}

- (NSNumber *)swithNumberWithFloat:(CGFloat)fValue {
    return [NSNumber numberWithFloat:fValue];
}


#pragma mark - new 新加正则匹配只能输入数字和字母
- (BOOL)checkLoginCondition{
   
    
    if (_pwdTf.text.length > 0) {
        NSString *checkStr = _pwdTf.text;
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


//-(void) doClickBackAction{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

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
