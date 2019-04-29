//
//  GraduationView.h
//  GraduationView
//
//  Created by Sword on 11/7/16.
//  Copyright © 2016 sword. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraduationMacro.h"

IB_DESIGNABLE @interface GraduationView : UIView

+ (instancetype)graduationViewWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue interval:(NSInteger)interval;

- (void)show:(NSInteger)minValue maxValue:(NSInteger)maxValue interval:(NSInteger)interval;

-(instancetype)init;

//Value
@property (nonatomic, assign) IBInspectable NSInteger minValue;
@property (nonatomic, assign) IBInspectable NSInteger maxValue;
@property (nonatomic, assign) IBInspectable NSInteger interval;
@property (nonatomic, assign) IBInspectable NSInteger stepInterval; /**< defaule is 50 */

@property (nonatomic, strong, readonly) NSString *currentValue;
@property (nonatomic, copy) void (^valueDidChange)(NSString *currentValue);
@end
