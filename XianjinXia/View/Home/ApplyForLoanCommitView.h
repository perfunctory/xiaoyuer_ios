//
//  ApplyForLoanCommitView.h
//  XianjinXia
//
//  Created by sword on 14/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyForLoanCommitView : UIView

@property (copy, nonatomic) NSString *tipString;
@property (copy, nonatomic) NSArray<NSString *> *protocolArray; //借款协议，

@property (assign, nonatomic) BOOL enableOfApplyButton;
@property (assign, nonatomic) BOOL checked;

@property (copy, nonatomic) void(^clickCommitBlock)();
@property (copy, nonatomic) void(^checkProtocolBlock)(NSString *);
@property (copy, nonatomic) void(^checkBlock)();

+ (instancetype)applyForLoanCommitView;

@end
