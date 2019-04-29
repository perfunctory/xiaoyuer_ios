//
//  SelectContactsBookVC.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SecondLevelViewController.h"

@interface SelectContactsModel : BaseModel
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * name;
@end

@interface SelectContactsBookVC : SecondLevelViewController
@property (nonatomic, retain) NSArray *titleArr;//索引 arr
@property (nonatomic, retain) NSMutableArray *cellData;//展示cell arr
@property (nonatomic, copy) void (^selectBlock)(SelectContactsModel * model);
@end
