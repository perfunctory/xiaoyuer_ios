//
//  HeightenSlider.m
//  KDFDApp
//
//  Created by sword on 2017/1/5.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import "HeightenSlider.h"

@implementation HeightenSlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
    
    return CGRectMake(0, bounds.size.height/2 - 3, CGRectGetWidth(self.frame), 6);
}

- (NSInteger)moneyIndex {
    
    return (NSInteger)(self.value + 0.5);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
