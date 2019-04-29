//
//  MyAwardCell.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "MyAwardCell.h"

@interface MyAwardCell ()
@property (strong, nonatomic) UILabel *lblTime;
@property (strong, nonatomic) UILabel *lblMyAward;
@property (strong, nonatomic) UILabel *lblSource;
@property (strong, nonatomic) UILabel *lblStatus;
@end

@implementation MyAwardCell

+ (MyAwardCell *)myAwardCellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"MyAwardCell";
    MyAwardCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MyAwardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self.contentView addSubview:self.lblTime];
    [self.contentView addSubview:self.lblMyAward];
    [self.contentView addSubview:self.lblSource];
    [self.contentView addSubview:self.lblStatus];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    __weak __typeof(self)weakSelf = self;
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
    }];
    [self.lblMyAward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lblTime.mas_right);
        make.width.and.height.equalTo(weakSelf.lblTime);
    }];
    [self.lblSource mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lblMyAward.mas_right);
        make.width.and.height.equalTo(weakSelf.lblMyAward);
    }];
    [self.lblStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lblSource.mas_right);
        make.width.and.height.equalTo(weakSelf.lblSource);
        make.right.equalTo(weakSelf.contentView.mas_right);
    }];
}

- (void)configCellWithModel:(MyAwardDetailModel *)model withIndexPath:(NSIndexPath *)indexPath {
    self.contentView.backgroundColor = @[[UIColor colorWithHex:0xededed],[UIColor colorWithHex:0xf6f6f6]][indexPath.row%2];
    _lblTime.text = model.periods;
    _lblMyAward.text = model.luckyDraw;
    _lblSource.text = model.stepName;
    _lblStatus.text = [self setupStatus:model];
}

- (NSString *)setupStatus:(MyAwardDetailModel *)model {
    if ([model.status integerValue] == 0) {
        return @"未开奖";
    }else if ([model.status integerValue] == 1) {
        return @"未中奖";
    }else {
        return [NSString stringWithFormat:@"抽中\n%@元",model.awardMoney];
    }
}

- (UILabel *)lblTime {
    if (!_lblTime) {
        _lblTime = [self getLabel];
    }
    return _lblTime;
}

- (UILabel *)lblStatus {
    if (!_lblStatus) {
        _lblStatus = [self getLabel];
        _lblStatus.numberOfLines = 0;
    }
    return _lblStatus;
}

- (UILabel *)lblSource {
    if (!_lblSource) {
        _lblSource = [self getLabel];
    }
    return _lblSource;
}

- (UILabel *)lblMyAward {
    if (!_lblMyAward) {
        _lblMyAward = [self getLabel];
    }
    return _lblMyAward;
}

- (UILabel *)getLabel {
    UILabel * lbl = [[UILabel alloc] init];
    lbl.textColor = Color_SubTitle;
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.text = @"1111";
    lbl.textAlignment = NSTextAlignmentCenter;
    return lbl;
}

@end
