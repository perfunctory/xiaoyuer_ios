//
//  BankDataEncryptionView.m
//  XianjinXia
//
//  Created by sword on 10/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import "BankDataEncryptionView.h"

@interface BankDataEncryptionView ()

@property (strong, nonatomic) UIImageView *verifyImage;
@property (strong, nonatomic) UILabel *verifyLabel;
@end

@implementation BankDataEncryptionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.verifyImage];
        [self addSubview:self.verifyLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

+ (instancetype)bankDataEncryptionView {
    return [[[self class] alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.verifyLabel.translatesAutoresizingMaskIntoConstraints) {
        
        [self.verifyImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
        }];
        [self.verifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.verifyImage.mas_right).with.offset(5);
            make.centerY.equalTo(self.mas_centerY).with.offset(0);
            make.centerX.equalTo(self.mas_centerX).with.offset(self.verifyImage.bounds.size.width/2);
        }];
    }
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
