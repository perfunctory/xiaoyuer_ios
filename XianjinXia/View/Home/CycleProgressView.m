//
//  CycleProgressView.m
//  XianjinXia
//
//  Created by sword on 2017/3/30.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "CycleProgressView.h"

#import "UICountingLabel.h"

#define Line_Width 10
#define Animation_Duration 0.5

@interface CycleProgressView ()

@property (strong, nonatomic) CAShapeLayer *trailLayer;
@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (strong, nonatomic) UICountingLabel *progressLabel;

@end

@implementation CycleProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self.layer addSublayer:self.trailLayer];
        [self.layer addSublayer:self.progressLayer];
        [self addSubview:self.progressLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.progressLabel.translatesAutoresizingMaskIntoConstraints) {
        
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
}
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    
    [self getCyclePath:self.trailLayer];
    [self getCyclePath:self.progressLayer];
}

- (void)getCyclePath:(CAShapeLayer *)shapeLayer {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, [self middlePointOfSelf].x, [self middlePointOfSelf].y, [self minimumRadiusOfSelf], -M_PI, M_PI, false);
    shapeLayer.path = path; CGPathRelease(path);
}

- (CGPoint)middlePointOfSelf {
    
    return CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
}
- (CGFloat)minimumRadiusOfSelf {
    CGFloat result = CGRectGetWidth(self.frame) <= CGRectGetHeight(self.frame) ? CGRectGetWidth(self.frame)/2 : CGRectGetHeight(self.frame)/2;
    result -= Line_Width/2;
    return result;
}

- (void)setProgress:(CGFloat)progress {
    
    if (_progress == progress) {
        return;
    }

    _progress = progress;
    
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnimation.fromValue = @(self.progressLayer.strokeEnd);
    baseAnimation.toValue = @(progress);
    baseAnimation.duration = Animation_Duration;
    baseAnimation.fillMode = kCAFillModeForwards;
    baseAnimation.removedOnCompletion = NO;
    [self.progressLayer addAnimation:baseAnimation forKey:nil];
    self.progressLayer.strokeEnd = progress;
    
    [self.progressLabel countFrom:self.progressLabel.text.integerValue to:(NSInteger)(100*progress) withDuration:Animation_Duration];
}

- (CAShapeLayer *)trailLayer {
    
    if (!_trailLayer) {
        _trailLayer = [CAShapeLayer layer];
        
        _trailLayer.strokeColor = [UIColor colorWithHex:0xEDEDED].CGColor;
        _trailLayer.fillColor = [UIColor clearColor].CGColor;
        _trailLayer.lineWidth = Line_Width;
    }
    return _trailLayer;
}
- (CAShapeLayer *)progressLayer {
    
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        
        _progressLayer.strokeColor = Color_Red.CGColor;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.lineWidth = Line_Width;
        _progressLayer.strokeEnd = 0;
    }
    return _progressLayer;
}
- (UICountingLabel *)progressLabel {
    
    if (!_progressLabel) {
        _progressLabel = [[UICountingLabel alloc] init];
        
        _progressLabel.format = @"%i%%";
        _progressLabel.font = FontSystem(20);
        _progressLabel.textColor = Color_Red;
    }
    return _progressLabel;
}

@end
