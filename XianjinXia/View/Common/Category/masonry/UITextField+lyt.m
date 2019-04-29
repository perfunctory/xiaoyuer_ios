//
//  UITextField+lyt.m
//  KDIOSApp
//
//  Created by appleMac on 16/5/4.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "UITextField+lyt.h"

@implementation UITextField (lyt)

+ (UITextField *)getTextFieldWithFontSize:(NSInteger)size textColorHex:(long)colorHex placeHolder:(NSString *)placeHolder superView:(UIView *)superView lytSet:(void (^)(UITextField *))block
{
    UITextField *textfield = [[UITextField alloc] init];
    textfield.font = [UIFont systemFontOfSize:size];
    textfield.textColor = [UIColor colorWithHex:colorHex];
    textfield.placeholder = placeHolder;
    textfield.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:textfield];
    
    if (block) {
        block(textfield);
    }
    return textfield;
}

@end
