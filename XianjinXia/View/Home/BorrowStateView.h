//
//  BorrowStateView.h
//  KDFDApp
//
//  Created by sword on 2017/1/5.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface BorrowStateView : UIView

@property (nonatomic, strong) HomeBorrowStateListModel *listEntity;

@property (nonatomic, copy) void(^cancelRejectStateBlock)(NSDictionary *param);

@end
