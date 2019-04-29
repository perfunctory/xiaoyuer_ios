//
//  FeeManager.m
//  XianjinXia
//
//  Created by sword on 2017/4/17.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "FeeManager.h"

@interface FeeManager ()

@property (assign, nonatomic, readwrite) CGFloat arriveMoney;
@property (assign, nonatomic, readwrite) CGFloat enquiryFee;
@property (assign, nonatomic, readwrite) CGFloat interest;
@property (assign, nonatomic, readwrite) CGFloat managementFee;

@end

@implementation FeeManager

- (void)configureManagerWithAmount:(NSInteger)amount feeIndex:(NSUInteger)index {
    
    if (0 == [self.amountInfo.amounts.lastObject[@"amount"] integerValue]) {
        _arriveMoney = _enquiryFee = _interest = _managementFee = 0;
    } else {
        
        NSInteger maxAmount = [self.amountInfo.amounts.lastObject[@"amount"] integerValue];
        NSInteger interestRate = [self.amountInfo.amounts[index][@"accrual"] integerValue];
        NSInteger enquiryFeeRate = [self.amountInfo.amounts[index][@"creditVet"] integerValue];
        NSInteger managementFeeRate = [self.amountInfo.amounts[index][@"accountManage"] integerValue];
        
        self.interest =  amount*interestRate/maxAmount/100.f;
        self.enquiryFee = amount*enquiryFeeRate/maxAmount/100.f;
        self.managementFee = amount*managementFeeRate/maxAmount/100.f;
        self.arriveMoney = amount/100 - self.interest - self.enquiryFee - self.managementFee;
    }
}

@end
