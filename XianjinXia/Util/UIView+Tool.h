//
//  UIView+Tool.h
//  XianjinXia
//
//  Created by 童欣凯 on 2018/3/18.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tool)

//通过响应者链条获取view所在的控制器
- (UIViewController *)parentController;

@end
