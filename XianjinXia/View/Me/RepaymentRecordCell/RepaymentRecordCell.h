//
//  RepaymentRecordCell.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepaymentRecordModel.h"
#import "HightlightCell.h"

@interface RepaymentRecordCell : HightlightCell

+ (RepaymentRecordCell*)repaymentRecordCellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(RecordModel *)model;

@end
