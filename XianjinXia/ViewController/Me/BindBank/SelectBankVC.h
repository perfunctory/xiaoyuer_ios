//
//  SelectBankVC.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectBankListModel.h"

typedef void(^selectBankBlock)(BankList * model);

@interface SelectBankVC : BaseViewController
@property (nonatomic, copy) selectBankBlock selectBlock;
@end
