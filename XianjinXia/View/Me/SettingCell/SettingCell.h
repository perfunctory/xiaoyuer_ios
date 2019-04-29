//
//  SettingCell.h
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

+ (SettingCell *)homeCellWithTableView:(UITableView *)tableView;

- (void)configCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath*)indexPath;

@end
