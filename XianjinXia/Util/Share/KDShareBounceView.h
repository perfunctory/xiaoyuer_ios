//
//  KDShareBounceView.h
//  KDLC
//
//  Created by haoran on 15/10/23.
//  Copyright © 2015年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KDShareBounceDelegate<NSObject>
//按钮点击事件通过代理传回
-(void)KDShareButtonAction:(NSInteger)buttonIndex;

@end

@interface KDShareBounceView : UIView

//初始化方法
-(instancetype)initWithTitleArray:(NSArray *)titleArray ImageArray:(NSArray *)imageArray ActivityName:(NSString *)activityName Delegate:(id<KDShareBounceDelegate>)delegate;
- (void)TapCancelAction;

//显示
-(void)ShowInView:(UIView *)view;
/**
 *  展示 不需要传入view  老的先不动
 */
- (void) show;
@end
