//
//  KDBaseTableViewCellNew.m
//  KDLC
//
//  Created by 闫涛 on 15/6/15.
//  Copyright (c) 2015年 llyt. All rights reserved.
//

#import "KDBaseTableViewCellNew.h"

@implementation KDBaseTableViewCellNew

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    @try {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    @catch (NSException *exception) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    @finally {
        
    }
    
    if (self) {
        [self configUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configUI
{
    
}

- (void)updateTableViewCellWithdata:(NSArray *)entity index:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)heightForRow
{
    return 0;
}

- (UIButton *)createButton
{
    UIImage *image= [UIImage imageNamed:@"borrow_arrowright.jpg"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.backgroundColor= [UIColor clearColor];
    button.userInteractionEnabled = NO;
    return button;
}

- (NSMutableAttributedString *)attributeStringWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr leftFontSize:(CGFloat)leftSize rightFontSize:(CGFloat)rightSize leftColor:(NSString *)leftColorHex rightColor:(NSString *)rightColorHex
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",leftStr,rightStr]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:(long)leftColorHex] range:NSMakeRange(0, leftStr.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:(long)rightColorHex] range:NSMakeRange(leftStr.length, rightStr.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:leftSize] range:NSMakeRange(0, leftStr.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:rightSize] range:NSMakeRange(leftStr.length, rightStr.length)];
    return attributedString;
}

- (NSMutableAttributedString *)attributeStringWithLeftStr:(NSString *)leftStr rightStr:(NSString *)rightStr leftHaveLine:(BOOL)leftLine rightHaveLine:(BOOL)rightLine
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",leftStr,rightStr]];
    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0,attributedString.length)];
    if (!leftLine) {
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0, leftStr.length)];
    }
    if (!rightLine) {
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(leftStr.length, rightStr.length)];
    }
    return attributedString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
