//
//  RepaymentRecordCell.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "RepaymentRecordCell.h"

#define kFloat          13.25*WIDTHRADIUS

@interface RepaymentRecordCell ()
@property (nonatomic, strong) UILabel       * lblTitle;
@property (nonatomic, strong) UILabel       * lblTime;
@property (nonatomic, strong) UILabel       * lblStatus;
@property (nonatomic, strong) UIView        * vLine;
@property (nonatomic, strong) UIImageView   * imvJump;
@end

@implementation RepaymentRecordCell
+ (RepaymentRecordCell *)repaymentRecordCellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"RepaymentRecordCell";
    RepaymentRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[RepaymentRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self.contentView addSubview:self.lblTime];
    [self.contentView addSubview:self.lblStatus];
    [self.contentView addSubview:self.vLine];
    [self.contentView addSubview:self.imvJump];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    [super updateConstraints];
    __weak __typeof(self)weakSelf = self;
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(kFloat);
        make.height.equalTo(@17);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15*WIDTHRADIUS);
    }];
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lblTitle.mas_bottom).offset(7.5*WIDTHRADIUS);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15*WIDTHRADIUS);
        make.height.equalTo(@14);
    }];
    [self.imvJump mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15.f*WIDTHRADIUS);
    }];
    [self.lblStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.imvJump.mas_left).offset(-6.f*WIDTHRADIUS);
        make.height.equalTo(@14);
    }];
    [self.vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-0.5*WIDTHRADIUS);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.equalTo(@0.5);
    }];
}

- (void)configCellWithModel:(RecordModel *)model {
    self.lblTitle.text = model.title;
    self.lblTime.text = model.time;
    self.lblStatus.attributedText = [self addAttributeWithHtml5String:model.text];
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [self getLabelWithFont:Font_Title WithColor:Color_Title];
    }
    return _lblTitle;
}

- (UILabel *)lblTime {
    if (!_lblTime) {
        _lblTime = [self getLabelWithFont:Font_SubTitle WithColor:Color_content];
    }
    return _lblTime;
}

- (UILabel *)lblStatus {
    if (!_lblStatus) {
        _lblStatus = [self getLabelWithFont:Font_SubTitle WithColor:Color_Title];
    }
    return _lblStatus;
}

- (UIView *)vLine {
    if (!_vLine) {
        _vLine = [[UIView alloc] init];
        _vLine.backgroundColor = Color_LineColor;
    }
    return _vLine;
}

- (UIImageView *)imvJump {
    if (!_imvJump) {
        _imvJump = [[UIImageView alloc] initWithImage:ImageNamed(@"borrow_arrowright")];
    }
    return _imvJump;
}

- (UILabel *)getLabelWithFont:(UIFont *)font WithColor:(UIColor *)color {
    UILabel * lbl = [[UILabel alloc] init];
    lbl.textColor = color;
    lbl.font = font;
    lbl.textAlignment = NSTextAlignmentCenter;
    return lbl;
}

- (NSAttributedString *)addAttributeWithHtml5String:(NSString *)str
{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}

@end
