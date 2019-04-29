//
//  UILabel+lyt.h
//  KDIOSApp
//
//  Created by appleMac on 16/5/1.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCustombutton.h"
#import "UICountingLabel.h"
@interface UILabel (lyt)

/**
 *  实例化一个UILabel，省去每次都要写很多重复的代码
 *
 *  @param size      fontsize，系统默认字体
 *  @param color   color
 *  @param superView 父view
 *  @param block     lyt设置约束布局的代码
 *
 *  @return UILabel
 */
+(UILabel *)getLabelWithFontSize:(NSInteger)size textColor:(UIColor *)color superView:(UIView *)superView lytSet:(void (^)(UILabel *label))block;

+(UILabel *)getLabelWithFontSize:(NSInteger)size textColorHex:(NSString *)colorHex superView:(UIView *)superView lytSet:(void (^)(UILabel *label))block;


+ (UICountingLabel *)getCountLabelWithFontSize:(NSInteger)size textColor:(UIColor *)color superView:(UIView *)superView lytSet:(void (^)(UILabel *label))block;
+ (UICountingLabel *)getCountLabelWithFontSize:(NSInteger)size textColorHex:(NSString *)colorHex superView:(UIView *)superView lytSet:(void (^)(UILabel *label))block;


@end
