//
//  BindBankCell.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tfChangedBlock)(NSString * parmKey, NSString * parmValue);

@interface BindBankCell : UITableViewCell
@property (nonatomic, copy) tfChangedBlock changeBlock;
+ (BindBankCell *)bindBankCellWithTableView:(UITableView *)tableView;
- (void)configCellWithDict:(NSDictionary *)dict withIndexPath:(NSIndexPath *)indexPath;
@end
