//
//  BorrowStateSubView.h
//  KDFDApp
//
//  Created by sword on 2017/1/5.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeModel.h"

@interface BorrowStateSubView : UIView

@property (strong, nonatomic) UIImageView *flag;
@property (strong, nonatomic) UIImageView *upright;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

- (void)configureFirstCellWithEntity:(HomeBorrowStateModel *)entity;
- (void)configureNormalCellWithEntity:(HomeBorrowStateModel *)entity;
- (void)configureLastCellWithEntity:(HomeBorrowStateModel *)entity;

@end
