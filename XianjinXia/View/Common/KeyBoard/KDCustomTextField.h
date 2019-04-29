//
//  KDCustomTextField.h
//  KDLC
//
//  Created by apple on 15/12/5.
//  Copyright © 2015年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDCustomTextField : UITextField

- (instancetype)initWithFrame:(CGRect)frame andGap:(NSInteger)gap;

- (instancetype)initWithFrame:(CGRect)frame andGap:(NSInteger)gap andChangeColor:(UIColor *)changeColor;

- (instancetype)initWithFrame:(CGRect)frame andGap:(NSInteger)gap andChangeColor:(UIColor *)changeColor andFont:(NSInteger)fontSize;          //gap为文字与x之间的间隙;changecolor传placeHolder的定制颜色，不传就默认为系统的;fontSize为placeHolder的大小，不传就默认为字体大小

@end
