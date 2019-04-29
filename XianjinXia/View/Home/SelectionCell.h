//
//  SelectionCell.h
//  XianjinXia
//
//  Created by sword on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "HightlightCell.h"

@interface SelectionCell : HightlightCell

@property (strong, nonatomic, readonly) UILabel *title;
@property (strong, nonatomic, readonly) UILabel *subTitle;
@property (strong, nonatomic, readonly) UIImageView *rightIndicate;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle;

- (void)setSubTitleValue:(NSString *)subTitleValue;
- (void)setSubTitleTextAlignment:(NSTextAlignment)alignment;

@end
