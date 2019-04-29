//
//  Graduation.h
//  GraduationView
//
//  Created by Sword on 11/7/16.
//  Copyright © 2016 sword. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraduationTitles.h"
#import "GraduationMacro.h"

typedef NS_ENUM(NSInteger, kGraduationType) {
    kGraduationNoGraduation,
    kGraduationNoLeftAndRightGraduation,
    kGraduationShowAll
};

@interface Graduation : UIView

+ (instancetype)GraduationWithGraduationType:(kGraduationType)graduation;

@property (nonatomic, copy) GraduationValueManager *valueManager;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

@end
