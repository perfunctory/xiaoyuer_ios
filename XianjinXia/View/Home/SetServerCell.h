//
//  SetServerCell.h
//  XianjinXia
//
//  Created by 童欣凯 on 2018/3/12.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetServerCell : UITableViewCell

+ (SetServerCell *)homeCellWithTableView:(UITableView *)tableView;

- (void)configCellWithStr:(NSString *) str;

@end
