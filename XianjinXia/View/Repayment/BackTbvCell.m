//
//  BackTbvCell.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BackTbvCell.h"
#import "UIImageView+WebCaChe.h"

@interface BackTbvCell()
@property(nonatomic, strong) UILabel         * title;
@property(nonatomic, strong) UIImageView     * iconImageView;
@property(nonatomic, strong) UIView          * lineView;
@end

@implementation BackTbvCell

+ (BackTbvCell *)backTbvCellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"BackTbvCell";
    BackTbvCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if ( !cell ) {
        cell = [[BackTbvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return  self;
}

- (void)configCellWithModel:(Reimbursement *)model withIndexPath:(NSIndexPath *)indexPath {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:ImageNamed(@"ascending_icon_normal")];
    self.title.text = model.title ? model.title : @"";
}

- (void)configUI {
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.lineView];
    
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    __weak __typeof(self)weakSelf = self;
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15.f);
        make.width.equalTo([weakSelf switchNumberWithFloat:20*WIDTHRADIUS]);
        make.height.equalTo([weakSelf switchNumberWithFloat:20*WIDTHRADIUS]);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(15*WIDTHRADIUS);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.height.equalTo(@0.5);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
    }];
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = Repayment_BackTitle;
        _title.textColor = Color_Title;
    }
    return _title;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:ImageNamed(@"ascending_icon_normal")];
    }
    return _iconImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = Color_LineColor;
    }
    return _lineView;
}

- (NSNumber *)switchNumberWithFloat:(float)floatValue {
    return [NSNumber numberWithFloat:floatValue];
}

@end
