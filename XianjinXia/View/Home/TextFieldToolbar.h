//
//  TextFieldToobar.h
//  XianjinXia
//
//  Created by sword on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldToolbar : UIToolbar

+ (instancetype)textFieldToolbarWithConfirm:(void(^)())confirmBlock cancel:(void(^)())cancelBlock;

@end
