//
//  ContactsCell.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "ContactsCell.h"

@interface ContactsCell ()
@property (nonatomic, strong) UILabel   * lblTitle;
@property (nonatomic, strong) UIView    * vSep;
@end

@implementation ContactsCell

+ (ContactsCell *)contactsCellWithtableView:(UITableView *)tableView {
    static NSString * ID = @"ContactsCell";
    ContactsCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self.contentView addSubview:self.vSep];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    [super updateConstraints];
    __weak __typeof(self)weakSelf = self;
    [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.vSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-0.5*WIDTHRADIUS);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.height.equalTo(@0.5);
    }];
}

- (void)configCellWithName:(NSString *)name {
    self.lblTitle.text = name;
}

- (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.font = Font_SubTitle;
        _lblTitle.textColor = Color_Title;
    }
    return _lblTitle;
}

- (UIView *)vSep {
    if (!_vSep) {
        _vSep = [[UIView alloc] init];
        _vSep.backgroundColor = Color_LineColor;
    }
    return _vSep;
}

@end
