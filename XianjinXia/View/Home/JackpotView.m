//
//  JackpotView.m
//  KDFDApp
//
//  Created by sword on 2017/1/4.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import "JackpotView.h"

@interface JackpotView ()

@property (strong, nonatomic) UIImageView *jackpotImageView;
@property (strong, nonatomic) UILabel *jackpotNumberLabel;
@property (strong, nonatomic) UIView *jackpotNumberView;
@end

@implementation JackpotView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.jackpotNumberView];
        [self.jackpotNumberView addSubview:self.jackpotNumberLabel];
        [self addSubview:self.jackpotImageView];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.jackpotImageView.translatesAutoresizingMaskIntoConstraints) {
        
        __weak __typeof(self) weakSelf = self;
        [self.jackpotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left);
            make.top.equalTo(weakSelf.mas_top);
            make.bottom.equalTo(weakSelf.mas_bottom);
        }];
        [self.jackpotImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        [self.jackpotNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.jackpotImageView.mas_right).with.offset(0);
            make.right.equalTo(weakSelf.mas_right);
            make.top.equalTo(weakSelf.mas_top);
            make.bottom.equalTo(weakSelf.mas_bottom);
        }];
        [self.jackpotNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.jackpotNumberView.mas_left).with.offset(20);
            make.right.equalTo(weakSelf.jackpotNumberView.mas_right).with.offset(-20);
            make.centerY.equalTo(weakSelf.mas_centerY);
        }];
        [self.jackpotNumberLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.jackpotNumberLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
}

- (UIImageView *)jackpotImageView {
    
    if (!_jackpotImageView) {
        _jackpotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bonus"]];
    }
    return _jackpotImageView;
}

- (UIView *)jackpotNumberView {
    
    if (!_jackpotNumberView) {
        _jackpotNumberView = [[UIView alloc] init];
        
        _jackpotNumberView.backgroundColor = [UIColor whiteColor];
        _jackpotNumberView.layer.shadowColor = [UIColor blackColor].CGColor;
        _jackpotNumberView.layer.shadowOpacity = 0.2;
        _jackpotNumberView.layer.shadowRadius = 2.f;
        _jackpotNumberView.layer.shadowOffset = CGSizeMake(0, 0);
        _jackpotNumberView.layer.cornerRadius = 2.f;
    }
    return _jackpotNumberView;
}

- (UILabel *)jackpotNumberLabel {
    
    if (!_jackpotNumberLabel) {
        _jackpotNumberLabel = [[UILabel alloc] init];
        _jackpotNumberLabel.font = [UIFont fontWithName:@"silom" size:24];
        _jackpotNumberLabel.textColor = [UIColor colorWithHex:0xFCC225];
        _jackpotNumberLabel.attributedText = [self attributedStringWithNumber:0];
    }
    return _jackpotNumberLabel;
}

- (void)setJackpotNumber:(NSInteger)jackpotNumber {
    _jackpotNumber = jackpotNumber;
    
    self.jackpotNumberLabel.attributedText = [self attributedStringWithNumber:jackpotNumber];
}

- (NSAttributedString *)attributedStringWithNumber:(NSInteger)number {
    
    NSString *jackpotString = [NSString stringWithFormat:@"¥%li", (long)number];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:jackpotString];
    [result addAttribute:NSKernAttributeName value:@10 range:NSMakeRange(0, result.length)];
    
    return result;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
