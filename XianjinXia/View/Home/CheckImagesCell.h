//
//  CheckImagesCell.h
//  XianjinXia
//
//  Created by sword on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckImagesCell : UITableViewCell

- (instancetype)initWithTitle:(NSString *)title;

@property (strong, nonatomic) NSArray *images;

@property (copy, nonatomic) void(^clickImageBlock)(NSInteger index, BOOL defaultImage, UIButton *imageButton);

@end
