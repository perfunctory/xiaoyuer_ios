//
//  BackTbvCell.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepaymentModel.h"
#import "HightlightCell.h"

@interface BackTbvCell : HightlightCell

+ (BackTbvCell *)backTbvCellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(Reimbursement *)model withIndexPath:(NSIndexPath *)indexPath;

@end
