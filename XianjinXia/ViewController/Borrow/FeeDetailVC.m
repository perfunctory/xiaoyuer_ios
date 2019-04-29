//
//  FeeDetailVC.m
//  XianjinXia
//
//  Created by sword on 2017/3/2.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "FeeDetailVC.h"

@class FeeDetailVC;

@implementation FeeDetailPresentationAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.4f;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    FeeDetailVC *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.frame = transitionContext.containerView.bounds;
    
    [transitionContext.containerView addSubview:toVC.view];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = [self transitionDuration:transitionContext];
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.08, 1.08, 1.0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [animation setValue:transitionContext forKey:@"transitionContext"];
    [toVC.contentView.layer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    
    [transitionContext completeTransition:YES];
}

//UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return [presented isMemberOfClass:[FeeDetailVC class]] ? self : nil;
}

@end

@interface FeeItemView : UIView

- (instancetype)initWithTitle:(NSString *)title money:(NSString *)money;

- (void)setTitle:(NSString *)title money:(NSString *)money;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *moneyLabel;

@end

@implementation FeeItemView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.moneyLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title money:(NSString *)money {
    
    if (self = [super init]) {
        
        [self setTitle:title money:money];
    }
    return self;
}
- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.titleLabel.translatesAutoresizingMaskIntoConstraints) {
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top).with.offset(5);
            make.bottom.equalTo(self.mas_bottom).with.offset(-5).priorityMedium();
        }];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
}

- (void)setTitle:(NSString *)title money:(NSString *)money {
    
    self.titleLabel.text = title;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元", money];
}


- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.font = FontSystem(17);
        _titleLabel.textColor = [UIColor colorWithHex:0x545456];
    }
    return _titleLabel;
}
- (UILabel *)moneyLabel {
    
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        
        _moneyLabel.font = [UIFont italicSystemFontOfSize:17];
        _moneyLabel.textColor = [UIColor colorWithHex:0x545456];
    }
    return _moneyLabel;
}

@end


@interface FeeDetailVC ()

@property (strong, nonatomic) UILabel *feeLabel;
@property (strong, nonatomic) UIButton *dismissButton;

@property (strong, nonatomic) NSArray *feeList;
@property (strong, nonatomic) NSArray<FeeItemView *> *feeListViews;

@end

@implementation FeeDetailVC

- (instancetype)initWithFeeList:(NSArray *)feeList {
    
    if (self = [super init]) {
        _feeList = feeList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.feeLabel];
    [self.contentView addSubview:self.dismissButton];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < self.feeList.count; ++i) {
        
        FeeItemView *view = [[FeeItemView alloc] initWithTitle:self.feeList[i][@"name"] money:self.feeList[i][@"value"]];
        [self.contentView addSubview:view];
        [array addObject:view];
    }
    self.feeListViews = array;
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.contentView.translatesAutoresizingMaskIntoConstraints) {
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(30*ScreenRateFor6);
            make.centerY.equalTo(self.view.mas_centerY);
            make.right.equalTo(self.view.mas_right).with.offset(-30*ScreenRateFor6);
        }];
        [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@50);
        }];
        [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(40);
            make.top.equalTo(self.feeListViews.lastObject.mas_bottom).with.offset(30);
            make.right.equalTo(self.contentView.mas_right).with.offset(-40);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-20).priorityMedium();
            make.height.equalTo(@40);
        }];
        
        for (NSInteger i = 0; i < self.feeListViews.count; ++i) {
            UIView *view = self.feeListViews[i];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).with.offset(30);
                make.right.equalTo(self.contentView.mas_right).with.offset(-30);
                if (0 == i) {
                    make.top.equalTo(self.feeLabel.mas_bottom).with.offset(30);
                } else {
                    make.top.equalTo(self.feeListViews[i - 1].mas_bottom);
                }
            }];
        }
    }
}

- (void)dismiss {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Getter
- (UIView *)contentView {
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        
        _contentView.layer.cornerRadius = 5;
        _contentView.clipsToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UILabel *)feeLabel {
    
    if (!_feeLabel) {
        _feeLabel = [[UILabel alloc] init];
        
        _feeLabel.font = FontSystem(24);
        _feeLabel.textAlignment = NSTextAlignmentCenter;
        _feeLabel.text = @"费用详细";
        _feeLabel.textColor = [UIColor whiteColor];
        _feeLabel.backgroundColor = Color_Red;
    }
    return _feeLabel;
}
- (UIButton *)dismissButton {
    
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc] init];
        
        _dismissButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_dismissButton setBackgroundColor:UIColorFromRGB(0xff8d3c)];
        [_dismissButton setBackgroundImage:[UIImage imageNamed:@"button_red_background"] forState:UIControlStateNormal];
        [_dismissButton setTitle:@"我知道了" forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

@end
