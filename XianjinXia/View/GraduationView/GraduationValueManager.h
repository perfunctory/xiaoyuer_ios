//
//  GraduationValueManager.h
//  GraduationView
//
//  Created by Sword on 11/7/16.
//  Copyright © 2016 sword. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GraduationMacro.h"

@interface GraduationValueManager : NSObject <NSCopying>

+ (instancetype)graduationValueManagerWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue interval:(NSInteger)interval stepInterval:(NSInteger)stepInterval;

- (instancetype)initWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue interval:(NSInteger)interval stepInterval:(NSInteger)stepInterval;

//Value
@property (nonatomic, assign) NSInteger minValue;     /**< default is 200 */
@property (nonatomic, assign) NSInteger maxValue;     /**< default is 1000 */
@property (nonatomic, assign) NSInteger interval;     /**< default is 100 */
@property (nonatomic, assign) NSInteger stepInterval; /**< default is 50 */

- (BOOL)valueIsValid;

- (NSInteger)stepNumber;

- (CGFloat)needViewWidth;

- (NSString *)stringWithStep:(NSInteger)step;

- (CGFloat)centerXWithStep:(NSInteger)step;

- (CGFloat)valueOfGraduationWithScrollX:(CGFloat)scrollX;

- (CGFloat)roundScrollX:(CGFloat)scrollX;

@end
