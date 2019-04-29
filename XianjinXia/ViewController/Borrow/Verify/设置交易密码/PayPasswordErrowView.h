//
//  KDPayPasswordErrowView.h
//  KDIOSApp
//
//  Created by haoran on 16/5/23.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayPasswordErrowView : UIView
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2Wid;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;

- (instancetype)initWithTitle:(NSString *)title LeftBtnTitle:(NSString *)left RightBtnTitle:(NSString *)right;
- (void)show;

- (void)dissmiss;

@end
