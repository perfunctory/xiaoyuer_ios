//
//  BorrowStateBottomView.m
//  XianjinXia
//
//  Created by sword on 2017/3/1.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BorrowStateBottomView.h"

@interface BorrowStateBottomView ()

@property (strong, nonatomic) UIImageView *stateBottom;

@end

@implementation BorrowStateBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.stateBottom];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.stateBottom.translatesAutoresizingMaskIntoConstraints) {
        
        [self.stateBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(0);//8
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right).with.offset(0);//-8
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
}

- (UIImageView *)stateBottom {
    
    if (!_stateBottom) {
        _stateBottom = [[UIImageView alloc] initWithImage:ImageNamed(@"")];//borrow_bottom_background
        
        [_stateBottom setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _stateBottom;
}
@end
