//
//  UILabel+Masonry.m
//  KDLC
//
//  Created by appleMac on 16/6/6.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "UILabel+Masonry.h"

@implementation UILabel (Masonry)

+(UILabel *)getLabelWithFontSize:(NSInteger)size textColor:(UIColor *)color superView:(UIView *)superView masonrySet:(void (^)(UILabel *view,MASConstraintMaker *make))block
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (block) {
            block(label,make);
        }
    }];
    return label;
}

+(UILabel *)getLabelWithFontSize:(NSInteger)size textColorHex:(long)colorHex superView:(UIView *)superView masonrySet:(void (^)(UILabel *view,MASConstraintMaker *make))block
{
    return [UILabel getLabelWithFontSize:size textColor:[UIColor colorWithHex:colorHex] superView:superView masonrySet:block];
}

@end
