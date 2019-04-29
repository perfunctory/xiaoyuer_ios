//
//  UILabel+Masonry.h
//  KDLC
//
//  Created by appleMac on 16/6/6.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Masonry)

/**
 *  实例化一个UILabel，省去每次都要写很多重复的代码
 *
 *  @param size      fontsize，系统默认字体
 *  @param color    color
 *  @param superView 父view
 *  @param block     lyt设置约束布局的代码
 *
 *  @return UILabel
 */
+(UILabel *)getLabelWithFontSize:(NSInteger)size textColor:(UIColor *)color superView:(UIView *)superView masonrySet:(void (^)(UILabel *view,MASConstraintMaker *make))block;

+(UILabel *)getLabelWithFontSize:(NSInteger)size textColorHex:(long)colorHex superView:(UIView *)superView masonrySet:(void (^)(UILabel *view,MASConstraintMaker *make))block;

@end
