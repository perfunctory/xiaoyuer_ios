//
//  FeedBackVC.m
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "FeedBackVC.h"
#import "DXAlertView.h"
#import "FeedBackRequest.h"


@interface FeedBackVC ()<UITextViewDelegate>

@property (nonatomic, retain) UITextView *feedbackTV;
@property (nonatomic, retain) UILabel *tvPlaceHolderLabel;
@property (nonatomic, retain) UILabel *limitLab;
@property (nonatomic, retain) UIButton *commitBtn;
@property (nonatomic, strong) FeedBackRequest *requestFeedBack;

@end

@implementation FeedBackVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

#pragma mark - View创建与设置
- (void)setUpView{
    
    self.navigationItem.title = @"意见反馈";
    [self baseSetup:PageGobackTypePop];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAllKeyBoards)];
    [self.view addGestureRecognizer:tap1];
    
    //创建视图等
    __block UIView *topBackView = [UIView getViewWithColor:[UIColor whiteColor] superView:self.view masonrySet:^(UIView *view, MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@(225 * WIDTHRADIUS));
    }];
    self.feedbackTV = [[UITextView alloc] initWithFrame:CGRectMake(17, 17 * WIDTHRADIUS, SCREEN_WIDTH - 34, (225 - 17) * WIDTHRADIUS)];
    self.feedbackTV.delegate = self;
    self.feedbackTV.backgroundColor = [UIColor whiteColor];
    self.feedbackTV.font = [UIFont systemFontOfSize:iPhone6p ? 15 : 13];
    self.feedbackTV.textColor = UIColorFromRGB(0x333333);
    [topBackView addSubview:self.feedbackTV];
    
    _tvPlaceHolderLabel = [UILabel getLabelWithFontSize:iPhone6p ? 15 : 13 textColor:[UIColor grayColor] superView:_feedbackTV masonrySet:^(UILabel *view, MASConstraintMaker *make) {
        
        view.text = @"请输入您的反馈意见，我们会为您不断进步。";
        make.left.top.mas_equalTo(@0);
        make.height.mas_equalTo(@32);
    }];
    
    __weak typeof(self) weakSelf = self;
    _limitLab = [UILabel getLabelWithFontSize:iPhone6p ? 15 : 13 textColor:[UIColor grayColor] superView:topBackView masonrySet:^(UILabel *view, MASConstraintMaker *make) {
        __strong typeof(self) strongSelf = weakSelf;
        make.right.equalTo(strongSelf.feedbackTV.mas_right);
        make.bottom.equalTo(strongSelf.feedbackTV.mas_bottom).offset(-(17 * WIDTHRADIUS));
        view.text = @"160/160";
    }];
    
    _commitBtn = [UIButton getButtonWithFontSize:17 TextColorHex:0xffffff backGroundColor2:UIColorFromRGB(0xb7b7b7) superView:self.view masonrySet:^(UIButton *view, MASConstraintMaker *make) {
        make.left.mas_equalTo(@15);
        make.right.mas_equalTo(@-15);
        make.height.mas_equalTo(@44);
        make.top.equalTo(topBackView.mas_bottom).offset(42.5 * WIDTHRADIUS);
        [view setTitle:@"提交" forState:UIControlStateNormal];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = iPhone6p ? 8 : 5;
        view.userInteractionEnabled = NO;
        [view addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    }];
}

#pragma mark 点击外面隐藏键盘

-(void) hideAllKeyBoards{
    [_feedbackTV resignFirstResponder];
}

#pragma mark 提交反馈



- (void)pop
{
    [self popVC];
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _tvPlaceHolderLabel.hidden = YES;
    [textView.layer setBorderColor:UIColorFromRGB(0xFF5145).CGColor];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.feedbackTV.text length] > 160) {
        [self showMessage:@"不能超过160个字哦"];
        _feedbackTV.text = [_feedbackTV.text substringToIndex:160];
        self.limitLab.text = @"0/160";
        return;
    }
    if ([self isBlankString:textView.textInputMode.primaryLanguage]) {
        return;
    }
    NSInteger a = 160 - [textView.text length];
    NSString *str = [NSString stringWithFormat:@"%ld/160",(long)a];
    self.limitLab.text = str;
    if (_feedbackTV.text.length > 0) {
        _commitBtn.userInteractionEnabled = YES;
        _commitBtn.backgroundColor = Color_Red;
    }else{
        _commitBtn.userInteractionEnabled = NO;
        _commitBtn.backgroundColor = UIColorFromRGB(0xb7b7b7);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self isBlankString:textView.textInputMode.primaryLanguage]) {
        return NO;
    };
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        _tvPlaceHolderLabel.hidden = NO;
    }
    [textView.layer setBorderColor:UIColorFromRGB(0xb7b7b7).CGColor];
    return YES;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


#pragma mark - 请求数据

-(void)confirm
{
    [_feedbackTV resignFirstResponder];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self.feedbackTV.text
                                                               options:0
                                                                 range:NSMakeRange(0, [self.feedbackTV.text length])
                                                          withTemplate:@""];
    
    
    
//    self.feedbackTV.text=modifiedString;
//    NSString *content = [[modifiedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet symbolCharacterSet]];
    if([modifiedString isEqualToString:@""]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"请输入反馈内容" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [self hideAllKeyBoards];
        [alert show];
        return;
    }
    NSDictionary *param = @{@"content" : modifiedString};
    [self showLoading:@""];
    [self.requestFeedBack feedBackWithDict:param onSuccess:^(NSDictionary *dictResult) {
        [self hideLoading];
        [self showMessage:@"提交反馈成功"];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pop) userInfo:nil repeats:NO];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
}

#pragma mark - Other

-(FeedBackRequest *)requestFeedBack{
    if (!_requestFeedBack) {
        _requestFeedBack = [FeedBackRequest new];
    }
    return _requestFeedBack;
}

@end
