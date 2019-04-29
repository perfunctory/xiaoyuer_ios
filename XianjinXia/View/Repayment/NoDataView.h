//
//  NoDataView.h
//  KDLC
//
//  Created by summertian on 14/11/24.
//  Copyright (c) 2014年 KD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^getBorrowBlock)();
typedef void(^userPaymentBlock)();

@interface NoDataView : UIView

@property (strong, nonatomic) UILabel *detailLabel;

@property (nonatomic, strong) UIButton  * btnBorrow;

@property (nonatomic,strong)  UIImageView * imageView;

@property (nonatomic, strong) NSLayoutConstraint *imageTop;

@property (nonatomic, strong) NSLayoutConstraint *btnTop;

@property (nonatomic, strong) NSLayoutConstraint *btnHeght;

@property (nonatomic, strong) NSLayoutConstraint *btnwidth;

@property (copy, nonatomic) dispatch_block_t btnClick;

@property (copy, nonatomic) getBorrowBlock getBorrowBlock;
@property (copy, nonatomic) userPaymentBlock userBlock;

@property (copy, nonatomic) UIButton * btnRepay;

@end
