//
//  AmountBottomView.h
//  XianjinXia
//
//  Created by sword on 2017/2/28.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "ContentBottomView.h"
#import "HomeModel.h"
#import "AmountView.h"

@interface AmountBottomView : ContentBottomView

@property (strong, nonatomic) ItemModel *item;
//@property (strong, nonatomic) AmountView *amountView;

@property (copy, nonatomic) void(^applyOrCheckFeeBlock)(BOOL isApply);

@end
