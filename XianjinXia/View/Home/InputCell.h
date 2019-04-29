//
//  InputCell.h
//  XianjinXia
//
//  Created by sword on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputCell : UITableViewCell

@property (strong, nonatomic) NSString *inputValue;
@property (strong, nonatomic, readonly) UITextField *inputTextField;

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

@end
