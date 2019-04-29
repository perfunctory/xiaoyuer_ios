//
//  NoDataView.m
//  KDLC
//
//  Created by summertian on 14/11/24.
//  Copyright (c) 2014年 KD. All rights reserved.
//

#import "NoDataView.h"
//#import "UIColor+Additions.h"
#import <Lyt.h>
#import "UILabel+lyt.h"
#import "UIImageView+lyt.h"
#import "UIButton+lyt.h"

@interface NoDataView()


@end

@implementation NoDataView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
   self.imageView = [UIImageView getImageViewWithImageName:@"table_nodata" superView:self lytSet:^(UIImageView *imageView) {
        [imageView lyt_centerXInParent];
         _imageTop = [imageView lyt_alignTopToParentWithMargin:50 * WIDTHRADIUS];
    }];
    
    _detailLabel = [UILabel getLabelWithFontSize:13 textColor:[UIColor colorWithHex:0x333333] superView:self lytSet:^(UILabel *label) {
        [label lyt_centerXInParent];
        [label lyt_placeBelowView:self.imageView margin:18 * WIDTHRADIUS];
    }];
    
    _detailLabel.text = @"暂无记录";
    self.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadAction)];
    [self addGestureRecognizer:gesture];
    
    _btnBorrow = [UIButton getButtonWithFontSize:18 TextColorHex:Color_White backGroundColor2:[UIColor clearColor] superView:self lytSet:^(UIButton *button) {
        _btnTop = [button lyt_placeBelowView:_detailLabel margin:50*WIDTHRADIUS];
        _btnHeght =[button lyt_setHeight:40];
        _btnwidth= [button lyt_setWidth:240];
        [button lyt_centerXInParent];
        button.hidden = YES;
        [button setTitle:@"马上借款" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_red_background"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(borrowBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }];

    
//    _btnRepay = [UIButton getButtonWithFontSize:14 TextColorHex:0x1291e9 backGroundColor2:[UIColor clearColor] superView:self lytSet:^(UIButton *button) {
//        [button lyt_centerXInParent];
//        [button lyt_placeBelowView:_btnBorrow margin:15*WIDTHRADIUS];
////        [button lyt_setSize:CGSizeMake(100, 25)];
//        [button addTarget:self action:@selector(userRepay) forControlEvents:UIControlEventTouchUpInside];
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"老用户如何还款"];
//        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, str.length)];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x1291e9] range:NSMakeRange(0, str.length)];
//        [button setAttributedTitle:str forState:UIControlStateNormal];
//        button.hidden = YES;
//    }];
}


- (void)borrowBtnTapped {
    if (self.getBorrowBlock) {
        self.getBorrowBlock();
    }
}

- (void)userRepay {
    if (self.userBlock) {
        self.userBlock();
    }
}

- (void) reloadAction
{
    if (_btnClick) {
        _btnClick();
    }
}

@end
