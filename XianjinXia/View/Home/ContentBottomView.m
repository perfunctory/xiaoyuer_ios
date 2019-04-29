//
//  ContentBottomView.m
//  XianjinXia
//
//  Created by sword on 2017/3/1.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "ContentBottomView.h"

@interface ContentBottomView ()

@property (strong, nonatomic) UIImageView *background;

@end

@implementation ContentBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.background];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.background.translatesAutoresizingMaskIntoConstraints) {
        
        [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(8);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right).with.offset(-8);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
}


- (UIImageView *)background {
    
    if (!_background) {
        _background = [[UIImageView alloc] initWithImage:ImageNamed(@"")];//amount_bottom_background
    }
    return _background;
}

@end
