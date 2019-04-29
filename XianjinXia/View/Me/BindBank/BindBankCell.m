//
//  BindBankCell.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BindBankCell.h"

@interface BindBankCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel           * lblTitle;
@property (nonatomic, strong) UITextField       * tfInput;
@property (nonatomic, strong) UILabel           * lblContent;
@property (nonatomic, strong) UIImageView       * imvJump;
@property (nonatomic, strong) UIView            * vSep;
@end

@implementation BindBankCell

+ (BindBankCell *)bindBankCellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"BindBankCell";
    BindBankCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BindBankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)configCellWithDict:(NSDictionary *)dict withIndexPath:(NSIndexPath *)indexPath {
    self.tfInput.placeholder = dict[@"placeHolder"];
    self.tfInput.tag = indexPath.row;
    self.lblTitle.text = dict[@"title"];
    self.imvJump.hidden = ![dict[@"hasArrow"] integerValue];
    if ([dict[@"textColor"] isEqualToString:@"red"]) {
        self.tfInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:dict[@"placeHolder"] attributes:@{NSForegroundColorAttributeName:Color_Red}];
    }else if ([dict[@"title"] isEqualToString:@"持卡人"] || [dict[@"title"] isEqualToString:@"选择银行"]) {
        self.tfInput.userInteractionEnabled = [dict[@"title"] isEqualToString:@"持卡人"] ? NO : YES;
        self.tfInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:dict[@"placeHolder"] attributes:@{NSForegroundColorAttributeName: Color_Title}];
    }
    if ([dict[@"title"] isEqualToString:@"选择银行"]) {
        self.tfInput.userInteractionEnabled = NO;
    }
}

- (void)setupUI {
    [self.contentView addSubview:self.lblTitle];
    [self.contentView addSubview:self.tfInput];
    [self.contentView addSubview:self.lblContent];
    [self.contentView addSubview:self.imvJump];
    [self.contentView addSubview:self.vSep];
    [self updateConstraintsIfNeeded];
}

- (void)getInputStr:(UITextField *)tf {
    if (tf.tag == 2) {
        if (self.changeBlock) {
            self.changeBlock(@"card_no",tf.text);
        }
    }else {
        if (self.changeBlock) {
            self.changeBlock(@"phone",tf.text);
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //控制输入框输入长度
    NSInteger maxLength = 6;
    if (textField.tag == 2) {
        maxLength = 27;
    }else {
        maxLength = 11;
    }
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    return newLength <= maxLength || returnKey;
}

- (void)updateConstraints {
    [super updateConstraints];
    __weak __typeof(self)weakSelf = self;
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15*WIDTHRADIUS);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.imvJump mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15*WIDTHRADIUS);
    }];
    [self.tfInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(80*WIDTHRADIUS);
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-25*WIDTHRADIUS);
    }];
    [self.lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(95*WIDTHRADIUS);
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-25*WIDTHRADIUS);
    }];
    [self.vSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font = Font_SubTitle;
    }
    return _lblTitle;
}

- (UITextField *)tfInput {
    if (!_tfInput) {
        _tfInput = [[UITextField alloc] init];
        _tfInput.textColor = Color_Title;
        _tfInput.font = (iPhone4 || iPhone5) ? Font_Focus : Font_SubTitle;
        _tfInput.delegate = self;
        _tfInput.keyboardType = UIKeyboardTypeNumberPad;
        [_tfInput addTarget:self action:@selector(getInputStr:) forControlEvents:UIControlEventEditingChanged];
    }
    return _tfInput;
}

- (UILabel *)lblContent {
    if (!_lblContent) {
        _lblContent = [[UILabel alloc] init];
        _lblContent.textColor = Color_Red;
        _lblContent.font = Font_SubTitle;
    }
    return _lblContent;
}

- (UIImageView *)imvJump {
    if (!_imvJump) {
        _imvJump = [[UIImageView alloc] initWithImage:ImageNamed(@"borrow_arrowright")];
    }
    return _imvJump;
}

- (UIView *)vSep {
    if (!_vSep) {
        _vSep = [[UIView alloc] init];
        _vSep.backgroundColor = Color_LineColor;
    }
    return _vSep;
}


@end
