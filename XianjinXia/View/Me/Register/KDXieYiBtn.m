//
//  KDXieYiBtn.m
//  KDIOSApp
//
//  Created by haoran on 16/5/27.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "KDXieYiBtn.h"
#import "UIButton+lyt.h"
#import "UILabel+lyt.h"
#import <Lyt.h>
@interface KDXieYiBtn()
@property (nonatomic, retain) NSString *xieyiName_1;
@property (nonatomic, retain) NSString *xieyiName_2;
@property (nonatomic, retain) UIButton *xieyiBtn;
@property (nonatomic, retain) UILabel *xieyiLabel;
@property (nonatomic, retain) UILabel *xieyiLabel2;
@property (nonatomic, retain) id placeView;
@property (nonatomic, retain) id mySuperView;
@end
@implementation KDXieYiBtn
- (instancetype)initWithXieyiName:(NSArray *)nameArr topView:(id)view superView:(id)backView
{
    if (self = [super init]) {
        _xieyiName_1 = nameArr[0];
        _xieyiName_2 = nameArr[1];
        _placeView = view;
        _mySuperView = backView;
        self.userInteractionEnabled = YES;
        self.frame = CGRectZero;
        self.backgroundColor = [UIColor clearColor];
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    
    _xieyiBtn = [UIButton getButtonWithFontSize:13 TextColorHex:[UIColor colorWithHex:0x999999] backGroundColor2:[UIColor clearColor] superView:self.mySuperView lytSet:^(UIButton *button) {
        [button lyt_placeBelowView:_placeView margin:11.f];
        [button lyt_alignLeftToParentWithMargin:15.f];
        [button lyt_setHeight:25.f];
        [button lyt_setWidth:120.f];
        [button setTitle:@"注册即同意" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"borrow_chose_no"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"borrow_chose"] forState:UIControlStateSelected];
        [button setContentHorizontalAlignment: UIControlContentHorizontalAlignmentLeft];
        [button setContentVerticalAlignment: UIControlContentVerticalAlignmentTop];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 0, 0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(4.5, 0, 0, 0)];
        [button addTarget:self action:@selector(xieyiBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.selected = YES;
    }];
    
    _xieyiLabel = [UILabel getLabelWithFontSize:13 textColor:[UIColor colorWithHex:0xFF5145] superView:self.mySuperView lytSet:^(UILabel *label) {
        [label lyt_centerYWithView:_xieyiBtn offset:1];
        [label  lyt_placeRightOfView:_xieyiBtn margin:-30.f];
        [label lyt_setHeight:30.f];
        label.text = _xieyiName_1;
    }];
    _xieyiLabel2 = [UILabel getLabelWithFontSize:13 textColor:[UIColor colorWithHex:0xFF5145] superView:self.mySuperView lytSet:^(UILabel *label) {
        [label lyt_centerYWithView:_xieyiBtn offset:1];
        [label lyt_placeRightOfView:_xieyiLabel margin:-10.0f];
        [label lyt_setHeight:30.f];
        label.text = _xieyiName_2;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xieyiTap)];
    _xieyiLabel.userInteractionEnabled = YES;
    [_xieyiLabel addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xieyiTap2)];
    _xieyiLabel2.userInteractionEnabled = YES;
    [_xieyiLabel2 addGestureRecognizer:tap2];
}

-(void)chageFrame{
    [self frameAdd:_xieyiBtn];
    [self frameAdd:_xieyiLabel];
    [self frameAdd:_xieyiLabel2];
}

-(void)frameAdd:(UIView*)tf{
    CGRect rect = tf.frame;
    rect.origin.y = rect.origin.y+40;
    tf.frame = rect;
}

#pragma mark - 协议按钮点击
- (void)xieyiBtnSelected:(UIButton *)btn
{
    btn.selected = !btn.selected;
    !self.checkBlock ? : self.checkBlock();
    
    if (self.xieyiBtnTapBlock) {
        self.xieyiBtnTapBlock();
    }
    if (self.xieyiBtn2TapBlock) {
        self.xieyiBtn2TapBlock();
    }
    
}

- (BOOL)checked{
    return _xieyiBtn ? _xieyiBtn.selected : NO;
}

#pragma mark - 协议点击
- (void)xieyiTap2
{
    if (_xieyiLabel2TapBlock) {
        _xieyiLabel2TapBlock();
    }
}
- (void)xieyiTap
{
    if (_xieyiLabelTapBlock) {
        _xieyiLabelTapBlock();
    }
}
@end
