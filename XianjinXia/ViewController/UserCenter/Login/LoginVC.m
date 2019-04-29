//
//  LoginVC.m
//  XianjinXia
//
//  Created by lxw on 17/1/23.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "LoginVC.h"
#import "UIImageView+lyt.h"
#import "UILabel+lyt.h"
#import "UITextField+lyt.h"
#import "UIButton+lyt.h"
#import <Lyt.h>
#import "KDKeyboardView.h"
#import "IQKeyboardManager.h"
#import "LoginOrRegistRequest.h"
#import "LoginSecVC.h"
#import "RegisterVC.h"
#import "DXAlertView.h"

@interface LoginVC ()<KDTextfieldDelegate>

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) NSUndoManager *manager;
@property (nonatomic, strong) LoginOrRegistRequest *request;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self umengEvent:UmengEvent_Login_First];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"信合宝";
    UIScrollView *scvMain = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scvMain;
    self.view.backgroundColor = Color_White;
    //隐藏IQkeyBoard键盘的Toolbar
//    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
    
    UIBarButtonItem *cancelLeftBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(doClickBackAction)];
    self.navigationItem.leftBarButtonItem = cancelLeftBtn;
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [self viewAddEndEditingGesture];
    [self createUI];
}

- (LoginOrRegistRequest *)request{
    
    if (!_request) {
        _request = [[LoginOrRegistRequest alloc] init];
    }
    
    return _request;
}



- (void)createUI{
    
    __weak typeof(self) weakSelf = self;
    //*****上面的圆角图片 user_default
    _imageView = [UIImageView getImageViewWithImageName:@"" superView:self.view lytSet:^(UIImageView *imageView) {
        [imageView lyt_centerXInParent];
        [imageView lyt_alignTopToParentWithMargin:0];
        [imageView lyt_setSize:CGSizeMake(185, 20)];
    }];
    //设置圆角
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 5.0f;
    
    //*****手机号输入框
    _textField = [UITextField getTextFieldWithFontSize:15 textColorHex:0x333333 placeHolder:@"请输入注册/登录手机号" superView:self.view lytSet:^(UITextField *textfield) {
        [textfield lyt_placeBelowView:weakSelf.imageView margin:50];
        [textfield lyt_alignLeftToParentWithMargin:15];
        //        [textfield lyt_alignRightToParentWithMargin:15];
        [textfield lyt_setWidth:SCREEN_WIDTH - 30];
        [textfield lyt_setHeight:44];
    }];
    
    [KDKeyboardView KDKeyBoardWithKdKeyBoard:TELEPHONE target:self textfield:_textField delegate:self valueChanged:@selector(textFieldValueChanged:)];
    //左边的手机小图标
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone"]];
    imgView.contentMode =  UIViewContentModeBottomRight;
    imgView.frame = CGRectMake(0, 0, 32, 44);
    imgView.contentMode = UIViewContentModeCenter;
    _textField.leftView = imgView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    //设置圆角
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 5.0f;
    _textField.layer.borderColor = Color_Red.CGColor;
    _textField.layer.borderWidth = 0.5f;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //*****下一步按钮
    _button = [UIButton getButtonWithFontSize:15 TextColorHex:Color_White backGroundColor:nil superView:self.view lytSet:^(UIButton *button) {
        [button lyt_alignLeftToParentWithMargin:15];
        //        [button lyt_alignRightToParentWithMargin:15];
        [button lyt_setWidth:SCREEN_WIDTH - 30];
        [button lyt_setHeight:40];
        [button lyt_placeBelowView:weakSelf.textField margin:20];
    }];
    [_button setTitle:@"下一步" forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"button_gray_background"] forState:UIControlStateNormal];
    _button.userInteractionEnabled = NO;
    [_button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    //设置圆角
}


- (void)textFieldValueChanged:(UITextField *)textfield
{
    
    if (textfield.text.length > 11) {
        textfield.text = [textfield.text substringToIndex:11];
        [textfield.undoManager removeAllActions];
    }
    if (textfield.text.length == 11) {
        [self.button setBackgroundImage:[UIImage imageNamed:@"button_red_background"] forState:UIControlStateNormal];
        self.button.userInteractionEnabled = YES;
    } else {
        [self.button setBackgroundImage:[UIImage imageNamed:@"button_gray_background"] forState:UIControlStateNormal];
        self.button.userInteractionEnabled = NO;
    }
}

- (void)btnClick
{
    [self showLoading:@""];
    __weak typeof(self) weakSelf = self;
    [self.request checkPhoneNumberWithDict:@{@"phone":self.textField.text,@"type":@"0"} onSuccess:^(NSDictionary *dictResult) {
        [weakSelf hideLoading];
        //代表手机号为注册,并发送验证码
        RegisterVC *registerVC = [[RegisterVC alloc] initWithPageType:registerSec];
        registerVC.phoneNumber = self.textField.text;
        registerVC.captchaUrl = DSStringValue(dictResult[@"item"][@"captchaUrl"]);
        [weakSelf.navigationController pushViewController:registerVC animated:YES];

    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [weakSelf hideLoading];
        //200 该手机号以注册
        if (code == 1000) {
            LoginSecVC *secVC = [LoginSecVC new];
            secVC.userName = self.textField.text;
            secVC.reLoginSetUserName = ^(NSString *userName){
                weakSelf.textField.text = userName;
            };
            secVC.tipStr = errorMsg;
            [weakSelf.navigationController  pushViewController:secVC animated:YES];
        }else{
            [self showMessage:errorMsg];
        }
    }];
}

-(void) doClickBackAction{
    [_textField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSNumber *)swithNumberWithFloat:(CGFloat)fValue {
    return [NSNumber numberWithFloat:fValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
