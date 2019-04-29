//
//  PickerCell.h
//  MaYiYiDai
//
//  Created by sword on 2017/1/13.
//  Copyright © 2017年 innex. All rights reserved.
//

#import "SelectionCell.h"

@interface PickerCell : SelectionCell

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle selectDes:(NSString *)selectDes;

@property (strong, nonatomic) NSString *selectDes;

@property (copy, nonatomic) NSInteger (^numberOfRow)();
@property (copy, nonatomic) NSString *(^stringOfRow)(NSInteger row);

@property (copy, nonatomic) void(^didSelectBlock)(NSInteger selectedRow);

//如果没有选择过默认值为-1
- (NSInteger)selectedRow;
- (void)reloadPickerView;

@end
