//
//  GraduationTitle.m
//  GraduationView
//
//  Created by Sword on 11/7/16.
//  Copyright © 2016 sword. All rights reserved.
//

#import "GraduationTitles.h"

@interface GraduationTitles ()

@property (nonatomic, strong) NSMutableArray<UILabel *> *titles;

@end

@implementation GraduationTitles

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UILabel *label in self.titles) {
        label.center = CGPointMake([self.valueManager centerXWithStep:label.tag], 0);
    }
}

- (void)resetTitles {
    
    [self.titles enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.titles removeAllObjects];
    
    for (NSInteger i = self.startIndex; i <= [self.valueManager stepNumber]; ++i) {
        UILabel *label = [self createLabelWithTag:i];
        label.text = [self.valueManager stringWithStep:i];
        [label sizeToFit];
        [self.titles addObject:label];
        [self addSubview:label];
    }
}

- (void)setValueManager:(GraduationValueManager *)valueManager {
    _valueManager = valueManager;
    
    [self resetTitles];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    
    [self.titles enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColor = titleColor;
    }];
}

- (UILabel *)createLabelWithTag:(NSInteger)tag {
    UILabel *result = [[UILabel alloc] init];
    
    result.tag = tag;
    result.font = [UIFont systemFontOfSize:12.f];
    result.textColor = self.titleColor;
    result.textAlignment = NSTextAlignmentCenter;
    
    return result;
}

- (NSMutableArray *)titles {
    
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

@end
