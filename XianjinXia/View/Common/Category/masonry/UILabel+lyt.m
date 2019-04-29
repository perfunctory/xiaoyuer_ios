//
//  UILabel+lyt.m
//  KDIOSApp
//
//  Created by appleMac on 16/5/1.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "UILabel+lyt.h"

@implementation UILabel (lyt)

+(UILabel *)getLabelWithFontSize:(NSInteger)size textColor:(UIColor *)color superView:(UIView *)superView lytSet:(void (^)(UILabel *label))block
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:label];
    
    if (block) {
        block(label);
    }
    return label;
}

+(UILabel *)getLabelWithFontSize:(NSInteger)size textColorHex:(NSString *)colorHex superView:(UIView *)superView lytSet:(void (^)(UILabel *label))block
{
    return [UILabel getLabelWithFontSize:size textColor:[UIColor colorWithHex:(long)colorHex] superView:superView lytSet:block];
}

+ (UICountingLabel *)getCountLabelWithFontSize:(NSInteger)size textColor:(UIColor *)color superView:(UIView *)superView lytSet:(void (^)(UILabel *label))block {
    UICountingLabel *label = [[UICountingLabel alloc] init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:label];
    
    if (block) {
        block(label);
    }
    return label;
}
+ (UICountingLabel *)getCountLabelWithFontSize:(NSInteger)size textColorHex:(NSString *)colorHex superView:(UIView *)superView lytSet:(void (^)(UILabel *label))block {
    return [UILabel getCountLabelWithFontSize:size textColor:[UIColor colorWithHex:(long)colorHex] superView:superView lytSet:block];
}

@end
