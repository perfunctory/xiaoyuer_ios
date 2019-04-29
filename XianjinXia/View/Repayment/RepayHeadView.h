//
//  KDRepayHeadView.h
//  KDFDApp
//
//  Created by Innext on 16/9/21.
//  Copyright © 2016年 cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepaymentModel.h"

@interface RepayHeadView : UIView

- (void)configViewWithModel:(RepaymentModel *)model withSection:(NSInteger)section;

@end
