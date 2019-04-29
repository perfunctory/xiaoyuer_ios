//
//  GraduationView.m
//  GraduationView
//
//  Created by Sword on 11/7/16.
//  Copyright © 2016 sword. All rights reserved.
//

#import "GraduationView.h"

#import "FlagView.h"
#import "Graduation.h"
//#import "GraduationTitles.h"

#define GRADUATION_HEIGHT 9

@interface GraduationView () <UIScrollViewDelegate>

//@property (nonatomic, strong) FlagView *flagView;
@property (nonatomic, strong) UIScrollView *graduationScroll;
@property (nonatomic, strong) GraduationValueManager *valueManager;

@property (nonatomic, strong) Graduation *leftLine;
@property (nonatomic, strong) Graduation *valueGraduation;
@property (nonatomic, strong) Graduation *rightGraduation;

@property (nonatomic, assign) BOOL sd_updateInterface;

@end

@implementation GraduationView
@synthesize minValue = _minValue, maxValue = _maxValue, interval = _interval, stepInterval = _stepInterval;

#pragma mark - Life Cycle

+ (instancetype)graduationViewWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue interval:(NSInteger)interval {
    
    return [[[self class] alloc]init];
}

- (void)show:(NSInteger)minValue maxValue:(NSInteger)maxValue interval:(NSInteger)interval{
//    self = [super init];
//    
//    if (self) {
        _valueManager = [GraduationValueManager graduationValueManagerWithMinValue:minValue maxValue:maxValue interval:interval stepInterval:70];
        [self setNeedUpdateInterface];
//    }
//    
//    return self;
}

-(instancetype)init{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(click) name:@"GraduationView" object:nil];
    }
    
    return self;
}
-(void)click{
    [self.graduationScroll setContentOffset:CGPointMake([self.valueManager roundScrollX:self.graduationScroll.contentOffset.x + self.graduationScroll.contentInset.left] - self.graduationScroll.contentInset.left, 0) animated:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:@"GraduationView"];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initializeGraduationScroll];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializeGraduationScroll];
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    
    [self initializeGraduationScroll];
}

- (void)initializeGraduationScroll {
    
    [self.graduationScroll addSubview:self.leftLine];
    [self.graduationScroll addSubview:self.valueGraduation];
    [self.graduationScroll addSubview:self.rightGraduation];
   // self.flagView.flagValue = [NSString stringWithFormat:@"%li", (long)self.valueManager.maxValue];
    [self addSubview:self.graduationScroll];
   // [self addSubview:self.flagView];
    [self setNeedUpdateInterface];
}

- (void)updateConstraints {
    [super updateConstraints];
    
//    if (self.flagView.translatesAutoresizingMaskIntoConstraints) {
//        self.flagView.translatesAutoresizingMaskIntoConstraints = NO;
//        NSLayoutConstraint *hCon = [NSLayoutConstraint constraintWithItem:self.flagView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
////        NSArray *vCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_flagView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_flagView)];
//        
//        [self addConstraint:hCon];
////        [self addConstraints:vCon];
//    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (![self.valueManager valueIsValid]) {
        return;
    }
    
    if (self.sd_updateInterface || !CGRectEqualToRect(self.graduationScroll.frame, self.bounds)) {
        self.sd_updateInterface = NO;
        self.graduationScroll.frame = self.bounds;
        self.graduationScroll.contentInset = UIEdgeInsetsMake(0, self.bounds.size.width/2, 0, 0);
        
        self.leftLine.frame = CGRectMake(-self.bounds.size.width/2, [self graduationY], self.bounds.size.width/2, GRADUATION_HEIGHT);
        
        self.valueGraduation.frame = CGRectMake(0, [self graduationY], [self.valueManager needViewWidth], GRADUATION_HEIGHT);
        
        self.rightGraduation.frame = CGRectMake(CGRectGetMaxX(self.valueGraduation.frame), [self graduationY], self.bounds.size.width/2, GRADUATION_HEIGHT);

        self.graduationScroll.contentSize = CGSizeMake(CGRectGetMaxX(self.rightGraduation.frame), CGRectGetHeight(self.bounds));
        
        self.graduationScroll.contentOffset = CGPointMake(CGRectGetMaxX(self.valueGraduation.frame) - self.graduationScroll.contentInset.left, 0);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSString *tmp = [NSString stringWithFormat:@"%li",(long)[self.valueManager valueOfGraduationWithScrollX:(scrollView.contentOffset.x + scrollView.contentInset.left)]];
    if (tmp&&self.valueDidChange) {// && ![tmp isEqualToString:self.flagView.flagValue]
//        self.flagView.flagValue = tmp;
        self.valueDidChange(tmp);
//        !self.valueDidChange ? : self.valueDidChange(tmp);
    }

}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//
////    CGPoint point = CGPointMake([self.valueManager roundScrollX:scrollView.contentOffset.x + scrollView.contentInset.left] - scrollView.contentInset.left, 0);
////    *targetContentOffset = point;
////    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
////    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
////        *targetContentOffset = CGPointMake([self.valueManager roundScrollX:scrollView.contentOffset.x + scrollView.contentInset.left] - scrollView.contentInset.left, 0);
////    });
//
//}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
                [self.graduationScroll setContentOffset:CGPointMake([self.valueManager roundScrollX:scrollView.contentOffset.x + scrollView.contentInset.left] - scrollView.contentInset.left, 0) animated:YES];
        //这里复制scrollViewDidEndDecelerating里的代码
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.graduationScroll setContentOffset:CGPointMake([self.valueManager roundScrollX:scrollView.contentOffset.x + scrollView.contentInset.left] - scrollView.contentInset.left, 0) animated:YES];
//    });
}

