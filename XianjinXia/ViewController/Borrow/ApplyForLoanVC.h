//
//  KDBorrowChangeVC.h
//  KDIOSApp
//
//  Created by haoran on 16/5/9.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "SecondLevelViewController.h"

@interface ApplyForLoanVC : SecondLevelViewController

- (instancetype)initWithBorrowInfo:(NSDictionary *)borrowInfo;

//新
- (instancetype)initWithBorrowInfo:(NSDictionary *)borrowInfo dicParam:(NSDictionary *)dicParam;
@property (nonatomic, strong)NSDictionary *dicParam;


@end
