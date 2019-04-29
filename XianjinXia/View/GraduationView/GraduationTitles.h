//
//  GraduationTitle.h
//  GraduationView
//
//  Created by Sword on 11/7/16.
//  Copyright © 2016 sword. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraduationValueManager.h"
#import "GraduationMacro.h"

@interface GraduationTitles : UIView

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) GraduationValueManager *valueManager;

@property (nonatomic, assign) BOOL startIndex;  /**< default is 0 */

- (void)resetTitles;

@end
