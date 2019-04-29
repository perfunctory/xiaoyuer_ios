//
//  FeeManager.h
//  XianjinXia
//
//  Created by sword on 2017/4/17.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HomeModel.h"

@interface FeeManager : NSObject

@property (strong, nonatomic) AmountInfoModel *amountInfo;

- (void)configureManagerWithAmount:(NSInteger)amount feeIndex:(NSUInteger)index;

@property (assign, nonatomic, readonly) CGFloat arriveMoney;
@property (assign, nonatomic, readonly) CGFloat enquiryFee;
@property (assign, nonatomic, readonly) CGFloat interest;
@property (assign, nonatomic, readonly) CGFloat managementFee;

@end
