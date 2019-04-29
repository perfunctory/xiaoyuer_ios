//
//  KDAlertView.h
//  KDLC
//
//  Created by haoran on 14/12/16.
//  Copyright (c) 2014年 KD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDAlertView : UIView<UITableViewDelegate,UITableViewDataSource>

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;

- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end
