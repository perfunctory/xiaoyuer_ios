//
//  SelectBankListCell.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/13.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectBankListModel.h"

@interface SelectBankListCell : UITableViewCell

+ (SelectBankListCell *)selectBankListCellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(BankList *)model withIndexPath:(NSIndexPath *)indexPath;

@end
