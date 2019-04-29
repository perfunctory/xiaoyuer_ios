//
//  UITextField+PaddingLeft.m
//  EveryDay
//
//  Created by FengDongsheng on 15/6/26.
//  Copyright (c) 2015年 FengDongsheng. All rights reserved.
//

#import "UITextField+PaddingLeft.h"
#define LeftViewSpace 5
#define LeftViewWidth 82
@implementation UITextField (PaddingLeft)

- (void)configLeftPaddingView:(UIView*)paddingView{
    UIView *pView = paddingView;
    if (!pView) {
        pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    }
    self.leftView = pView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    clearButton.tag = 301;//用于解决和隐藏键盘事件冲突
    
    //设置圆角
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 5;
//    self.layer.borderColor = [Color_TextField_Border CGColor];
//    self.layer.borderWidth = 1.0f;
}
- (void)configLeftPaddingViewTitle:(NSString *)strTitle{
    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LeftViewWidth, ViewHeight(self) - 2)];
    viewLeft.backgroundColor = [UIColor whiteColor];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(LeftViewSpace, 0, LeftViewWidth - LeftViewSpace, ViewHeight(self) - 2)];
    lblTitle.font = [UIFont systemFontOfSize:15];
    lblTitle.text = strTitle;
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.textColor = RGBCOLOR(47,47,47);
    [viewLeft addSubview:lblTitle];
    [self configLeftPaddingView:viewLeft];
}
- (void)configLeftView:(UIView*)paddingView
{
    UIView *pView = paddingView;
    if (!pView) {
        pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    }
    self.leftView = pView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    clearButton.tag = 301;//用于解决和隐藏键盘事件冲突
}
- (void)configRightView:(UIView*)paddingView withString:(NSString*)strName
{
    UIView *pView = paddingView;
    if (!pView) {
        pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        pView.backgroundColor = [UIColor clearColor];
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = strName;
    label.textColor = UIColorFromRGB(0x999999);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font_SubTitle;
    [pView addSubview:label];
    self.rightView = pView;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    clearButton.tag = 301;//用于解决和隐藏键盘事件冲突
}

- (void)configRightView:(UIView*)paddingView
{
    UIView *pView = paddingView;
    if (!pView) {
        pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        pView.backgroundColor = [UIColor clearColor];
    }
    self.rightView = pView;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *clearButton = [self valueForKey:@"_clearButton"];
    clearButton.tag = 301;//用于解决和隐藏键盘事件冲突
}

@end
