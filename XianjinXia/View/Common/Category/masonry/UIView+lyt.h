//
//  UIView+lyt.h
//  KDIOSApp
//
//  Created by haoran on 16/5/5.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (lyt)
/**
 *  实例化一个UIView，省去每次都要写很多重复的代码
 *
 *  @param color  颜色
 *  @param superView 父view
 *  @param block     lyt设置约束布局的代码
 *
 *  @return UILabel
 */
+(UIView *)getViewWithColor:(UIColor *)color superView:(UIView *)superView lytSet:(void (^)(UIView *view))block;

+(UIView *)getViewWithColorHex:(UIColor *)colorHex superView:(UIView *)superView lytSet:(void (^)(UIView *view))block;
@end
