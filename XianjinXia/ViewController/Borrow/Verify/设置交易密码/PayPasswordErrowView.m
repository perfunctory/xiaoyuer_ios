//
//  KDPayPasswordErrowView.m
//  KDIOSApp
//
//  Created by haoran on 16/5/23.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "PayPasswordErrowView.h"

@interface PayPasswordErrowView ()
@property (nonatomic, retain) UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic, retain) NSString *leftStr;
@property (nonatomic, retain) NSString *rightStr;
@end
@implementation PayPasswordErrowView
- (instancetype)initWithTitle:(NSString *)title LeftBtnTitle:(NSString *)left RightBtnTitle:(NSString *)right
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"PayPasswordErrowView" owner:nil options:nil]lastObject];
        self.frame = CGRectMake(45*WIDTHRADIUS, (SCREEN_HEIGHT-120)/2, SCREEN_WIDTH-90*WIDTHRADIUS, 120);
        self.layer.cornerRadius = 5.0f;
        self.descLabel.text = title;
        self.leftStr = left;
        self.rightStr = right;
        [self.rightBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    }
    return self;
}
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.6;
        _backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmiss)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.line1Height.constant = self.line2Wid.constant = .5f;
    
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    [self exChangeOut:self dur:0.35];
    [self.leftBtn setTitle:self.leftStr forState:UIControlStateNormal];
    [self.rightBtn setTitle:self.rightStr forState:UIControlStateNormal];
}

-(void)exChangeOut:(UIView *)changeOutView dur:(CFTimeInterval)dur{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = dur;
    
    //animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.08, 1.08, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [changeOutView.layer addAnimation:animation forKey:nil];
    
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)dissmiss
{
    [self.backView removeFromSuperview];
    [self removeFromSuperview];
}
#pragma mark - 左边按钮
- (IBAction)leftTapped:(id)sender {
    if (self.leftBlock) {
        self.leftBlock();
    }
    [self dissmiss];
}
#pragma mark - 右边按钮点击事件
- (IBAction)rightTapped:(id)sender {
    if (self.rightBlock) {
        self.rightBlock();
    }
    [self dissmiss];
}

@end
