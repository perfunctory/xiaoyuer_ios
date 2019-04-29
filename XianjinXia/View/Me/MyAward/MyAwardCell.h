//
//  MyAwardCell.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAwardModel.h"

@interface MyAwardCell : UITableViewCell

+ (MyAwardCell *)myAwardCellWithTableView:(UITableView *)tableView;
- (void)configCellWithModel:(MyAwardDetailModel *)model withIndexPath:(NSIndexPath *)indexPath;

@end
