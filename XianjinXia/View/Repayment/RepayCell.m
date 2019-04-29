//
//  KDRepayCell.m
//  KDFDApp
//
//  Created by Innext on 16/9/21.
//  Copyright © 2016年 cailiang. All rights reserved.
//

#import "RepayCell.h"

@interface RepayCell ()

@property (nonatomic, strong) UILabel       * lblTimeDesc;
@property (nonatomic, strong) UILabel       * lblTime;
@property (nonatomic, strong) UIView        * vVer;
@property (nonatomic, strong) UILabel       * lblMoney;
@property (nonatomic, strong) UILabel       * lblStatus;
@property (nonatomic, strong) UILabel       * lblLoanMoney;
@property (nonatomic, strong) UILabel       * lblLoanPro;
@property (nonatomic, strong) UIImageView   * imvJump;

@end

@implementation RepayCell

+ (RepayCell *)repayCellWithTableView:(UITableView *)tableView {
    static NSString * ID = @"RepayCell";
    RepayCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if ( !cell ) {
        cell = [[RepayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsZero;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self.contentView addSubview:self.lblTimeDesc];
    [self.contentView addSubview:self.vVer];
    [self.contentView addSubview:self.lblStatus];
    [self.contentView addSubview:self.lblMoney];
    [self.contentView addSubview:self.lblLoanMoney];
    [self.contentView addSubview:self.lblLoanPro];
    [self.contentView addSubview:self.imvJump];
    
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    __weak __typeof(self) weakSelf = self;
    [self.lblTimeDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15*WIDTHRADIUS);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(30*WIDTHRADIUS);
        make.width.equalTo([self switchNumberWithFloat:100*WIDTHRADIUS]);
        make.height.equalTo(@20);
    }];
    
    [self.lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lblTimeDesc.mas_bottom).offset(5*WIDTHRADIUS);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15*WIDTHRADIUS);
        make.width.equalTo([weakSelf switchNumberWithFloat:100*WIDTHRADIUS]);
        make.height.equalTo(@20);
    }];
    [self.vVer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.left.equalTo(weakSelf.lblTime.mas_right).offset(2);
        make.width.equalTo(@0.5);
    }];
    [self.lblStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15*WIDTHRADIUS);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(15*WIDTHRADIUS);
    }];
    [self.lblMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.lblStatus.mas_left).offset(-15*WIDTHRADIUS);
        make.left.equalTo(weakSelf.vVer.mas_right).offset(15*WIDTHRADIUS);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(15*WIDTHRADIUS);
    }];
    [self.lblLoanMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lblMoney.mas_bottom).offset(5*WIDTHRADIUS);
        make.left.equalTo(weakSelf.vVer.mas_right).offset(15*WIDTHRADIUS);
    }];
    [self.lblLoanPro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.vVer.mas_right).offset(15*WIDTHRADIUS);
        make.top.equalTo(weakSelf.lblLoanMoney.mas_bottom).offset(5*WIDTHRADIUS);
    }];
    [self.imvJump mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(15*WIDTHRADIUS);
        make.centerY.equalTo(weakSelf.contentView).offset(10*WIDTHRADIUS);
        make.width.equalTo(@8);
        make.height.equalTo(@15);
    }];
}

- (void)configCellWithData:(RepayAmountModel *)model withIndexPath:(NSIndexPath *)indexPath {
    self.lblTime.text = model.plan_fee_time;
    self.lblMoney.text = [NSString stringWithFormat:@"￥%@",model.debt];
    self.lblLoanMoney.text = [NSString stringWithFormat:@"到账金额: %@元",model.receipts];
    self.lblLoanPro.text = [NSString stringWithFormat:@"服务费用: %@元",model.counter_fee];
    NSString * htmlStr = [NSString stringWithFormat:@"%s%@%@","<div style=\"float:right; text-align:right\">",model.text_tip,@"</div>"];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    self.lblStatus.attributedText = attrStr;
}

- (UIImageView *)imvJump {
    if (!_imvJump) {
        _imvJump = [[UIImageView alloc] initWithImage:ImageNamed(@"borrow_arrowright")];
    }
    return _imvJump;
}

- (UILabel *)lblLoanMoney {
    if (!_lblLoanMoney) {
        _lblLoanMoney = [self getLabelWithFontSize:Repayment_SubTitle textColor:Color_SubTitle withText:@"到账金额:---"];
    }
    return _lblLoanMoney;
}

- (UILabel *)lblLoanPro {
    if (!_lblLoanPro) {
        _lblLoanPro = [self getLabelWithFontSize:Repayment_SubTitle textColor:Color_SubTitle withText:@"服务费用:---"];
    }
    return _lblLoanPro;
}

- (UILabel *)lblStatus {
    if (!_lblStatus) {
        _lblStatus = [self getLabelWithFontSize:Repayment_SubTitle textColor:Color_Red withText:@"---"];
        _lblStatus.textAlignment = NSTextAlignmentRight;
    }
    return _lblStatus;
}

-  (UILabel *)lblMoney {
    if (!_lblMoney) {
        _lblMoney = [self getLabelWithFontSize:Repayment_Money textColor:Color_Title withText:@"111"];
    }
    return _lblMoney;
}

- (UIView *)vVer {
    if (!_vVer) {
        _vVer = [[UIView alloc] init];
        _vVer.backgroundColor = [UIColor colorWithHex:0xe6e6e6];
    }
    return _vVer;
}

- (UILabel *)lblTime {
    if (!_lblTime) {
        _lblTime = [self getLabelWithFontSize:Repayment_Title textColor:Color_Title withText:@"---"];
        _lblTime.textAlignment = NSTextAlignmentCenter;
        [_lblTime sizeToFit];
    }
    return _lblTime;
}

- (UILabel *)lblTimeDesc {
    if (!_lblTimeDesc) {
        _lblTimeDesc = [self getLabelWithFontSize:Repayment_SubTitle textColor:Color_Title withText:@"还款时间"];
        _lblTimeDesc.textAlignment = NSTextAlignmentCenter;
    }
    return _lblTimeDesc;
}

- (UILabel *)getLabelWithFontSize:(UIFont *)font textColor:(UIColor *)textColor withText:(NSString *)title {
    UILabel * lbl = [[UILabel alloc] init];
    lbl.font = font;
    lbl.textColor = textColor;
    lbl.text = title;
    return lbl;
}

- (NSNumber *)switchNumberWithFloat:(float)floatValue {
    return [NSNumber numberWithFloat:floatValue];
}

@end
