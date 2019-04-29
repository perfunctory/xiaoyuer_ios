//
//  LabelCell.m
//  XianjinXia
//
//  Created by 童欣凯 on 2018/1/29.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "LabelCell.h"

@interface LabelCell ()

@property(strong, nonatomic, nonnull) UILabel *title;

@end

@implementation LabelCell

- (instancetype)initWithLabel:(nonnull UILabel *)label backgroundColor:(UIColor *) backgroundColor {
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])]) {
        
        self.title = label;
        [self.contentView addSubview:self.title];
        
        [self setNeedsUpdateConstraints];
        self.backgroundColor = backgroundColor == nil ? [UIColor clearColor] : backgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.title.translatesAutoresizingMaskIntoConstraints) {
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeft);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
}

@end
