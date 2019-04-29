//
//  SelectedDateView.h
//  KDFDApp
//
//  Created by sword on 2017/1/4.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedDateView : UIView

@property (strong, nonatomic) NSArray *days;
@property (copy, nonatomic) void(^selectedDayDidChange)(SelectedDateView *dateView);

- (NSString *)selectedDay;
- (NSUInteger)selectedIndex;

@end
