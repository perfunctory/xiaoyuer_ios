//
//  MeCell.h
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/8.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "KDBaseTableViewCellNew.h"

@interface MeCell : UITableViewCell

//-(void)configUI;
- (void)updateTableViewCellWithdata:(NSArray *)entity index:(NSIndexPath *)indexPath;
@end