#pragma mark - Private
- (CGFloat)graduationY {
    return CGRectGetHeight(self.bounds) - GRADUATION_HEIGHT;
}

#pragma mark - Setter
- (void)setMinValue:(NSInteger)minValue {
    if ((minValue < 0) || (minValue == self.valueManager.minValue)) {
        return;
    }
    self.valueManager.minValue = minValue;
    [self setNeedUpdateInterface];
}

- (void)setMaxValue:(NSInteger)maxValue {
    if (maxValue < 0 || (maxValue == self.valueManager.maxValue)) {
        return;
    }
    self.valueManager.maxValue = maxValue;
    [self setNeedUpdateInterface];
}

- (void)setInterval:(NSInteger)interval {
    if (interval < 0 || (interval == self.valueManager.interval)) {
        return;
    }
    self.valueManager.interval = interval;
    [self setNeedUpdateInterface];
}

- (void)setStepInterval:(NSInteger)stepInterval {
    if (stepInterval < 0 || (stepInterval == self.valueManager.stepInterval)) {
        return;
    }
    self.valueManager.stepInterval = stepInterval;
    [self setNeedUpdateInterface];
}

- (void)setNeedUpdateInterface {
    self.sd_updateInterface = YES;
    
    self.valueGraduation.valueManager = self.valueManager;
    self.rightGraduation.valueManager = self.valueManager;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


#pragma mark - Getter
//- (NSString *)currentValue {
//    return self.flagView.flagValue;
//}

//- (FlagView *)flagView {
//    
//    if (!_flagView) {
//        _flagView = [[FlagView alloc] init];
//    }
//    return _flagView;
//}

- (GraduationValueManager *)valueManager {
    
    if (!_valueManager) {
        _valueManager = [[GraduationValueManager alloc] init];
    }
    return _valueManager;
}

- (UIScrollView *)graduationScroll {
    
    if (!_graduationScroll) {
        _graduationScroll = [[UIScrollView alloc] init];
        _graduationScroll.showsVerticalScrollIndicator = NO;
        _graduationScroll.showsHorizontalScrollIndicator = NO;
        _graduationScroll.bounces = NO;
        _graduationScroll.delegate = self;
    }
    return _graduationScroll;
}

- (Graduation *)leftLine {
    
    if (!_leftLine) {
        _leftLine = [Graduation GraduationWithGraduationType:kGraduationNoGraduation];
        _leftLine.lineColor = LIGHT_COLOR;
    }
    return _leftLine;
}

- (Graduation *)valueGraduation {
    
    if (!_valueGraduation) {
        _valueGraduation = [Graduation GraduationWithGraduationType:kGraduationShowAll];
        _valueGraduation.lineColor = LIGHT_COLOR;
    }
    return _valueGraduation;
}

- (Graduation *)rightGraduation {
    
    if (!_rightGraduation) {
        _rightGraduation = [Graduation GraduationWithGraduationType:kGraduationNoLeftAndRightGraduation];
        _rightGraduation.lineColor = LIGHT_COLOR;
        _rightGraduation.backgroundColor = SDF_RGB(0xEEEEEE);
    }
    return _rightGraduation;
}

- (NSInteger)minValue {
    return self.valueManager.minValue;
}

- (NSInteger)maxValue {
    return self.valueManager.maxValue;
}

- (NSInteger)interval {
    return self.valueManager.interval;
}

- (NSInteger)stepInterval {
    return self.valueManager.stepInterval;
}
@end
