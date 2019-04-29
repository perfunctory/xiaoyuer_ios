//
//  AmountContentView.h
//  KDFDApp
//
//  Created by sword on 2017/1/4.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface AmountContentView : UIView

@property (nonatomic, strong) HomeModel *entity;
@property (nonatomic, copy) void(^moneyDidChange)(NSInteger money, NSUInteger feeIndex);
@property (copy, nonatomic) void(^applyOrCheckFeeBlock)(BOOL isApply);
- (NSDictionary *)selectedDicionary;

- (void)sliderAnimation;

@end
