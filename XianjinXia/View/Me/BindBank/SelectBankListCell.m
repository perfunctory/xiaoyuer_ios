//
//  SelectBankListCell.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/13.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SelectBankListCell.h"
#import "UIImageView+WebCache.h"

@interface SelectBankListCell ()
@property (nonatomic, strong) UIImageView   * imvBankIcon;
@property (nonatomic, strong) UILabel       * lblBankName;
@property (nonatomic, strong) UIView        * vLine;
@end

@implementation SelectBankListCell

+ (SelectBankListCell *)selectBankListCellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"SelectBankListCell";
    SelectBankListCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SelectBankListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self.contentView addSubview:self.imvBankIcon];
    [self.contentView addSubview:self.lblBankName];
    [self.contentView addSubview:self.vLine];
    [self updateConstraintsIfNeeded];
}

- (void)configCellWithModel:(BankList *)model withIndexPath:(NSIndexPath *)indexPath {
    [self.imvBankIcon sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"bannerdefaulenew"]];
    self.lblBankName.text = model.bank_name;
}

- (void)updateConstraints {
    [super updateConstraints];
    __weak __typeof(self)weakSelf = self;
    [self.imvBankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15*WIDTHRADIUS);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    [self.lblBankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.imvBankIcon.mas_right).offset(10);
    }];
    [self.vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-1);
        make.height.equalTo(@0.5);
    }];
}

- (UIImageView *)imvBankIcon {
    if (!_imvBankIcon) {
        _imvBankIcon = [[UIImageView alloc] init];
    }
    return _imvBankIcon;
}

- (UILabel *)lblBankName {
    if (!_lblBankName) {
        _lblBankName = [[UILabel alloc] init];
        _lblBankName.font = Font_SubTitle;
        _lblBankName.textColor = Color_Title;
    }
    return _lblBankName;
}

- (UIView *)vLine {
    if (!_vLine) {
        _vLine = [[UIView alloc] init];
        _vLine.backgroundColor = Color_LineColor;
    }
    return _vLine;
}

@end
