//
//  KDShareFloatWindow.m
//  KDLC
//
//  Created by haoran on 15/10/26.
//  Copyright © 2015年 llyt. All rights reserved.
//

#import "KDShareFloatWindow.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+Frame.h"
#define xScale (SCREEN_WIDTH/375)
#define yScale (SCREEN_HEIGHT/667)
static UIWindow        *_sharedToastWindow = nil;
@interface KDShareFloatWindow ()
@property (nonatomic, retain) UIView *floatWin;//悬浮窗
@property (nonatomic, retain) UILabel *titleLabel;//文字

@property (nonatomic, retain) NSString *title;
@end
@implementation KDShareFloatWindow

+ (UIWindow*)sharedToastWindow{
    if (_sharedToastWindow == nil){
        
        _sharedToastWindow = [[UIWindow alloc] init];
        _sharedToastWindow.userInteractionEnabled = NO;
        _sharedToastWindow.windowLevel = UIWindowLevelAlert+100;
    }
    return _sharedToastWindow;
}

+ (KDShareFloatWindow *)makeText:(NSString *)str
{
    return [KDShareFloatWindow checkTitle:str];
}

+ (KDShareFloatWindow *)checkTitle:(NSString *)title
{
    if (!title||[title isEqualToString:@""]) {
        return nil;
    }
    KDShareFloatWindow *window = [[KDShareFloatWindow alloc]initWithText:title];
    return window;
}
- (instancetype)initWithText:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
        [self setUI];
    }
    return self;
}
- (void)setUI
{
    self.frame =  CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor colorWithHex:0x333333 alpha:0.4];

    _floatWin = [[UIView alloc]initWithFrame:CGRectZero];
    _floatWin.backgroundColor = [UIColor whiteColor];
    _floatWin.layer.cornerRadius = 5.0f;
    [self addSubview:_floatWin];
    
    
    CGFloat height = [_title heightWIthFontSize:15 maxWidth:xScale*100];
    CGFloat wid = [_title sizewithFontSize:15 maxWidth:MAXFLOAT maxHeight:80].width;
//    CGFloat wid = [GToolUtil labelWidthWithString:_title font:[UIFont  systemFontOfSize:15]];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, xScale*100, height)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = _title;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor colorWithHex:0x333333];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [_floatWin addSubview:_titleLabel];
    
    CGFloat newWid = 0;
    CGFloat newHeight = 0;
    if (wid/(xScale*100)>=3) {
        newWid = ((height+50)*yScale)*260/164;
        newHeight = yScale*(height+50);
    }else
    {
        newHeight = 82*xScale;
        newWid =(82*xScale)*260/164;
    }
    _floatWin.frame = CGRectMake((SCREEN_WIDTH-newWid)/2, 214*yScale, newWid, newHeight);
    _titleLabel.center = CGPointMake(CGRectGetWidth(_floatWin.frame)/2, CGRectGetHeight(_floatWin.frame)/2);
    NSTimer *timer1 = [NSTimer timerWithTimeInterval:2.0f
                                              target:self selector:@selector(hide:)
                                            userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    
}
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];

}
- (void)hide:(NSTimer *)timer
{
    [UIView animateWithDuration:1.5f animations:^{
        self.alpha = 0;
        [self removeFromSuperview];
    }];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

}
@end
