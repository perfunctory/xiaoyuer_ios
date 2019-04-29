//
//  HomepageContentCell.h
//  KDFDApp
//
//  Created by sword on 2017/1/4.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeModel.h"

typedef NS_ENUM(NSInteger, kHomepageContentClickType) {
    
    kHomepageContentClickPromoteCreditLine,
    kHomepageContentClickApplyBorrow,
    kHomepageContentClickCancelRejectState,
    kHomepageContentClickCheckFee//服务费用说明按钮点击事件
};

@interface HomepageContentCell : UITableViewCell

@property (nonatomic, strong) HomeModel *entity;
@property (nonatomic, assign) CGFloat contentHeight;

@property (copy, nonatomic) void(^clickBlock)(kHomepageContentClickType type, NSDictionary *param);
@property (copy, nonatomic) void(^contentViewDidChangeBlock)();

- (void)scrollViewContentOffsetDidChange:(CGPoint)newOffset;

- (void)sliderAnimation;

@end
