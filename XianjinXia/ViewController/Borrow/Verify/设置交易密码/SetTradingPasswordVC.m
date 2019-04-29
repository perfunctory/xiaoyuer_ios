//
//  SetTradingPasswordVC.m
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SetTradingPasswordVC.h"
#import "KDKeyboardView.h"
#import "UserManager.h"
#import "PayPassWordRequest.h"
#import "PayPasswordErrowView.h"
#import "UITextField+lyt.h"
#import <Lyt.h>

@interface SetTradingPasswordVC ()<KDTextfieldDelegate>

//描述文案
@property (nonatomic, retain) UILabel *descLabel;
//交易密码输入框
@property (nonatomic, retain) UITextField *textfield;
//下一步按钮
@property (nonatomic, retain) UIButton *nextBtn;
@property (nonatomic, retain) NSMutableArray *keyArr;
@property (nonatomic, strong) PayPassWordRequest *requestPayPassWord;
//*********************华丽的分割线********************

@property (nonatomic, assign) KDPayPasswordType payType;

@end

@implementation SetTradingPasswordVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.payType == 0 ? @"设置交易密码" : @"确认交易密码";
    self.view.backgroundColor = [UIColor colorWithHex:0xeff3f5];
    
    
    if (self.payType ==0) {//密码错误的时候重新设置需要将内容原来的设置清空
        self.textfield.text = @"";
        for (UILabel *label in _keyArr) {
            
            label.text = @"";
        }
    }

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"navigationBar_popBack") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 14)];
    [btnLeft setTitle:@"" forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:ImageNamed(@"navigationBar_popBack") forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer,leftItem]];
    
    [self.textfield becomeFirstResponder];
    self.descLabel.text =  self.payType == 0 ? @"请设置6位交易密码" : @"请确认6位交易密码";;
    [_nextBtn setTitle:(self.payType == 0 ? @"下一步" : @"确认")  forState:UIControlStateNormal];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.textfield resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    //delegate 置为nil
    
    //删除通知
    
}

#pragma mark - View创建与设置

- (instancetype)initWithType:(KDPayPasswordType)type
{
    if (self = [super init]) {
        self.payType = type;
    }
    return self;
}

- (void)setUpView{
    [self baseSetup:PageGobackTypeNone];
    [self setUpDataSource];
    
    //创建视图等
    __weak typeof(self) weakSelf = self;
    
    self.descLabel = [UILabel getLabelWithFontSize:15 textColorHex:0x333333 superView:self.view masonrySet:^(UILabel *view, MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        
    }];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    
//    self.descLabel = [UILabel getLabelWithFontSize:15 textColorHex:@"#333333" superView:self.view lytSet:^(UILabel *label) {
//        [label lyt_alignTopToParentWithMargin:50.f];
//        [label lyt_centerXInParent];
//        label.textAlignment = NSTextAlignmentCenter;
//        
//    }];
    CGFloat labelWidth = (SCREEN_WIDTH-60)/6;
    self.textfield = [UITextField getTextFieldWithFontSize:15 textColorHex:0x333333 placeHolder:@"" superView:self.view lytSet:^(UITextField *textfield) {
        [textfield lyt_alignTopToView:_descLabel margin:55.f];
        [textfield lyt_setHeight:labelWidth];
        [textfield lyt_alignLeftToParentWithMargin:30.f];
        [textfield lyt_alignRightToParentWithMargin:30.f];
        textfield.backgroundColor = [UIColor colorWithHex:0xffffff];
        textfield.secureTextEntry = YES;
    }];
    
    self.textfield = [UITextField getTextFieldWithFontSize:15 textColorHex:0x333333 placeHolder:@"" superView:self.view masonrySet:^(UITextField *view, MASConstraintMaker *make) {
        make.topMargin.equalTo(weakSelf.descLabel).offset(55);
        make.height.equalTo([NSNumber numberWithFloat:labelWidth]);
//        make.left.equalTo(self.view).offset(30);
        make.left.equalTo(@30);
        make.width.equalTo([NSNumber numberWithFloat:SCREEN_WIDTH-60]);
    }];
    self.textfield.backgroundColor = [UIColor colorWithHex:0xffffff];
    self.textfield.secureTextEntry = YES;
    
//    self.textfield = [UITextField getTextFieldWithFontSize:15 textColorHex:@"#333333" placeHolder:@"" superView:self.view lytSet:^(UITextField *textfield) {
//        [textfield lyt_alignTopToView:_descLabel margin:55.f];
//        [textfield lyt_setHeight:labelWidth];
//        [textfield lyt_alignLeftToParentWithMargin:30.f];
//        [textfield lyt_alignRightToParentWithMargin:30.f];
//        textfield.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
//        textfield.secureTextEntry = YES;
//    }];
    
    
    [KDKeyboardView KDKeyBoardWithKdKeyBoard:PAYPASSWORD target:self textfield:_textfield delegate:self valueChanged:@selector(respondsToTextfield:)];
    for (int i = 0; i < 6; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30 + i * labelWidth, 105 , labelWidth + 1, labelWidth)];
        
        label.font = [UIFont systemFontOfSize:24];
        label.textColor = [UIColor colorWithHex:0x000000];
        label.layer.masksToBounds = YES;
        label.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
        label.layer.borderWidth = 1.0f;
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        [self.keyArr addObject:label];
        
        label.backgroundColor =[ UIColor whiteColor];
    }
    
    _nextBtn = [UIButton getButtonWithFontSize:17 TextColorHex:0xffffff backGroundColor2:[UIColor colorWithHex:0xd9d9d9] superView:self.view masonrySet:^(UIButton *view, MASConstraintMaker *make) {
        make.topMargin.equalTo([NSNumber numberWithFloat:105+labelWidth+30.f]);
        make.centerY.equalTo(weakSelf.view.mas_centerY);
        make.height.equalTo(@44);
        make.leftMargin.equalTo(@15);
        make.rightMargin.equalTo(@15);
        
    }];
    _nextBtn.layer.cornerRadius = 7.5f;
    [_nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    
//    _nextBtn = [UIButton getButtonWithFontSize:17 TextColorHex:@"#ffffff" backGroundColor2:[UIColor colorWithHex:BUTTONGRAY] superView:self.view lytSet:^(UIButton *button) {
//        [button lyt_alignTopToParentWithMargin:105+labelWidth+30.f];
//        [button lyt_centerXInParent];
//        [button lyt_setHeight:44.f];
//        [button lyt_alignLeftToParentWithMargin:15.f];
//        [button lyt_alignRightToParentWithMargin:15.f];
//        
//        button.layer.cornerRadius = 7.5f;
//        [button addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
//    }];
    _nextBtn.hidden = YES;
}

