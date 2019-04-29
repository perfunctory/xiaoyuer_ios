//
//  ContactsCell.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HightlightCell.h"

@interface ContactsCell : HightlightCell

+ (ContactsCell *)contactsCellWithtableView:(UITableView *)tableView;
- (void)configCellWithName:(NSString *)name;

@end
