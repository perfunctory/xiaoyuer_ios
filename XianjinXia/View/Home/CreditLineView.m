//
//  CreditLineView.m
//  KDFDApp
//
//  Created by sword on 2017/1/4.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import "CreditLineView.h"

@interface CreditLineView ()

//@property (strong, nonatomic) UIView *line;

@property (strong, nonatomic) UILabel *creditLineNumber;
@property (strong, nonatomic) UIButton *promoteCreditLine;
@end

@implementation CreditLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.creditLineNumber];
        [self addSubview:self.promoteCreditLine];
//        [self addSubview:self.line];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.creditLineNumber.translatesAutoresizingMaskIntoConstraints) {
        
        __weak __typeof(self) weakSelf = self;
        [self.creditLineNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left);
            make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-(10*WIDTHRADIUS));
        }];
        [self.promoteCreditLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.mas_right);
            make.centerY.equalTo(weakSelf.creditLineNumber.mas_centerY);
        }];
//        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(0);
//            make.right.equalTo(weakSelf.mas_right);
//            make.bottom.equalTo(weakSelf.mas_bottom);
//            make.height.equalTo(@1);
//        }];
    }
}

- (void)promote {
    
    !self.promoteCreditLineBlock ? : self.promoteCreditLineBlock();
}

- (void)setCreditLine:(NSString *)creditLine {
    _creditLine = creditLine;
    self.creditLineNumber.text = [NSString stringWithFormat:@"信用额度(元)：%li", (long)[creditLine integerValue]/100];
}

//- (void)setHead_tip:(NSString *)head_tip{
//    _head_tip = head_tip;
//    //审核未通过显示按钮 通过了就不显示
//    if ([ DSStringValue(head_tip) isEqualToString:@"审核未通过"] || [ DSStringValue(head_tip) isEqualToString:@"审核被拒绝"]) {
//        _promoteCreditLine.hidden = NO;
//    }else {
//        _promoteCreditLine.hidden = YES;
//    }
//}

- (void)setRisk_status:(NSString *)risk_status{
    _risk_status = risk_status;
    //审核未通过显示按钮 通过了就不显示
   
    if(risk_status &&[risk_status isEqualToString:@"1"]){// 0 不显示 1显示
        _promoteCreditLine.hidden = NO;
    }else {
        _promoteCreditLine.hidden = YES;
    }

}
#pragma mark - Getter

- (UILabel *)creditLineNumber {
    
    if (!_creditLineNumber) {
        _creditLineNumber = [[UILabel alloc] init];
        
        _creditLineNumber.font = [UIFont systemFontOfSize:13];
        _creditLineNumber.textColor = [UIColor colorWithHex:0x3B3B3B];
        _creditLineNumber.text = @"信用额度(元)：1000";
    }
    return _creditLineNumber;
}
//点我有惊喜 外链到其他借贷平台
- (UIButton *)promoteCreditLine {
    
    if (!_promoteCreditLine) {
        _promoteCreditLine = [[UIButton alloc] init];
        
        _promoteCreditLine.titleLabel.font = [UIFont systemFontOfSize:13];
        [_promoteCreditLine setTitleColor:[UIColor colorWithHex:0x72BEF4] forState:UIControlStateNormal];
        [_promoteCreditLine setTitle:@"点我有惊喜>" forState:UIControlStateNormal];

        [_promoteCreditLine addTarget:self action:@selector(promote) forControlEvents:UIControlEventTouchUpInside];
    }
    return _promoteCreditLine;
}
//- (UIView *)line {
//    
//    if (!_line) {
//        _line = [[UIView alloc] init];
//        _line.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
//    }
//    return _line;
//}

@end
