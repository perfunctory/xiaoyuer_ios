//
//  UITextField+lyt.h
//  KDIOSApp
//
//  Created by appleMac on 16/5/4.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (lyt)

+(UITextField *)getTextFieldWithFontSize:(NSInteger)size textColorHex:(long)colorHex placeHolder:(NSString *)placeHolder superView:(UIView *)superView lytSet:(void (^)(UITextField *textfield))block;

@end
