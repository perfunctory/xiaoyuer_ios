//
//  ActivityHeaderView.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/7.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "ActivityHeaderView.h"

@interface ActivityHeaderView ()

@property (strong, nonatomic) UIImageView *centerShadow;

@property (strong, nonatomic) UIView *downView;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UILabel *hotActivity;
@end

@implementation ActivityHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupInterface];
    }
    return self;
}

- (void)setupInterface {
    
    self.contentView.backgroundColor= [UIColor clearColor];
    self.contentView.clipsToBounds = YES;
    
    [self.contentView addSubview:self.centerShadow];
    [self.contentView addSubview:self.downView];
    [self.downView addSubview:self.hotActivity];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.downView.translatesAutoresizingMaskIntoConstraints) {
        
        [self.centerShadow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.bottom.equalTo(self.downView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
        }];
        [self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.contentView.mas_top).with.offset(8);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        [self.hotActivity mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.downView.mas_left).with.offset(15);
            make.centerY.equalTo(self.downView.mas_centerY);
        }];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.equalTo(@1);
        }];
    }
}

- (UIImageView *)centerShadow {
    
    if (!_centerShadow) {
        _centerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_shadow"]];
    }
    return _centerShadow;
}
- (UIView *)downView {
    
    if (!_downView) {
        _downView = [[UIView alloc] init];
        _downView.backgroundColor = [UIColor whiteColor];
    }
    return _downView;
}
- (UIView *)line {
    
    if (!_line) {
        _line = [[UIView alloc] init];
        
        _line.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
    }
    return _line;
}
- (UILabel *)hotActivity {
    
    if (!_hotActivity) {
        _hotActivity = [[UILabel alloc] init];
        
        _hotActivity.text = @"热门活动";
        _hotActivity.font = [UIFont systemFontOfSize:12];
        _hotActivity.textColor = [UIColor colorWithHex:0x3B3B3B];
    }
    return _hotActivity;
}

@end
