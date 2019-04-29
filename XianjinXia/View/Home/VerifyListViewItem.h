//
//  VerifyListViewItem.h
//  XianjinXia
//
//  Created by 童欣凯 on 2018/2/25.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerifyListModel.h"

@interface VerifyListViewItem : UIView

+ (instancetype)baseVerifyItemWithTarget:(id)target action:(SEL)action;

- (void)configureBaseVerifyItemWithModel:(VerifyListModel *)model;

@end
