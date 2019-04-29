//
//  UIButton+Masonry.h
//  KDLC
//
//  Created by appleMac on 16/6/6.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCustombutton.h"

@interface UIButton (Masonry)

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
+(UIButton *)getButtonWithFontSize:(NSInteger)size TextColorHex:(long)colorHex backGroundColor:(long)color superView:(UIView *)superView masonrySet:(void (^)(UIButton *view,MASConstraintMaker *make))block;


+(UIButton *)getButtonWithFontSize:(NSInteger)size TextColorHex:(long)colorHex backGroundColor2:(UIColor *)color superView:(UIView *)superView masonrySet:(void (^)(UIButton *view,MASConstraintMaker *make))block;

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
+(UIButton *)getCustomButtonWithTitleEdge:(UIEdgeInsets)titleEdge imageEdge:(UIEdgeInsets)imageEdge imageDirection:(ImageEdgeDirection)imageDirection FontSize:(NSInteger)size TextColorHex:(long)colorHex backGroundColor:(long)color superView:(UIView *)superView masonrySet:(void (^)(UIButton *view,MASConstraintMaker *make))block;


+(UIButton *)getCustomButtonWithTitleEdge:(UIEdgeInsets)titleEdge imageEdge:(UIEdgeInsets)imageEdge imageDirection:(ImageEdgeDirection)imageDirection FontSize:(NSInteger)size TextColorHex:(long)colorHex backGroundColor2:(UIColor *)color superView:(UIView *)superView masonrySet:(void (^)(UIButton *view,MASConstraintMaker *make))block;

+(void)startRunSecond:(UIButton *)btn stringFormat:(NSString *)str finishBlock:(dispatch_block_t)finish;

+ (UIButton *)rightArrowCustom;

@end
