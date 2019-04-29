//
//  InputCell.m
//  XianjinXia
//
//  Created by sword on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "InputCell.h"

@interface InputCell ()

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic, readwrite) UITextField *inputTextField;

@end

@implementation InputCell
@synthesize inputValue = _inputValue;

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])]) {
        
        self.title.text = title;
        self.inputTextField.placeholder = placeholder;
        
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.inputTextField];
        
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
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.title.mas_right).with.offset(20);
            make.left.equalTo(self.contentView.mas_left).with.offset(90);
            make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeft);
            make.top.equalTo(self.contentView.mas_top).with.offset(kPaddingTop);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-kPaddingTop);
        }];
        [self.inputTextField setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    }
}

- (void)setInputValue:(NSString *)inputValue {
    self.inputTextField.text = inputValue;
}

- (NSString *)inputValue {
    return self.inputTextField.text;
}

- (UILabel *)title {
    
    if (!_title) {
        _title = [[UILabel alloc] init];
        
        _title.font = Font_Text_Label;
        _title.textColor = Color_SubTitle;
    }
    return _title;
}
- (UITextField *)inputTextField {
    
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        
        _inputTextField.font = Font_Text_Label;
        _inputTextField.textColor = Color_SubTitle;
    }
    return _inputTextField;
}

@end
