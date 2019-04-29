//
//  BindBankFooterView.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/3/8.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BindBankFooterView.h"

@interface BindBankFooterView ()
@property (strong, nonatomic)UILabel        * lblContent;
@property (strong, nonatomic) UIImageView   * verifyImage;
@property (strong, nonatomic) UILabel       * verifyLabel;
@end

@implementation BindBankFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.lblContent];
        [self addSubview:self.verifyImage];
        [self addSubview:self.verifyLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

+ (instancetype)bindBankEncryptionView {
    return [[[self class] alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.lblContent.translatesAutoresizingMaskIntoConstraints) {
        [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX).offset(-10*WIDTHRADIUS);
            make.centerY.equalTo(self.mas_centerY).offset(-20*WIDTHRADIUS);
        }];
        
        [self.verifyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(15*WIDTHRADIUS);
        }];
        [self.verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.verifyImage.mas_right).with.offset(5);
            make.centerY.equalTo(self.mas_centerY).offset(15*WIDTHRADIUS);
            make.centerX.equalTo(self.mas_centerX).with.offset(-self.verifyImage.bounds.size.width/2);
        }];
    }
}

- (UILabel *)lblContent {
    if (!_lblContent) {
        _lblContent = [[UILabel alloc] init];
        _lblContent.textAlignment = NSTextAlignmentCenter;
        _lblContent.font = FontSystem(12);
        _lblContent.textColor = Color_SubTitle;
        _lblContent.text = @"绑定银行卡即开通代扣功能";
    }
    return _lblContent;
}

- (UIImageView *)verifyImage {
    
    if (!_verifyImage) {
        _verifyImage = [[UIImageView alloc] initWithImage:ImageNamed(@"KDVerify")];
    }
    return _verifyImage;
}
- (UILabel *)verifyLabel {
    
    if (!_verifyLabel) {
        _verifyLabel = [[UILabel alloc] init];
        
        _verifyLabel.textColor = Color_Red_New;
        _verifyLabel.text = @"银行级数据加密保护";
        _verifyLabel.font = FontSystem(12);
    }
    return _verifyLabel;
}

@end
