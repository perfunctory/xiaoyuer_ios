//
//  UITextField+PaddingLeft.h
//  EveryDay
//
//  Created by FengDongsheng on 15/6/26.
//  Copyright (c) 2015年 FengDongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (PaddingLeft)

/**
 *  设置UITextfield
 *
 *  @param paddingView paddingview
 */
- (void)configLeftPaddingView:(UIView*)paddingView;
/**
 *  统一设置输入框左边view
 *
 *  @param strTitle 左边名称
 */
- (void)configLeftPaddingViewTitle:(NSString *)strTitle;

//刘希望create
- (void)configLeftView:(UIView*)paddingView;

//刘希望create right
- (void)configRightView:(UIView*)paddingView withString:(NSString*)strName;

- (void)configRightView:(UIView*)paddingView;

@end
