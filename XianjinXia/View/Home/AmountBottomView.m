//
//  AmountBottomView.m
//  XianjinXia
//
//  Created by sword on 2017/2/28.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "AmountBottomView.h"

#import "UserManager.h"

@interface AmountBottomView ()

//@property (strong, nonatomic) UILabel *verifyLabel;

@property (strong, nonatomic) UIButton *checkFee;

@property (strong, nonatomic) UIButton *applyBorrow;

@property (strong, nonatomic) UIImageView *imvBG;

@end

@implementation AmountBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
       // [self addSubview:self.verifyLabel];
        [self addSubview:self.applyBorrow];
        [self addSubview:self.imvBG];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.applyBorrow.translatesAutoresizingMaskIntoConstraints) {
        [self.imvBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
        }];
      /*  [self.verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
        }];
       */
        [self.applyBorrow mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iphone6Plus) {
            make.top.equalTo(self.mas_top).with.offset(26);
            make.bottom.equalTo(self.mas_bottom).with.offset(-26).priorityMedium();
            }else if (iphone6){
                make.top.equalTo(self.mas_top).with.offset(15);
                make.bottom.equalTo(self.mas_bottom).with.offset(-15).priorityMedium();
            }else if (iPhone5){
                make.top.equalTo(self.mas_top).with.offset(1);
                make.bottom.equalTo(self.mas_bottom).with.offset(-1).priorityMedium();
            }else{
                make.top.equalTo(self.mas_top).with.offset(8);
                make.bottom.equalTo(self.mas_bottom).with.offset(-8).priorityMedium();
            }

            make.left.equalTo(self.mas_left).with.offset(40);
            make.right.equalTo(self.mas_right).with.offset(-40);

            make.height.equalTo(@40);
        }];
    }
}

#pragma mark - Private
- (BOOL)notShowVerifyHint {
    
    return ![UserManager sharedUserManager].isLogin || (1 == self.item.verify_loan_pass.integerValue) || (0 == self.item.verify_loan_nums.integerValue);
}
- (NSAttributedString *)createVerifyText {
    NSString *tmpStr = [NSString stringWithFormat:@"!您已%@，完成认证即可拿钱，加油!", self.item.card_verify_step];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:tmpStr];
    
    [result addAttribute:NSForegroundColorAttributeName value:Color_Red range:[tmpStr rangeOfString:@"!"]];
    return result;
}
- (void)apply {
    
    !self.applyOrCheckFeeBlock ? : self.applyOrCheckFeeBlock(YES);
}

#pragma mark - Setter
- (void)setItem:(ItemModel *)item {
    _item = item;
    
   // self.verifyLabel.attributedText = [self notShowVerifyHint] ? nil : [self createVerifyText];
    [self.applyBorrow setTitle:[UserManager sharedUserManager].isLogin ? @"我要借款" : @"立即申请" forState:UIControlStateNormal];
    
    [self updateConstraintsIfNeeded];
//    if ([UserManager sharedUserManager].isLogin) {
        [self.checkFee removeFromSuperview];
        
//        if (self.amountView.superview) return;
//        [self addSubview:self.amountView];
//        
//        [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left);
//            make.top.equalTo(self.mas_top).with.offset(35);
//            make.right.equalTo(self.mas_right);
//            make.bottom.equalTo(self.verifyLabel.mas_top).with.offset(-10);
//        }];
//    } else if (!self.checkFee.superview) {
//        [self.amountView removeFromSuperview];
//        
//        if (self.checkFee.superview) return;
//        [self addSubview:self.checkFee];
//        
//        [self.checkFee mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_top).with.offset(40);
//            make.centerX.equalTo(self.mas_centerX);
//            make.bottom.equalTo(self.applyBorrow.mas_top).with.offset(-10);
//        }];
//    }
}

#pragma mark - Getter
//- (AmountView *)amountView {
//    
//    if (!_amountView) {
//        _amountView = [[AmountView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
//        
//    }
//    return _amountView;
//}
/*
- (UILabel *)verifyLabel {
    
    if (!_verifyLabel) {
        _verifyLabel = [[UILabel alloc] init];
        _verifyLabel.font = [UIFont systemFontOfSize:12];
        _verifyLabel.textColor = [UIColor colorWithHex:0xB3B3B3];
        _verifyLabel.text = @"认证";
    }
    return _verifyLabel;
}
 */
- (UIButton *)checkFee {
    
    if (!_checkFee) {
        _checkFee = [[UIButton alloc] init];
        _checkFee.titleLabel.font = FontSystem(12);
        [_checkFee setTitleColor:[UIColor colorWithHex:0x7BCEF5] forState:UIControlStateNormal];
        [_checkFee setTitle:@"查看服务费" forState:UIControlStateNormal];
        [_checkFee addTarget:self action:@selector(apply) forControlEvents:UIControlEventTouchUpInside];
        
        [_checkFee setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _checkFee;
}
- (UIButton *)applyBorrow {
    
    if (!_applyBorrow) {
        _applyBorrow = [[UIButton alloc] init];
        _applyBorrow.titleLabel.font = [UIFont systemFontOfSize:18];
        [_applyBorrow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_applyBorrow setBackgroundImage:[UIImage imageNamed:@"button_red_background"] forState:UIControlStateNormal];
        [_applyBorrow setTitle:@"我要借款" forState:UIControlStateNormal];
        [_applyBorrow addTarget:self action:@selector(apply) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBorrow;
}
-(UIImageView *)imvBG{
    if (!_imvBG) {
        _imvBG = [[UIImageView alloc]init];
    }
//    _imvBG.image = ImageNamed(@"home_JC");
    return _imvBG;
}
@end
