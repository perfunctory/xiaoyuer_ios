//
//  CreditLineView.h
//  KDFDApp
//
//  Created by sword on 2017/1/4.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditLineView : UIView

@property (copy, nonatomic) NSString *creditLine;
@property (copy, nonatomic) void(^promoteCreditLineBlock)();
@property (copy, nonatomic) NSString *head_tip;
@property (copy, nonatomic) NSString *risk_status;

@end
