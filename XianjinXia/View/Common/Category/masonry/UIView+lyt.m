//
//  UIView+lyt.m
//  KDIOSApp
//
//  Created by haoran on 16/5/5.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "UIView+lyt.h"

@implementation UIView (lyt)
+(UIView *)getViewWithColor:(UIColor *)color superView:(UIView *)superView lytSet:(void (^)(UIView *view))block
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:view];
    
    if (block) {
        block(view);
    }
    return view;
}

+(UIView *)getViewWithColorHex:(UIColor *)colorHex superView:(UIView *)superView lytSet:(void (^)(UIView *view))block
{
    return [UIView getViewWithColor:colorHex superView:superView lytSet:block];
}

@end
