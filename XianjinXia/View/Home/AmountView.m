//
//  AmountView.m
//  KDFDApp
//
//  Created by sword on 2017/1/5.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import "AmountView.h"

@interface AmountView ()

@property (strong, nonatomic) UILabel *arriveMoney;
@property (strong, nonatomic) UILabel *enquiryFee;
@property (strong, nonatomic) UILabel *interest;
@property (strong, nonatomic) UILabel *managementFee;
@property (strong, nonatomic) UILabel *arriveMoneyDes;
@property (strong, nonatomic) UILabel *enquiryFeeDes;
@property (strong, nonatomic) UILabel *interestDes;
@property (strong, nonatomic) UILabel *managementFeeDes;

@end

@implementation AmountView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _arriveMoney = [self createLabelWithText:@"0元"];
        _arriveMoneyDes = [self createLabelWithText:@"到账金额："];
        _enquiryFee = [self createLabelWithText:@"0元"];
        _enquiryFeeDes = [self createLabelWithText:@"信审查询费："];
        _interest = [self createLabelWithText:@"0元"];
        _interestDes = [self createLabelWithText:@"借款利息："];
        _managementFee = [self createLabelWithText:@"0元"];
        _managementFeeDes = [self createLabelWithText:@"账户管理费："];
        
        [self addSubview:_arriveMoney];
        [self addSubview:_enquiryFee];
        [self addSubview:_interest];
        [self addSubview:_managementFee];
        [self addSubview:_arriveMoneyDes];
        [self addSubview:_enquiryFeeDes];
        [self addSubview:_interestDes];
        [self addSubview:_managementFeeDes];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.enquiryFeeDes.translatesAutoresizingMaskIntoConstraints) {
        [self.enquiryFeeDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(40);
            make.top.equalTo(self.mas_top);
        }];
        [self.enquiryFee mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.enquiryFeeDes.mas_right).with.offset(0);
            make.centerY.equalTo(self.enquiryFeeDes.mas_centerY);
        }];
        [self.managementFeeDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.enquiryFeeDes.mas_left);
            make.top.equalTo(self.enquiryFeeDes.mas_bottom).with.offset(10);
            make.bottom.equalTo(self.mas_bottom).priorityMedium();
        }];
        [self.managementFee mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.managementFeeDes.mas_right).with.offset(0);
            make.centerY.equalTo(self.managementFeeDes.mas_centerY);
        }];
        
        [self.interest mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-40);
            make.top.equalTo(self.mas_top);
        }];
        [self.interestDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(self.interest.mas_left);
            make.centerY.equalTo(self.interest.mas_centerY);
        }];
        [self.arriveMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.interest.mas_right);
            make.top.equalTo(self.interest.mas_bottom).with.offset(10);
        }];
        [self.arriveMoneyDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(self.arriveMoney.mas_left);
            make.centerY.equalTo(self.arriveMoney.mas_centerY);
            make.right.equalTo(self.interestDes.mas_right);
        }];
        [self.interest setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.arriveMoney setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.interest setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.arriveMoney setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
}

#pragma mark - Public
- (void)configureWithFeeManager:(FeeManager *)feeManager {
    
    self.arriveMoney.text = [NSString stringWithFormat:@"%.2f元", feeManager.arriveMoney];
    self.enquiryFee.text = [NSString stringWithFormat:@"%.2f元", feeManager.enquiryFee];
    self.interest.text = [NSString stringWithFormat:@"%.2f元", feeManager.interest];
    self.managementFee.text = [NSString stringWithFormat:@"%.2f元", feeManager.managementFee];
}

#pragma mark - Private
- (UILabel *)createLabelWithText:(NSString *)text {
    UILabel *result = [[UILabel alloc] init];
    
    result.text = text;
    result.font = FontSystem(12);
    result.textColor = [UIColor colorWithHex:0x919191];
    
    return result;
}


@end
