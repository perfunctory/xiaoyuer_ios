//
//  InteractivePopGestureDelegate.h
//  XianjinXia
//
//  Created by sword on 2017/4/5.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InteractivePopGestureDelegate : NSObject <UIGestureRecognizerDelegate>

+ (instancetype)interactivePopGestureDelegateWithNavigationViewController:(UINavigationController *)navigationViewController;

- (instancetype)initWithNavigationViewController:(UINavigationController *)navigationViewController;

@end