#pragma mark - 初始化数据源

- (void)setUpDataSource{
    
    self.keyArr = [NSMutableArray array];

    
}

#pragma mark - 按钮事件

#pragma mark - Delegate

- (void)respondsToTextfield:(UITextField *)field
{
    for (UILabel *label in _keyArr) {
        if ([_keyArr indexOfObject:label] < _textfield.text.length) {
            label.text = @"●";
        } else {
            label.text = @"";
        }
    }
    
    if (_textfield.text.length == 6) {
        [self.textfield resignFirstResponder];
        [self nextStep];
        
        _nextBtn.backgroundColor = [UIColor colorWithHex:0xFF5145];
        _nextBtn.userInteractionEnabled = YES;
    }else
    {
        _nextBtn.backgroundColor = [UIColor colorWithHex:0xd9d9d9];
        _nextBtn.userInteractionEnabled = NO;
    }
    
}

#pragma mark - 请求数据

#pragma mark - Other

-(PayPassWordRequest *)requestPayPassWord{
    if (!_requestPayPassWord) {
        _requestPayPassWord = [PayPassWordRequest new];
    }
    return _requestPayPassWord;
}

- (void)nextStep
{
    if (self.payType == KDSetPayPassword) {
        //如果是设置交易密码让他去确认页面
        SetTradingPasswordVC *confirm = [[SetTradingPasswordVC alloc]initWithType:KDConfirmPayPassword];
        confirm.controllIndex = self.controllIndex;
        confirm.password = _textfield.text;
        confirm.type = self.type;
        [self.navigationController pushViewController:confirm animated:YES];
    }else
    {
        //进入确认页面之后 如果两次密码一样 就设置密码
        if ([self.textfield.text isEqualToString:self.password]) {
            [self showLoading:@""];
            __weak typeof(self)weakself = self;
            NSDictionary *param = @{@"password":_textfield.text};
            [self.requestPayPassWord setPaypasswordWithDict:param onSuccess:^(NSDictionary *dictResult) {
              [weakself hideLoading];
                [[UserManager sharedUserManager]updatePayPassWordtatus:1];
                //                //设置交易密码成功
                [weakself.navigationController popToViewController:[[weakself.navigationController viewControllers] objectAtIndex:weakself.controllIndex] animated:YES];
            } andFailed:^(NSInteger code, NSString *errorMsg) {
                [weakself hideLoading];
                [weakself showMessage:errorMsg];
            }];
            
//            self.request.param = @{@"password":_textfield.text};
//            __weak typeof(self)weakself = self;
//            [self.request loadDataWithSuccess:^(NSDictionary *data) {

//            } successButUnUnusual:^(NSDictionary *data) {
//                if ([data[@"code"]isEqual:@(-2)]) {
//                    [GToolUtil checkLogin:nil target:self];
//                }
//            } falid:^(NSString *msg) {
//                [[iToast makeText:msg]show];
//            }];
        }else
        {
            for (UILabel *label in _keyArr) {
                label.text = @"";
            }
            self.textfield.text = @"";
            PayPasswordErrowView *error = [[PayPasswordErrowView alloc]initWithTitle:@"两次输入的密码不一致" LeftBtnTitle:@"重新设置" RightBtnTitle:@"再试一次"];
            [error show];
            error.leftBlock = ^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            error.rightBlock = ^{
                [self.textfield becomeFirstResponder];
            };
        }
        
    }
}

- (void)back
{
//    [self dsPushViewController:[[self.navigationController viewControllers] objectAtIndex:self.controllIndex] animated:YES];
    
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:self.controllIndex] animated:YES];
}

@end
