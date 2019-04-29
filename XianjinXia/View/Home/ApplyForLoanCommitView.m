//
//  ApplyForLoanCommitView.m
//  XianjinXia
//
//  Created by sword on 14/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import "ApplyForLoanCommitView.h"

@interface ApplyForLoanCommitView ()

@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIButton *commitButton;

@property (strong, nonatomic) UIButton *check;
@property (strong, nonatomic) UILabel *leftOfProtocol;
@property (strong, nonatomic) UIButton *protocol;
@property (strong, nonatomic) UIButton *service;

@property (strong, nonatomic) UIView *line;

@end

@implementation ApplyForLoanCommitView
@synthesize tipString = _tipString;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tipLabel];
        [self addSubview:self.commitButton];
        [self addSubview:self.check];
        [self addSubview:self.leftOfProtocol];
        [self addSubview:self.protocol];
        [self addSubview:self.service];
        [self addSubview:self.line];
        
        self.backgroundColor = [UIColor whiteColor];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

+ (instancetype)applyForLoanCommitView {
    return [[[self class] alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.tipLabel.translatesAutoresizingMaskIntoConstraints) {
        
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(@15);
        }];
        [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(self.tipLabel.mas_top).with.offset(50);
            make.right.equalTo(@(-15));
            make.height.equalTo(@(40));
        }];
        [self.check mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(self.commitButton.mas_bottom).with.offset(15);
        }];
        [self.leftOfProtocol mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.check.mas_right).with.offset(5);
            make.centerY.equalTo(self.check.mas_centerY);
        }];
        [self.protocol mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftOfProtocol.mas_right);
            make.centerY.equalTo(self.check.mas_centerY);
        }];
        [self.service mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftOfProtocol.mas_left);
            make.top.equalTo(self.leftOfProtocol.mas_bottom);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(kSeparatorHeight));
        }];
    }
}

- (void)nextStep {
    !self.clickCommitBlock ? : self.clickCommitBlock();
}
- (void)checkProtocol:(UIButton *)sender {
    
    if (sender.tag > self.protocolArray.count) {
        return;
    }
    !self.checkProtocolBlock ? : self.checkProtocolBlock( self.protocolArray[sender.tag]);
}

- (void)setTipString:(NSString *)tipString {
    
    self.tipLabel.text = tipString;
}
- (void)setEnableOfApplyButton:(BOOL)enableOfApplyButton {
    
    self.commitButton.enabled = enableOfApplyButton;
}

- (NSString *)tipString {
    
    return self.tipLabel.text;
}

- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        
        _tipLabel.font = Font_SubTitle;
        _tipLabel.textColor = Color_Title;
    }
    return _tipLabel;
}
- (UIButton *)commitButton {
    
    if (!_commitButton) {
        _commitButton = [[UIButton alloc] init];
        _commitButton.titleLabel.font = FONT(18);
        [_commitButton setTitle:@"确认申请" forState:UIControlStateNormal];
        [_commitButton setBackgroundImage:ImageNamed(@"button_red_background") forState:UIControlStateNormal];
        [_commitButton setBackgroundImage:ImageNamed(@"button_gray_background") forState:UIControlStateDisabled];
        [_commitButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        [_commitButton setTitleColor:Color_White forState:UIControlStateNormal];
    }
    return _commitButton;
}

- (UIButton *)check {
    
    if (!_check) {
        _check = [[UIButton alloc] init];
        
        [_check setImage:ImageNamed(@"borrow_chose_no") forState:UIControlStateNormal];
        [_check setImage:ImageNamed(@"borrow_chose") forState:UIControlStateSelected];
        [_check addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
        _check.selected = YES;
    }
    return _check;
}

- (void)checkboxClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    !self.checkBlock ? : self.checkBlock();
}

- (BOOL)checked{
    return self.check.selected;
}

- (UILabel *)leftOfProtocol {
    
    if (!_leftOfProtocol) {
        _leftOfProtocol = [[UILabel alloc] init];
        
        _leftOfProtocol.text = @"我已阅读并同意";
        _leftOfProtocol.font = Font_SubTitle;
        _leftOfProtocol.textColor = Color_SubTitle;
    }
    return _leftOfProtocol;
}
- (UIButton *)protocol {
    
    if (!_protocol) {
        _protocol = [[UIButton alloc] init];
        
        _protocol.tag = 0;
        _protocol.titleLabel.font = Font_SubTitle;
        [_protocol setTitle:@"《信合宝借款协议》" forState:UIControlStateNormal];
        [_protocol setTitleColor:Color_Red forState:UIControlStateNormal];
        [_protocol addTarget:self action:@selector(checkProtocol:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocol;
}
- (UIButton *)service {
    
    if (!_service) {
        _service = [[UIButton alloc] init];
        
        _service.tag = 1;
        _service.titleLabel.font = [UIFont systemFontOfSize:12];
        [_service setTitle:@"本人已经明确且同意以上借款协议操作会产生的费用" forState:UIControlStateNormal];
        [_service setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _service.userInteractionEnabled = NO;
    }
    return _service;
}

- (UIView *)line {
    
    if (!_line) {
        _line = [[UIView alloc] init];
        
        _line.backgroundColor = Color_LineColor;
    }
    return _line;
}

@end
