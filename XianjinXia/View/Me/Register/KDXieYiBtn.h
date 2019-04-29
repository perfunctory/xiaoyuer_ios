//
//  KDXieYiBtn.h
//  KDIOSApp
//
//  Created by haoran on 16/5/27.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDXieYiBtn : UIView
/**
 *  协议按钮初始化
 *
 *
 *
 *  @return button实例
 */
- (instancetype)initWithXieyiName:(NSArray *)nameArr topView:(id)view superView:(id)backView;
-(void)chageFrame;

@property (assign, nonatomic) BOOL checked;
@property (copy, nonatomic) void(^checkBlock)();
//协议block
@property (nonatomic, copy) dispatch_block_t xieyiLabelTapBlock;
@property (nonatomic, copy) dispatch_block_t xieyiLabel2TapBlock;
@property (nonatomic, copy) dispatch_block_t xieyiBtnTapBlock;
@property (nonatomic, copy) dispatch_block_t xieyiBtn2TapBlock;
@end
