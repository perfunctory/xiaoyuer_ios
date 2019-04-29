//
//  BaseVerifyItem.h
//  XianjinXia
//
//  Created by sword on 2017/3/30.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VerifyListModel.h"

@interface BaseVerifyItem : UIView

+ (instancetype)baseVerifyItemWithTarget:(id)target action:(SEL)action;

- (void)configureBaseVerifyItemWithModel:(VerifyListModel *)model;

@end
