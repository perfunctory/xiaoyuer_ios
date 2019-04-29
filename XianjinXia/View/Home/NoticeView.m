//
//  NoticeView.m
//  KDFDApp
//
//  Created by Innext on 2016/12/30.
//  Copyright © 2016年 cailiang. All rights reserved.
//

#define kImvW   290*WIDTHRADIUS
#define kImvH   362.5*WIDTHRADIUS

#import "NoticeView.h"
#import <UIImageView+WebCache.h>
#import <UMMobClick/MobClick.h>

@implementation NoticeView
{
    UIView          * _bgView;
    UIView          * _whiteView;
    UIImageView     * _imv;
    UIButton        * _RegisterBtn;
    UIButton        * _cancelBtn;
    
    NSArray         * _areaPic;
    AlertType         _alertType;
}

- (instancetype)init {
    if ( self = [super init]) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.alpha = 0.4;
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
}

- (void)initBgWith:(NSString *)urlPic withType:(AlertType)type{
    _alertType = type;
    _imv = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-kImvW)/2, (SCREEN_HEIGHT-kImvH)/2 - 30*WIDTHRADIUS, kImvW, kImvH)];
    [_imv sd_setImageWithURL:[NSURL URLWithString:urlPic] placeholderImage:[UIImage imageNamed:@""]];
    _imv.userInteractionEnabled = YES;
    [self addSubview:_imv];
    
    _RegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _RegisterBtn.frame = type == updateAlert ? CGRectMake(20, kImvH - 60, kImvW - 40, 50) : CGRectMake(0, 0, kImvW, kImvH);
    [_RegisterBtn addTarget:self action:@selector(Register) forControlEvents:UIControlEventTouchUpInside];
    [_imv addSubview:_RegisterBtn];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(SCREEN_WIDTH / 2 - 10, CGRectGetMaxY(_imv.frame) + 15*WIDTHRADIUS, 20, 20);
    [_cancelBtn setImage:[UIImage imageNamed:@"close"] forState:normal];
    [_cancelBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
}

- (void)Register {
    if (self.nBlock) {
        if (_alertType == adsAlert) {
            [self umengEvent:UmengEvent_Home_ad];
        }
        [self dismiss];
        self.nBlock();
    }
}

- (void)closeClick {
    if (_alertType == adsAlert) {
        [self umengEvent:UmengEvent_Home_ad_cancel];
    }
    [self dismiss];
}

-(void)umengEvent:(NSString *)eventId{
    [MobClick event:eventId];
}

- (void)showWithPic:(NSString *)urlPic withType:(AlertType)type{
    UIWindow * win = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [win addSubview:self];
    self.frame = win.frame;
    self.center = CGPointMake(win.center.x, win.center.y * 2);
    [self initBgWith:urlPic withType:type];
    
//    [UIView beginAnimations:@"animan" context:nil];
//    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:win cache:YES];
//    [UIView animateWithDuration:10 animations:^{
        self.frame = win.frame;
        _bgView.hidden = NO;
//    }];
//    [UIView commitAnimations];
}

- (void)dismiss {
    _cancelBtn.hidden = YES;
    _RegisterBtn.hidden = YES;
    UIWindow * win = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [UIView beginAnimations:@"animaim1" context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:win cache:YES];
    [UIView animateWithDuration:2 animations:^{
        _imv.frame = CGRectMake(SCREEN_WIDTH-15*WIDTHRADIUS-11, 30*WIDTHRADIUS+11, 0, 0);
        _bgView.hidden = YES;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [UIView commitAnimations];
}

@end
