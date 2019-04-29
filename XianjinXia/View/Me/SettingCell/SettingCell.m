//
//  SettingCell.m
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell()

@property (nonatomic, strong) UIImageView   *imvIcon;
@property (nonatomic, strong) UILabel       *lblTitle;
@property (nonatomic, strong) UILabel       *lblContent;
@property (nonatomic, strong) UILabel       *lblLine;

@end

@implementation SettingCell

+ (SettingCell *)homeCellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"SettingCell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self.contentView addSubview:self.imvIcon];
    [self.contentView addSubview:self.lblTitle];
    [self.contentView addSubview:self.lblContent];
    [self.contentView addSubview:self.lblLine];
    
    [self.imvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(15*WIDTHRADIUS);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.equalTo([self switchNumberWithFloat:25.5*WIDTHRADIUS]);
        make.height.equalTo([self switchNumberWithFloat:25.5*WIDTHRADIUS]);
        
    }];

    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imvIcon.mas_right).offset(12.5*WIDTHRADIUS);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.height.equalTo(@17);
    }];
    _lblTitle.textColor = UIColorFromRGB(0x333333);
    
    [_lblContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.rightMargin.equalTo([self switchNumberWithFloat:15.f*WIDTHRADIUS]);
//        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView).offset(-15*WIDTHRADIUS);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    _lblContent.textColor = UIColorFromRGB(0x999999);
    
    [_lblLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo([self switchNumberWithFloat:54.5f*WIDTHRADIUS]);
        make.width.equalTo([self switchNumberWithFloat:SCREEN_WIDTH]);
        make.height.equalTo([self switchNumberWithFloat:0.5f*WIDTHRADIUS]);
    }];
    _lblLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
    _lblLine.textColor = [UIColor clearColor];
    
}

- (void)configCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath*)indexPath{

    _imvIcon.image = [UIImage imageNamed:dict[@"strIcon"]];
    _lblTitle.text = dict[@"strTitle"];
    if ([@"关于我们"isEqualToString:_lblTitle.text]) {
        self.lblContent.text=[@"v"stringByAppendingString:[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    }
//    if (indexPath.row==0||indexPath.row==1) {
//    _lblContent.text = dict[@"strContent"];
//    }else{
//        if (indexPath.row==2) {
//            self.backgroundColor = UIColorFromRGB(0xf2f2f2);
//            _lblLine.hidden = YES;
//        }
//    }
//    
//    if (indexPath.row==0||indexPath.row ==3) {
////        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
//        _lblLine.hidden = NO;
//    }else {
//        _lblLine.hidden = YES;
//    }
}

- (UIImageView *)imvIcon {
    if (!_imvIcon) {
        _imvIcon = [[UIImageView alloc] initWithImage:ImageNamed(@"")];
    }
    return _imvIcon;
}

-  (UILabel *)lblTitle {
    if (!_lblTitle) {
        _lblTitle = [self getLabelWithFontSize:FontSystem(16.0f) textColor:Color_Title withText:@""];
    }
    return _lblTitle;
}

-  (UILabel *)lblContent {
    if (!_lblContent) {
        _lblContent = [self getLabelWithFontSize:FontSystem(13.0f) textColor:Color_content withText:@""];
    }
    return _lblContent;
}

-  (UILabel *)lblLine {
    if (!_lblLine) {
        _lblLine = [self getLabelWithFontSize:FontSystem(13.0f) textColor:[UIColor clearColor] withText:@""];
    }
    return _lblLine;
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
