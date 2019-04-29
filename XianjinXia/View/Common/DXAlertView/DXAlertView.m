//
//  ILSMLAlertView.m
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import "DXAlertView.h"
#import <QuartzCore/QuartzCore.h>
//#import "UIImage+Additions.h"
#import "UIImage+UIColor.h"
#import "AppDelegate.h"
#import <Masonry.h>
#define kAlertWidth SCREEN_WIDTH/320*257.5f
#define kAlertHeight SCREEN_WIDTH/320*132.0f
#define kAlertHeightTime SCREEN_WIDTH/320*200.0f

@interface DXAlertView ()
{
    BOOL _leftLeave;
    BOOL timeShow;
    dispatch_source_t _timer;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeShowLabel;
@property (nonatomic,strong) UIView *timeView;

@end

@implementation DXAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define contentLabelHeight SCREEN_WIDTH/320 * 45.0f

#define kButtonHeight 40 //32.0/320*SCREEN_WIDTH
#define kButtonWidth  230.5/320*SCREEN_WIDTH

#define kSingleButtonWidth 461.0/2*SCREEN_WIDTH/320

#define kCoupleButtonWidth 112.25*SCREEN_WIDTH/320
#define kCoupleButtonOffset 10
#define kButtonBottomOffset 11.5f

//控制弹框 左右按钮颜色
- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
         buttonType:(ButtonType)buttonType
{
    self =  [self initWithTitle:title contentText:content leftButtonTitle:leftTitle rightButtonTitle:rigthTitle];
    if (self) {
        long leftColorHex = 0xFF5145;
        long rightColorHex = 0xFF5145;
        switch (buttonType) {
            case Normal:
                break;
            case LeftGray:
                leftColorHex = 0xcccccc;
                break;
            case RightGray:
                rightColorHex = 0xcccccc;
                break;
            default:
                break;
        }
        [self.rightBtn setBackgroundImage: ImageNamed(@"button_red_background")/*[UIImage imageWithColor:UIColorFromRGB(rightColorHex)]*/ forState:UIControlStateNormal];
        [self.leftBtn setBackgroundImage: ImageNamed(@"button_gray_background")/*[UIImage imageWithColor:UIColorFromRGB(leftColorHex)]*/ forState:UIControlStateNormal];
        
    }
    return self;
}

//完全自适应alertView
- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleYOffset, kAlertWidth, kTitleHeight)];
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        self.alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
        [self addSubview:self.alertTitleLabel];
        
        CGFloat contentLabelWidth = kAlertWidth - 16;
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame), contentLabelWidth, contentLabelHeight)];
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.alertContentLabel.textColor =UIColorFromRGB(0x333333);
        self.alertContentLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:self.alertContentLabel];
        //不显示标题 直接显示内容 居中
        if (! (title && ![title isEqualToString:@""])) {
            [self.alertTitleLabel removeFromSuperview];
            
            self.alertContentLabel.frame = CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, kTitleYOffset, contentLabelWidth, kTitleHeight + contentLabelHeight);
        }
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }
        
        [self.rightBtn setBackgroundImage: ImageNamed(@"button_red_background")/*[UIImage imageWithColor:UIColorFromRGB(rightColorHex)]*/ forState:UIControlStateNormal];
        [self.leftBtn setBackgroundImage: ImageNamed(@"button_gray_background")/*[UIImage imageWithColor:UIColorFromRGB(leftColorHex)]*/ forState:UIControlStateNormal];
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.leftBtn setTitleColor:[UIColor colorWithHex:0xA6A5A5] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
//        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        
    }
    
    return self;
}
- (id)initTitleTime:(NSString *)time{
    
    self = [super init];
    if (self) {
        timeShow = YES;
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor whiteColor];
        
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = Color_Red;
        _headerView.frame = CGRectMake(0, 0, kAlertWidth, kAlertHeightTime/4);
        [self addSubview:_headerView];
        
        UIImageView *tapImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"prompt"]];
        tapImg.backgroundColor = [UIColor whiteColor];
        tapImg.layer.cornerRadius = 10.0f;
//        tapImg.frame = CGRectMake(kAlertWidth/6, kAlertHeightTime/4/2-10, 20, 20);
        [_headerView addSubview:tapImg];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_headerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        maskLayer.frame = _headerView.bounds;
        
        maskLayer.path = maskPath.CGPath;
        
        _headerView.layer.mask = maskLayer;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = [NSString stringWithFormat:@"操作频繁,请%@s后重试",time];
        _titleLabel.textColor = [UIColor whiteColor];
        
        _titleLabel.font = [UIFont systemFontOfSize:17];
