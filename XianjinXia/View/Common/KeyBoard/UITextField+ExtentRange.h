//
//  UITextField+ExtentRange.h
//  KDLC
//
//  Created by apple on 15/10/13.
//  Copyright (c) 2015年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange) range;

@end
