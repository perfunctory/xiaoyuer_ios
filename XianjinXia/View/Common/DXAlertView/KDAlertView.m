//
//  KDAlertView.m
//  KDLC
//
//  Created by haoran on 14/12/16.
//  Copyright (c) 2014年 KD. All rights reserved.
//

#import "KDAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Additions.h"
//#import "KDWindowManager.h"

#define kAlertWidth 257.5f
#define kAlertHeight 232.0f

@interface KDAlertView ()
{
    BOOL _leftLeave;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UILabel *latestVersion;
@property (nonatomic, retain) UILabel *sizeOfNewVersion;
@property (nonatomic, retain) UIButton *btn;
@property (nonatomic) CGFloat alertContentHeight;
@property (nonatomic, retain) NSString *ceshiString;
@property (nonatomic, strong) NSMutableArray * arrData;
@end

@implementation KDAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}

#define kTitleYOffset 40.0f
#define kTitleHeight 15.0f

#define kButtonHeight 32.0
#define kButtonWidth  230.5

#define kSingleButtonWidth 461.0/2

#define kCoupleButtonWidth 112.25
#define kCoupleButtonOffset 10
#define kButtonBottomOffset 11.5f

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]) {
        
        self.layer.cornerRadius = 4.0;
        self.backgroundColor = [UIColor whiteColor];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15,kAlertWidth - 40 , 17)];
        self.alertTitleLabel.textColor = [UIColor colorWithHex:0x333333];
        self.alertTitleLabel.font = [UIFont systemFontOfSize:17];
        self.alertTitleLabel.text = title;
        [self addSubview:self.alertTitleLabel];
        UIView *redLine = [[UIView alloc] initWithFrame:CGRectMake(20, _alertTitleLabel.frame.origin.y + 17 + 12, kAlertWidth - 40, 1)];
        redLine.backgroundColor = [UIColor colorWithHex:0xfd5353];
        [self addSubview: redLine];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, redLine.frame.origin.y + 1 + 9.5, kAlertWidth - 40, 108.5+13) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(20, _tableView.frame.origin.y + 108.5, 13, 13)];
        [_btn setBackgroundImage:[UIImage imageNamed:@"check_unpressed"] forState:UIControlStateNormal];
        [_btn setBackgroundImage:[UIImage imageNamed:@"check_pressed"] forState:UIControlStateSelected];
        [_btn setSelected:NO];
        [_btn addTarget:self action:@selector(touchChange) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:_btn];
        
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.alertContentHeight = [self heightWIthFontSize:13 maxWidth:(kAlertWidth - 40) withStr:content] + 10;
        self.alertContentLabel.numberOfLines = 0;
        _alertContentLabel.font = [UIFont systemFontOfSize:13];
        self.alertContentLabel.text = content;
//        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        self.alertContentLabel.attributedText = attrStr;
        
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;

        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kCoupleButtonOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
        }
        
        [self.rightBtn setBackgroundImage:[UIImage imageWithColor:Color_Red] forState:UIControlStateNormal];
        [self.leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x999999]] forState:UIControlStateNormal];
        
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];

    }
    return self;
}

- (CGFloat)heightWIthFontSize:(CGFloat)fontSize maxWidth:(CGFloat)width withStr:(NSString *)str
{
    return [self sizewithFontSize:fontSize maxWidth:width maxHeight:0 withStr:str].height;
}

- (CGSize)sizewithFontSize:(CGFloat)fontSize maxWidth:(CGFloat)width maxHeight:(CGFloat)height withStr:(NSString *)str
{
    return [self sizewithSystemFont:[UIFont systemFontOfSize:fontSize] maxWidth:width maxHeight:height withStr:str];
}

- (CGSize)sizewithSystemFont:(UIFont *)font maxWidth:(CGFloat)width maxHeight:(CGFloat)height withStr:(NSString *)str
{
    CGSize size = CGSizeMake(width, height);
    if (height == 0) {
        size = CGSizeMake(size.width, MAXFLOAT);
    }
    if (width == 0) {
        size = CGSizeMake(MAXFLOAT, size.height);
    }
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:6];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
//    NSDictionary * dictAttribute = @{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:Font_SubTitle};
    return [str boundingRectWithSize:size
                              options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                          attributes:@{NSFontAttributeName : Font_SubTitle}
                              context:nil].size;
}

- (void)touchChange
{
    [_btn setSelected:!_btn.selected];
    if (_btn.selected) {
        [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    } else {
        [_rightBtn setTitle:@"更新" forState:UIControlStateNormal];
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return self.alertContentHeight;
    } else {
        return 24;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"reuse";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if (indexPath.row == 0) {
            _sizeOfNewVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, 4.5, kAlertWidth - 40, 15)];
            _sizeOfNewVersion.textColor = [UIColor colorWithHex:0x333333];
            _sizeOfNewVersion.font = [UIFont systemFontOfSize:15];
            _sizeOfNewVersion.text = @"新版本特性:";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:_sizeOfNewVersion];
        }
        if (indexPath.row == 1) {
            _alertContentLabel.frame = CGRectMake(0, 4.5, kAlertWidth - 40, self.alertContentHeight);
            [cell.contentView addSubview:_alertContentLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    return cell;
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
  if (self.leftBlock) {
    [self dismissAlert];
  }
    if (self.rightBlock) {
        self.rightBlock();
    }
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight);
    [self exChangeOut:self dur:0.4f];
    [topVC.view addSubview:self];
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

- (void)dismissAlert
{
    [self removeFromSuperview];
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


- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    
    //    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    [UIView animateWithDuration:0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        if (_leftLeave) {
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        }else {
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
    } completion:^(BOOL finished) {
        //注释原因：DXAlertView弹框切后台会在这crash
        //        [super removeFromSuperview];
    }];
//    [self removeFromSuperview];
//    [[KDWindowManager shareWindowManager] endShowWithType:upgradePrompt];
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
    [topVC.view addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    //    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    [UIView animateWithDuration:0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}

@end
