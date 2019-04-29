//
//  BindBankVCodeCell.h
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/13.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^getVCodeBlock)(NSInteger status, NSString * code, UILabel * lblCode, UIButton * btnCode);

@interface BindBankVCodeCell : UITableViewCell
@property (nonatomic, copy) getVCodeBlock getVCodeBlock;

+ (BindBankVCodeCell *)bindBankVCodeCellWithTableView:(UITableView *)tableView;
- (void)configCellWithDict:(NSDictionary *)dict withIndexPath:(NSIndexPath *)indexPath;

@end
