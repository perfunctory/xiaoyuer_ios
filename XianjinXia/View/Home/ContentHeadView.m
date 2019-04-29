//
//  HomepageHeadView.m
//  XianjinXia
//
//  Created by sword on 2017/2/28.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "ContentHeadView.h"

#import "CCPScrollView.h"
#import "CreditLineView.h"

#import "UserManager.h"

@interface ContentHeadView ()

@property (nonatomic, strong) UIImageView *informImageView;
@property (nonatomic, strong) CCPScrollView *ccpScrollView;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) CreditLineView *creditLineView;

@property (strong, nonatomic) MASConstraint *creditLineHeight;

@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) UIView *vLine;
@property (nonatomic, strong) UILabel *line2;

@end

@implementation ContentHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.informImageView];
        [self addSubview:self.ccpScrollView];
        [self addSubview:self.line];
        [self addSubview:self.creditLineView];
         [self addSubview:self.line2];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    if (self.informImageView.translatesAutoresizingMaskIntoConstraints) {
        
        [self.informImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(20);
//            make.centerY.mas_equalTo(self.mas_centerY);

        }];
        [self.informImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.informImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.ccpScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.informImageView.mas_centerY);
            make.left.equalTo(self.informImageView.mas_right).with.offset(10);
            make.top.equalTo(self.mas_top).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(-20);
            make.height.equalTo(@(25*WIDTHRADIUS));
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.informImageView.mas_left);
            make.right.equalTo(self.ccpScrollView.mas_right);
            make.bottom.equalTo(self.ccpScrollView.mas_bottom);
            make.height.equalTo(@1);
        }];
        _line1 = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_ccpScrollView.frame), SCREEN_WIDTH, 0.5*WIDTHRADIUS)];
        _line1.backgroundColor = UIColorFromRGB(0xc1c1c1);
        [self addSubview:_line1];
        
        _vLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_ccpScrollView.frame)+0.5*WIDTHRADIUS, SCREEN_WIDTH, 9.5*WIDTHRADIUS)];
        _vLine.backgroundColor = UIColorFromRGB(0xeeeeee);
        [self addSubview:_vLine];
        
        [self.creditLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.informImageView.mas_left);
            make.top.equalTo(self.vLine.mas_bottom);
            make.right.equalTo(self.mas_right).with.offset(-20);
            make.bottom.equalTo(self.mas_bottom).priorityMedium();
            self.creditLineHeight = make.height.equalTo([self notShowCreditLineView] ? @0 : @(40*WIDTHRADIUS));
        }];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(@0.5);
        }];
    }
}

- (void)setEntity:(HomeModel *)entity {
    _entity = entity;
    
    if (self.creditLineHeight) {
        self.creditLineHeight.equalTo([self notShowCreditLineView] ? @0 : @(40*WIDTHRADIUS));
    }
    self.ccpScrollView.titleArray = entity.user_loan_log_list;
//    self.creditLineView.creditLine = [entity.amountInfo.amounts lastObject][@"amount"];
    self.creditLineView.creditLine = entity.item.card_amount;
//    self.creditLineView.head_tip = DSStringValue(entity.borrowStateList.header_tip) ;
    self.creditLineView.risk_status = DSStringValue(entity.item.risk_status);

}
- (void)setPromoteCreditLineBlock:(void (^)())promoteCreditLineBlock {
    _promoteCreditLineBlock = [promoteCreditLineBlock copy];
    
    self.creditLineView.promoteCreditLineBlock = [promoteCreditLineBlock copy];
}

- (BOOL)notShowCreditLineView {
    
    return ![UserManager sharedUserManager].isLogin || 0 == self.entity.item.verify_loan_pass.integerValue;
}

#pragma mark - Getter
- (UIImageView *)informImageView {
    
    if (!_informImageView) {
        _informImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_inform"]];
    }
    return _informImageView;
}
- (CCPScrollView *)ccpScrollView {
    
    if (!_ccpScrollView) {
        _ccpScrollView = [[CCPScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 25*WIDTHRADIUS)];
        
        _ccpScrollView.titleFont = 12;
        _ccpScrollView.titleColor = Color_Title_Black;
    }
    return _ccpScrollView;
}
- (UIView *)line {
    
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor clearColor];//[UIColor colorWithHex:0xEEEEEE];
    }
    return _line;
}
- (UILabel *)line2 {
    
    if (!_line2) {
        _line2 = [[UILabel alloc] init];
        _line2.backgroundColor = UIColorFromRGB(0xc1c1c1);//[UIColor colorWithHex:0xEEEEEE];
    }
    return _line2;
}
- (CreditLineView *)creditLineView {
    
    if (!_creditLineView) {
        _creditLineView = [[CreditLineView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25*WIDTHRADIUS)];
        
        _creditLineView.clipsToBounds = YES;
        _creditLineView.backgroundColor = [UIColor whiteColor];
    }
    return _creditLineView;
}

@end
