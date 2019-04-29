//
//  ReloadView.m
//  Jdmobile
//
//  Created by steven sun on 12/23/11.
//  Copyright 2011 360buy. All rights reserved.
//

#import "NoNetReloadView.h"
#import "UIImageView+lyt.h"
#import <Lyt.h>
#import "UILabel+lyt.h"

@interface NoNetReloadView()


@end

@implementation NoNetReloadView

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
    __weak typeof(self) weakSelf = self;
    _nonetView = [UIImageView getImageViewWithImageName:@"table_nonet" superView:self lytSet:^(UIImageView *imageView) {
        [imageView lyt_centerXInParent];
        [imageView lyt_alignTopToParentWithMargin:162 * WIDTHRADIUS];
        [imageView lyt_setSize:CGSizeMake(108 * WIDTHRADIUS, 87 * WIDTHRADIUS)];
    }];
    
    _tipLabel = [UILabel getLabelWithFontSize:13 textColor:Color_Title superView:self lytSet:^(UILabel *label) {
        [label lyt_centerXInParent];
        [label lyt_placeBelowView:weakSelf.nonetView margin:19 * WIDTHRADIUS];
    }];
    _tipLabel.text = @"无网络信号";
    
    self.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    _reloadBtn = [UILabel getLabelWithFontSize:15 textColor:Color_content superView:self lytSet:^(UILabel *label) {
        [label lyt_centerXInParent];
        [label lyt_placeBelowView:weakSelf.tipLabel margin:22 * WIDTHRADIUS];
    }];
    _reloadBtn.text = @"请检查网络是否正常后，点屏幕重试";
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadAction)];
    [self addGestureRecognizer:gesture];
}

- (void) reloadAction
{
    if (_btnClick) {
        _btnClick();
    }
}

@end