//        _titleLabel.frame = CGRectMake(kAlertWidth/6+30, kAlertHeightTime/4/2-10, kAlertWidth-80, 20);
        
        [_headerView addSubview:_titleLabel];
        
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn setImage:[UIImage imageNamed:@"closed"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:backBtn];
        _timeView = [[UIView alloc] initWithFrame:CGRectMake(kAlertWidth/2-48, kAlertHeightTime/2-20, 110, 110)];
        _timeView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_timeView];
        
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.text = @"倒计时";
        descLabel.font = [UIFont systemFontOfSize:18];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.textColor = [UIColor blackColor];
        [_timeView addSubview:descLabel];
        
        _timeShowLabel = [[UILabel alloc] init];
        _timeShowLabel.textColor = [UIColor blackColor];
        _timeShowLabel.text = time;
        _timeShowLabel.font = [UIFont boldSystemFontOfSize:40];
        [_timeView addSubview:_timeShowLabel];
        
        UIImageView *timeImgView = [[UIImageView alloc] init];
        timeImgView.image = [UIImage imageNamed:@"count_down_background"];
        [_timeView addSubview:timeImgView];
        
        UILabel *secLabel = [[UILabel alloc] init];
        secLabel.text = @"s";
        secLabel.font = [UIFont systemFontOfSize:20];
        secLabel.textColor = [UIColor blackColor];
        
        [_timeView addSubview:secLabel];
        
        
        [tapImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView.mas_centerY);
            make.left.equalTo(_headerView.mas_left).offset(kAlertWidth/6);
            if(iPhone5 || iPhone4){
                make.left.equalTo(_headerView.mas_left).offset(kAlertWidth/6-30);
            }
            make.width.height.mas_offset(20);
            
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(tapImg);
            make.left.equalTo(tapImg.mas_right).offset(10);
        }];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_timeView);
            make.top.equalTo(_timeView.mas_top).offset(20);
        }];
        
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_top).offset(7);
            make.right.equalTo(_headerView.mas_right).offset(-7);
            make.width.height.mas_equalTo(25);
        }];
        
        [_timeShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_timeView);
            make.top.equalTo(descLabel.mas_bottom);
        }];
        
        [secLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeShowLabel.mas_right).offset(2);
            make.bottom.equalTo(_timeShowLabel.mas_bottom).offset(-4);
            
        }];
        
        [timeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(_timeView);
        }];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletapPressGesture:)];
//        self.userInteractionEnabled = YES;
//        [self addGestureRecognizer:tapGesture];
        
        [self countDown:time];
        
    }
    return self;
}


- (void)countDown:(NSString *)time{
    
    __block int timeout = [time intValue]; //倒计时时间
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_headerView removeFromSuperview];
                [_timeShowLabel removeFromSuperview];
                [weakSelf dismissAlert];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime;
            
            strTime =[NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                _timeShowLabel.text = strTime;
                _titleLabel.text = [NSString stringWithFormat:@"操作频繁,请%@s后重试",strTime];
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock();
    }
}
- (void)show
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIViewController *topVC = [self appRootViewController];
    
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight);
    if (timeShow) {
        self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeightTime - 30, kAlertWidth, kAlertHeightTime);
    }
    
    [self exChangeOut:self dur:0.4f];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperviews];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

-(void)backBtn{
    dispatch_source_cancel(_timer);
    [_headerView removeFromSuperview];
    [_timeView removeFromSuperview];
    [self dismissAlert];
}


//-(void)handletapPressGesture:(UITapGestureRecognizer*)sender{
//    dispatch_source_cancel(_timer);
//    [_headerView removeFromSuperview];
//    [_timeView removeFromSuperview];
//    [self dismissAlert];
//}


- (void)removeFromSuperviews
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    
    [UIView animateWithDuration:0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        if (_leftLeave) {
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        }else {
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
    } completion:^(BOOL finished) {
        //注释原因：DXAlertView弹框切后台会在这crash
        [self removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    if (timeShow) {
        afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeightTime) * 0.5, kAlertWidth, kAlertHeightTime);
    }
    [UIView animateWithDuration:0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
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


@end

