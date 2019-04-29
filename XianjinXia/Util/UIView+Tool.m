//
//  UIView+Tool.m
//  XianjinXia
//
//  Created by 童欣凯 on 2018/3/18.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "UIView+Tool.h"

@implementation UIView (Tool)

//通过响应者链条获取view所在的控制器
- (UIViewController *)parentController
{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end
