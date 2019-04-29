//
//  Graduation.m
//  GraduationView
//
//  Created by Sword on 11/7/16.
//  Copyright © 2016 sword. All rights reserved.
//

#import "Graduation.h"

#define TITLES_HEIGHT 15
#define SUBPATH_NUM 4

@interface Graduation ()

@property (nonatomic, strong) GraduationTitles *graduationTitles;
@property (nonatomic, assign) kGraduationType graduationType;

@end

@implementation Graduation

+ (instancetype)GraduationWithGraduationType:(kGraduationType)graduationType {
    Graduation *result = [[[self class] alloc] init];
    
    result.graduationType = graduationType;
    
    return result;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _graduationType = kGraduationShowAll;
        _lineWidth = 1;
        _lineColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (kGraduationNoGraduation != self.graduationType) {
        self.graduationTitles.frame = CGRectMake(0, -TITLES_HEIGHT, CGRectGetWidth(self.bounds), TITLES_HEIGHT);
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGContextMoveToPoint(ctx, 0, CGRectGetHeight(rect) - self.lineWidth/2);
    CGContextAddLineToPoint(ctx, CGRectGetWidth(rect), CGRectGetHeight(rect) - self.lineWidth/2);
    
    if (kGraduationNoGraduation != self.graduationType) {
        for (NSInteger i = 0; i <= [self.valueManager stepNumber]; ++i) {
            
            if ([self needPathWithIndex:i]) {
                CGPathRef tmpPath = [self createPathWithIndex:i];
                CGContextAddPath(ctx, tmpPath);
                CGPathRelease(tmpPath);
            }
            //很多刻度
//            if ([self needSubPathWithIndex:i]) {
//                
//                for (NSInteger j = 1; j <= SUBPATH_NUM; ++j) {
//                    CGPathRef subPath = [self createSubPathWithIndex:i subIndex:j];
//                    CGContextAddPath(ctx, subPath);
//                    CGPathRelease(subPath);
//                }
//            }
        }
    }
    
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
}

- (BOOL)needPathWithIndex:(NSInteger)index {
    
    return 0 != index || (kGraduationNoLeftAndRightGraduation != self.graduationType);
}

- (BOOL)needSubPathWithIndex:(NSInteger)index {
    
    return [self.valueManager stepNumber] != index || (kGraduationNoLeftAndRightGraduation == self.graduationType);
}

#pragma mark - Private 


- (CGPathRef)createPathWithIndex:(NSInteger)index {
    
    CGMutablePathRef result = CGPathCreateMutable();
    CGPathMoveToPoint(result, NULL, index*self.valueManager.stepInterval + [self offsetWithIndex:index], 0);
    CGPathAddLineToPoint(result, NULL, index*self.valueManager.stepInterval + [self offsetWithIndex:index], CGRectGetMaxY(self.bounds));
    return result;
}

- (CGPathRef)createSubPathWithIndex:(NSInteger)index subIndex:(NSInteger)subIndex {
    
    CGMutablePathRef result = CGPathCreateMutable();
    CGPathMoveToPoint(result, NULL, index*self.valueManager.stepInterval + [self offsetWithIndex:index] + [self offsetWithSubIndex:subIndex], CGRectGetHeight(self.bounds)/3);
    CGPathAddLineToPoint(result, NULL, index*self.valueManager.stepInterval + [self offsetWithIndex:index] + [self offsetWithSubIndex:subIndex], CGRectGetMaxY(self.bounds));
    return result;
}

- (CGFloat)offsetWithIndex:(NSInteger)index {
    
    if (kGraduationNoLeftAndRightGraduation == self.graduationType) {
        return 0;
    }
    
    if (0 == index) {
        return self.lineWidth/2;
    }
    if (index == [self.valueManager stepNumber]) {
        return -self.lineWidth/2;
    }
    return 0;
}

- (CGFloat)offsetWithSubIndex:(NSInteger)subIndex {
    
    return subIndex*self.valueManager.stepInterval/(SUBPATH_NUM + 1);
}

#pragma mark - Setter
- (void)setFrame:(CGRect)frame {
    
    CGRect tmp = self.frame;
    [super setFrame:frame];

    if (!CGSizeEqualToSize(frame.size,tmp.size)) {
        [self setNeedsDisplay];
    }
}

- (void)setValueManager:(GraduationValueManager *)valueManager {
    _valueManager = [valueManager copy];
    
    if (kGraduationNoLeftAndRightGraduation == self.graduationType) {
        _valueManager.minValue = valueManager.maxValue;
        _valueManager.maxValue = valueManager.maxValue + valueManager.interval*ceil([UIScreen mainScreen].bounds.size.width/2/valueManager.stepInterval);
    }
    self.graduationTitles.valueManager = _valueManager;
}

- (void)setGraduationType:(kGraduationType)graduationType {
    _graduationType = graduationType;
    
    if (kGraduationNoGraduation != self.graduationType) {
        
        self.graduationTitles.titleColor = kGraduationNoLeftAndRightGraduation != self.graduationType ? [UIColor blackColor] : LIGHT_COLOR;
        self.graduationTitles.startIndex = kGraduationNoLeftAndRightGraduation == self.graduationType;
    }
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    [self setNeedsDisplay];
}

- (GraduationTitles *)graduationTitles {
    
    if (!_graduationTitles) {
        _graduationTitles = [[GraduationTitles alloc] init];
        _graduationTitles.backgroundColor = [UIColor clearColor];
        [self addSubview:_graduationTitles];
    }
    return _graduationTitles;
}

@end
