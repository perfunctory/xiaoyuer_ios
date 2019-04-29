//
//  FeeDetailVC.h
//  XianjinXia
//
//  Created by sword on 2017/3/2.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeeDetailPresentationAnimation : NSObject <UIViewControllerAnimatedTransitioning, CAAnimationDelegate, UIViewControllerTransitioningDelegate>

@end

@interface FeeDetailVC : UIViewController

- (instancetype)initWithFeeList:(NSArray *)feeList;

@property (strong, nonatomic) UIView *contentView;

@end
