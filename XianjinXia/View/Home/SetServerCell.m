//
//  SetServerCell.m
//  XianjinXia
//
//  Created by 童欣凯 on 2018/3/12.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "SetServerCell.h"

@interface SetServerCell()

@property (nonatomic, strong) UILabel       *lblContent;

@end

@implementation SetServerCell

+ (SetServerCell *)homeCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"SetServerCell";
    SetServerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SetServerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createSubViews {
    __weak typeof(self) weakSelf = self;
    [self.contentView addSubview:self.lblContent];
    
    [_lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    _lblContent.textColor = UIColorFromRGB(0x333333);
}

- (void)configCellWithStr:(NSString *)str{
    _lblContent.text = str;
}

-  (UILabel *)lblContent {
    if (!_lblContent) {
        _lblContent = [self getLabelWithFontSize:FontSystem(15.0f) textColor:Color_content withText:@""];
    }
    return _lblContent;
}

- (UILabel *)getLabelWithFontSize:(UIFont *)font textColor:(UIColor *)textColor withText:(NSString *)title {
    UILabel * lbl = [[UILabel alloc] init];
    lbl.font = font;
    lbl.textColor = textColor;
    lbl.text = title;
    return lbl;
}

@end
