//
//  KDRepayFirstCell.h
//  KDFDApp
//
//  Created by Innext on 16/9/21.
//  Copyright © 2016年 cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepaymentModel.h"
#import "HightlightCell.h"

@interface RepayFirstCell : HightlightCell

+ (RepayFirstCell *)repayFirstCellWithTableView:(UITableView *)tableView;

- (void)configCellWithModel:(RepayAmountModel *)model withIndexPath:(NSIndexPath *)indexPath;

@end
