//
//  KDShareFloatWindow.h
//  KDLC
//
//  Created by haoran on 15/10/26.
//  Copyright © 2015年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDShareFloatWindow : UIView
//初始化
+ (KDShareFloatWindow *)makeText:(NSString *)str;
//展示
- (void)show;
@end
