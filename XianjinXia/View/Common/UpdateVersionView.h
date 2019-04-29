//
//  UpdateVersionView.h
//  XianjinXia
//
//  Created by 刘群 on 2018/10/13.
//  Copyright © 2018 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    forceUpdateType = 1, //强制更新
    selectUpdateType, //非强制更新
} UpdateType;


typedef void(^nowUpdateClick)();

@interface UpdateVersionView : UIView

@property(nonatomic,copy) nowUpdateClick updateblock;

- (instancetype)initWithFrame:(CGRect)frame updateType:(NSUInteger)type updateContent:(NSString *)updateContent;
- (void)showUpdateAlert;
- (void)dissmissUpdateAlert;

@end
