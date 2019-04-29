//
//  SelectionCell.m
//  XianjinXia
//
//  Created by sword on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SelectionCell.h"

@interface SelectionCell ()

@property (strong, nonatomic, readwrite) UILabel *title;
@property (strong, nonatomic, readwrite) UILabel *subTitle;
@property (strong, nonatomic, readwrite) UIImageView *rightIndicate;

@end

@implementation SelectionCell

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])]) {
        self.title.text = title;
        self.subTitle.text = subTitle;
        
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.subTitle];
        [self.contentView addSubview:self.rightIndicate];
        
        [self setNeedsUpdateConstraints];
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
        [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.title.mas_right).with.offset(20);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).with.offset(90);
//            make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeft);
        }];
        [self.rightIndicate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeft);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.subTitle.mas_right).with.offset(kPaddingLeft);
        }];
        [self.subTitle setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    }
}

- (void)setSubTitleValue:(NSString *)subTitleValue {
    
    self.subTitle.text = subTitleValue;
}
- (void)setSubTitleTextAlignment:(NSTextAlignment)alignment {
    
    self.subTitle.textAlignment = alignment;
}

- (UILabel *)title {
    
    if (!_title) {
        _title = [[UILabel alloc] init];
        
        _title.font = Font_Text_Label;
        _title.textColor = Color_SubTitle;
    }
    return _title;
}
- (UILabel *)subTitle {
    
    if (!_subTitle) {
        _subTitle = [[UILabel alloc] init];
        
        _subTitle.font = Font_Text_Label;
        _subTitle.textColor = Color_SubTitle;
    }
    return _subTitle;
}
- (UIImageView *)rightIndicate {
    
    if (!_rightIndicate) {
        _rightIndicate = [[UIImageView alloc] initWithImage:ImageNamed(@"borrow_arrowright")];
    }
    return _rightIndicate;
}

@end
