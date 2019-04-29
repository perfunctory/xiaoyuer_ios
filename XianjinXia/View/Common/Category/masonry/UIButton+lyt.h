//
//  UIButton+lyt.h
//  KDIOSApp
//
//  Created by appleMac on 16/5/1.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCustombutton.h"

@interface UIButton (lyt)

/**
 *  获取一个button
 *
 *  @param size             title的fontsize
 *  @param colorHex         title的色值，16进制，前面加#
 *  @param color  背景色
 *  @param superView        父view
 *  @param block            lyt设置约束布局的代码
 *
 *  @return UIButton
 */
+(UIButton *)getButtonWithFontSize:(NSInteger)size TextColorHex:(UIColor *)colorHex backGroundColor:(UIColor *)color superView:(UIView *)superView lytSet:(void (^)(UIButton *button))block;


+(UIButton *)getButtonWithFontSize:(NSInteger)size TextColorHex:(UIColor *)colorHex backGroundColor2:(UIColor *)color superView:(UIView *)superView lytSet:(void (^)(UIButton *button))block;
+(void)startRunSecond:(UIButton *)btn stringFormat:(NSString *)str finishBlock:(dispatch_block_t)finish;

/**
 *  获取一个自定义放置图片和title的button
 *
 *  @param titleEdge      用于设置title的frame
 *  @param imageEdge      用于设置image的frame
 *  @param imageDirection 设置image的frame的方向
 *  @param size             title的fontsize
 *  @param colorHex         title的色值，16进制，前面加#
 *  @param color  背景色
 *  @param superView        父view
 *  @param block            lyt设置约束布局的代码
 *
 *  @return UIButton
 */
+(UIButton *)getCustomButtonWithTitleEdge:(UIEdgeInsets)titleEdge imageEdge:(UIEdgeInsets)imageEdge imageDirection:(ImageEdgeDirection)imageDirection FontSize:(NSInteger)size TextColorHex:(NSString *)colorHex backGroundColor:(NSString *)color superView:(UIView *)superView masonrySet:(void (^)(UIButton *view,MASConstraintMaker *make))block;


+(UIButton *)getCustomButtonWithTitleEdge:(UIEdgeInsets)titleEdge imageEdge:(UIEdgeInsets)imageEdge imageDirection:(ImageEdgeDirection)imageDirection FontSize:(NSInteger)size TextColorHex:(UIColor *)colorHex backGroundColor2:(UIColor *)color superView:(UIView *)superView masonrySet:(void (^)(UIButton *view,MASConstraintMaker *make))block;

+ (UIButton *)rightArrowCustom;
@end
