//
//  KDRepayHeadView.m
//  KDFDApp
//
//  Created by Innext on 16/9/21.
//  Copyright © 2016年 cailiang. All rights reserved.
//

#import "RepayHeadView.h"

@interface RepayHeadView ()

@property (nonatomic, strong) UILabel   * lblTitle;

@end

@implementation RepayHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatHeadView];
    }
    return self;
}

- (void)creatHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30*WIDTHRADIUS)];
    headView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    [self addSubview:headView];
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 30*WIDTHRADIUS)];
    self.lblTitle.font = [UIFont systemFontOfSize:15.f];
    self.lblTitle.textColor = [UIColor colorWithHex:0x999999];
    [headView addSubview:self.lblTitle];
}

- (void)configViewWithModel:(RepaymentModel *)model withSection:(NSInteger)section {
    if (model == nil) {
        model.count = 0;
    }
    NSMutableAttributedString * repay = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"全部待还 %ld 笔",(long)model.count]];
    [repay addAttribute:NSForegroundColorAttributeName value:Color_Red range:NSMakeRange(5, 1)];
    self.lblTitle.attributedText = repay;
}

@end
