//
//  GraduationValueManager.m
//  GraduationView
//
//  Created by Sword on 11/7/16.
//  Copyright © 2016 sword. All rights reserved.
//

#import "GraduationValueManager.h"

@implementation GraduationValueManager

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _minValue = 200;
        _maxValue = 1000;
        _interval = 100;
        _stepInterval = 50;
    }
    return self;
}

+ (instancetype)graduationValueManagerWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue interval:(NSInteger)interval stepInterval:(NSInteger)stepInterval {
    
    return [[[self class] alloc] initWithMinValue:minValue maxValue:maxValue interval:interval stepInterval:stepInterval];
}

- (instancetype)initWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue interval:(NSInteger)interval stepInterval:(NSInteger)stepInterval {
    if (self = [super init]) {
        _minValue = minValue;
        _maxValue = maxValue;
        _interval = interval;//间距100
        _stepInterval = stepInterval;//50
    }
    return self;
}

#pragma mark - Public

- (BOOL)valueIsValid {
    //return self.interval > 0 && self.minValue > 0 && self.maxValue > 0 && self.maxValue - self.minValue >= self.interval;
    
    return self.interval > 0 && self.minValue > 0 && self.maxValue > 0;
}

- (NSInteger)stepNumber {
    return (self.maxValue - self.minValue)/self.interval;
}

- (CGFloat)needViewWidth {
    return self.stepInterval*[self stepNumber];
}

- (NSString *)stringWithStep:(NSInteger)step {
    return [NSString stringWithFormat:@"%li", (long)(self.minValue + step*self.interval)];
}

- (CGFloat)centerXWithStep:(NSInteger)step {
    return step*self.stepInterval;
}

- (CGFloat)valueOfGraduationWithScrollX:(CGFloat)scrollX {
    return round(scrollX/self.stepInterval)*self.interval + self.minValue;
}

- (CGFloat)roundScrollX:(CGFloat)scrollX {
    return round(scrollX/self.stepInterval)*self.stepInterval;
}

#pragma mark - NSCoping
- (id)copyWithZone:(NSZone *)zone {
    GraduationValueManager *result = [[self class] allocWithZone:zone];
    
    result.minValue = self.minValue;
    result.maxValue = self.maxValue;
    result.interval = self.interval;
    result.stepInterval = self.stepInterval;
    
    return result;
}

@end
