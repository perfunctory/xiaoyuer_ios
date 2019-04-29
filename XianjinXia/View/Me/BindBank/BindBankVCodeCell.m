//
//  BindBankVCodeCell.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/13.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BindBankVCodeCell.h"

@interface BindBankVCodeCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel           * lblTitle;
@property (nonatomic, strong) UITextField       * tfCode;
@property (nonatomic, strong) UIView            * vCodeSep;
@property (nonatomic, strong) UILabel           * lblGetCode;
@property (nonatomic, strong) UIButton          * btnGetCode;

@end

@implementation BindBankVCodeCell

+ (BindBankVCodeCell *)bindBankVCodeCellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"BindBankVCodeCell";
    BindBankVCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BindBankVCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.lblTitle];
    [self.contentView addSubview:self.tfCode];
    [self.contentView addSubview:self.vCodeSep];
    [self.contentView addSubview:self.lblGetCode];
    [self.contentView addSubview:self.btnGetCode];
    [self updateConstraintsIfNeeded];
}

- (void)configCellWithDict:(NSDictionary *)dict withIndexPath:(NSIndexPath *)indexPath {
    self.tfCode.placeholder = dict[@"placeHolder"];
    self.lblTitle.text = dict[@"title"];
}

- (void)GetCode {
    if (self.getVCodeBlock) {
        self.getVCodeBlock(1, @"",self.lblGetCode, self.btnGetCode);
    }
}
- (void)getInputStr:(UITextField *)tf {
    if (self.getVCodeBlock) {
        self.getVCodeBlock(0, tf.text, self.lblGetCode, self.btnGetCode);
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    __weak __typeof(self)weakSelf = self;
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15*WIDTHRADIUS);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.btnGetCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.width.equalTo(@100);
    }];
    [self.lblGetCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.width.equalTo(@100);
    }];
    [self.vCodeSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.lblGetCode.mas_left).offset(-1);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(2);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-2);
        make.width.equalTo(@0.5);
    }];
    [self.tfCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(80*WIDTHRADIUS);
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.right.equalTo(weakSelf.vCodeSep.mas_left).offset(-1);
    }];
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font = Font_SubTitle;
    }
    return _lblTitle;
}

- (UITextField *)tfCode {
    if (!_tfCode) {
        _tfCode = [[UITextField alloc] init];
        _tfCode.textColor = Color_Title;
        _tfCode.font = Font_SubTitle;
        _tfCode.delegate = self;
        _tfCode.keyboardType = UIKeyboardTypeNumberPad;
        [_tfCode addTarget:self action:@selector(getInputStr:) forControlEvents:UIControlEventEditingChanged];
    }
    return _tfCode;
}

- (UIView *)vCodeSep {
    if (!_vCodeSep) {
        _vCodeSep = [[UIView alloc] init];
        _vCodeSep.backgroundColor = Color_LineColor;
    }
    return _vCodeSep;
}

- (UILabel *)lblGetCode {
    if (!_lblGetCode) {
        _lblGetCode = [[UILabel alloc] init];
        _lblGetCode.text = @"发送验证码";
        _lblGetCode.textColor = Color_Red;
        _lblGetCode.font = Font_SubTitle;
        _lblGetCode.textAlignment = NSTextAlignmentCenter;
    }
    return _lblGetCode;
}

- (UIButton *)btnGetCode {
    if (!_btnGetCode) {
        _btnGetCode = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnGetCode setTitle:@"" forState:normal];
        [_btnGetCode addTarget:self action:@selector(GetCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnGetCode;
}


@end
