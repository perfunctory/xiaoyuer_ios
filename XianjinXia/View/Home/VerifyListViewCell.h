//
//  VerifyListViewCell.h
//  XianjinXia
//
//  Created by 童欣凯 on 2018/2/25.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerifyListModel.h"

@interface VerifyListViewCell : UITableViewCell

@property (copy, nonatomic) void(^selectedIndex)(VerifyListModel *preModel, VerifyListModel *model);

@property (strong, nonatomic) NSArray<VerifyListModel *> *dataArray;

@end
