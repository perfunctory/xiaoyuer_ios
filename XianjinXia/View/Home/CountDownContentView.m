//
//  CountDownContentView.m
//  XianjinXia
//
//  Created by sword on 2017/3/1.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "CountDownContentView.h"

@interface CountDownContentView() <UINavigationControllerDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *countDownBackground;
@property (strong, nonatomic) UIImageView *imvIocn;
@property (strong, nonatomic) UIView *dayView;
@property (strong, nonatomic) UILabel *countDownDes;
@property (strong, nonatomic) UILabel *countDownDay;
@property (strong, nonatomic) UILabel *countDownUnit;

@end

@implementation CountDownContentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.countDownBackground];
        [self addSubview:self.dayView];
        [self addSubview:self.imvIocn];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.titleLabel.translatesAutoresizingMaskIntoConstraints) {
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(20);
            make.centerX.equalTo(self.mas_centerX);
        }];
        [self.countDownBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(40);
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).with.offset(-25).priorityMedium();
        }];
        [self.dayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.countDownBackground.mas_left);
            make.centerY.equalTo(self.countDownBackground.mas_centerY);
            make.right.equalTo(self.countDownBackground.mas_right);
        }];
        [self.countDownDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dayView.mas_top);
            make.centerX.equalTo(self.dayView.mas_centerX);
        }];
        [self.countDownDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.countDownDes.mas_bottom).with.offset(5);
            make.centerX.equalTo(self.dayView.mas_centerX);
            make.bottom.equalTo(self.dayView.mas_bottom);
        }];
        [self.countDownUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.countDownDay.mas_right).with.offset(2);
            make.bottom.equalTo(self.countDownDay.mas_bottom).with.offset(-6);
        }];
        [self.imvIocn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
}

- (void)setEntity:(HomeModel *)entity {
    _entity = entity;
    
    if (0 != [entity.item.next_loan_day integerValue]) { //下次借款时间
        self.titleLabel.text = @"距离下次申请借款时间";
        self.countDownDes.text = @"还剩";
        self.countDownDay.text = [NSString stringWithFormat:@"%02li", (long)[entity.item.next_loan_day integerValue]];
    } else if ( 0 <= [entity.borrowStateList.lastRepaymentD integerValue]) { //剩余还款时间
        self.titleLabel.text = @"距离本次还款时间";
        self.countDownDes.text = @"还剩";
        self.countDownDay.text = 0 == [entity.borrowStateList.lastRepaymentD integerValue] ? entity.borrowStateList.lastRepaymentD : [NSString stringWithFormat:@"%02li", (long)[entity.borrowStateList.lastRepaymentD integerValue]];
    } else {//@"本次已逾期时间"
        self.titleLabel.text = @"本次已逾期时间";
        self.countDownDes.text = @"逾期";
        self.countDownDay.text = [NSString stringWithFormat:@"%02li", labs([entity.borrowStateList.lastRepaymentD integerValue])];
    }
}

#pragma mark - Getter
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.font = FontSystem(20);
        _titleLabel.textColor = [UIColor colorWithHex:0x434343];
    }
    return _titleLabel;
}
- (UIImageView *)countDownBackground {
    
    if (!_countDownBackground) {
        _countDownBackground = [[UIImageView alloc] initWithImage:ImageNamed(@"count_down_background")];
        
        [_countDownBackground setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _countDownBackground;
}
- (UIView *)dayView {
    
    if (!_dayView) {
        _dayView = [[UIView alloc] init];
        
        [_dayView addSubview:self.countDownDes];
        [_dayView addSubview:self.countDownDay];
        [_dayView addSubview:self.countDownUnit];
    }
    return _dayView;
}
- (UILabel *)countDownDes {
    
    if (!_countDownDes) {
        _countDownDes = [[UILabel alloc] init];
        
        _countDownDes.font = [UIFont fontWithName:@"FZYHJW--GB1-0" size:24];
        //_countDownDes.textColor = [UIColor colorWithHex:0xFFBB17];
        _countDownDes.textColor = Color_Red;
        _countDownDes.text = @"还剩";
    }
    return _countDownDes;
}
- (UILabel *)countDownDay {
    
    if (!_countDownDay) {
        _countDownDay = [[UILabel alloc] init];
        
        _countDownDay.font = FontBoldSystem(45);
        _countDownDay.textColor = Color_Red;
        _countDownDay.text = @"0";
    }
    return _countDownDay;
}
- (UILabel *)countDownUnit {
    
    if (!_countDownUnit) {
        _countDownUnit = [[UILabel alloc] init];
        
        _countDownUnit.font = FontSystem(15);
        _countDownUnit.textColor = Color_Red;
        _countDownUnit.text = @"天";
    }
    return _countDownUnit;
}

-(UIImageView *)imvIocn{
    if (!_imvIocn) {
        _imvIocn = [[UIImageView alloc]init];
    }
    _imvIocn.image = ImageNamed(@"home_JC");
    return _imvIocn;
}

@end
