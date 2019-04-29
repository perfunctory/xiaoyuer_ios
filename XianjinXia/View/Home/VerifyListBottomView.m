//
//  VerifyListBottomView.m
//  XianjinXia
//
//  Created by sword on 2017/3/31.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "VerifyListBottomView.h"

#import "BankDataEncryptionView.h"

@interface VerifyListBottomView ()

@property (strong, nonatomic) BankDataEncryptionView *encryptionView;
@property (strong, nonatomic) UIButton *directionButton;
@property (strong, nonatomic) UILabel *directionDes;
@property (strong, nonatomic) UIImageView *directionImage;

@end

@implementation VerifyListBottomView

+ (instancetype)verifyListBottomView {
    
    return [[[self class] alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _direction = kPointToTheBottom;
        [self addAnimationForLabel];
        
        [self addSubview:self.encryptionView];
        [self addSubview:self.directionButton];
        [self addSubview:self.directionDes];
        [self addSubview:self.directionImage];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}
- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.encryptionView.translatesAutoresizingMaskIntoConstraints) {
        
        [self.directionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@44);
        }];
        [self.directionImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.directionButton.mas_centerY);
            make.height.equalTo(self.directionDes);
        }];
        [self.directionDes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.directionButton.mas_centerY);
            make.right.equalTo(self.directionImage.mas_left).with.offset(-5);
            make.centerX.equalTo(self.directionButton.mas_centerX).with.offset(-self.directionImage.bounds.size.width/2);
        }];
        
        [self.encryptionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.directionButton.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@40);
        }];
    }
}

#pragma mark - Private
- (void)clickDirectionButton:(UIButton *)sender {
    
    !self.directionButtonClicked ? : self.directionButtonClicked(self.direction);
}

#pragma mark - Setter

- (void)setDirection:(kPointToThe)direction {
    _direction = direction;
    
    self.directionDes.text = kPointToTheTop == direction ? @"收起" : @"更多加分认证";
    self.directionDes.textColor = kPointToTheTop == direction ? UIColorFromRGB(0x999999) : Color_Red;
    self.directionImage.image = ImageNamed(kPointToTheTop == direction ? @"direction_up" : @"direction_down");
    
    if (kPointToTheTop == direction) {
        [self removeAnimationForLabel];
    } else {
        [self addAnimationForLabel];
    }
}

- (void)addAnimationForLabel {
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"anchorPoint"];
    keyAnimation.values = @[[NSValue valueWithCGPoint:CGPointMake(0.5, 0.7)],
                            [NSValue valueWithCGPoint:CGPointMake(0.5, 0.3)]];
    keyAnimation.duration = 0.8f;
    keyAnimation.repeatCount = CGFLOAT_MAX;
    keyAnimation.autoreverses = YES;
    keyAnimation.removedOnCompletion = NO;
    
    [self.directionDes.layer addAnimation:keyAnimation forKey:nil];
    [self.directionImage.layer addAnimation:keyAnimation forKey:nil];
}
- (void)removeAnimationForLabel {
    [self.directionDes.layer removeAllAnimations];
    [self.directionImage.layer removeAllAnimations];
}

#pragma mark - Getter
- (BankDataEncryptionView *)encryptionView {
    
    if (!_encryptionView) {
        _encryptionView = [BankDataEncryptionView bankDataEncryptionView];
    }
    return _encryptionView;
}
- (UIButton *)directionButton {
    
    if (!_directionButton) {
        _directionButton = [[UIButton alloc] init];
        
        _directionButton.backgroundColor = [UIColor whiteColor];
        
        [_directionButton addTarget:self action:@selector(clickDirectionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _directionButton;
}
- (UIImageView *)directionImage {
    
    if (!_directionImage) {
        _directionImage = [[UIImageView alloc] initWithImage:ImageNamed(@"direction_down")];
        _directionImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _directionImage;
}
- (UILabel *)directionDes {
    
    if (!_directionDes) {
        _directionDes = [[UILabel alloc] init];
        
        _directionDes.font = FontSystem(15);
        _directionDes.textColor = Color_Red_New;
        _directionDes.text = @"更多加分认证";
    }
    return _directionDes;
}

@end
