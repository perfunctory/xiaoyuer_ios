//
//  UICopyLabel.m
//  UICopyLabel
//
//  Created by 刘燕鲁 on 17/1/5.
//  Copyright © 2017年 刘燕鲁. All rights reserved.
//

#import "UICopyLabel.h"

@implementation UICopyLabel

//绑定事件

- (id)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    
    if (self)
        
    {
        [self attachTapHandler];
        
    }
    return self;
    
}
//同上
-(void)awakeFromNib

{
    [super awakeFromNib];
    
    [self attachTapHandler];
    
}

-(void)attachTapHandler

{
    
    self.userInteractionEnabled = YES;  //用户交互的总开关
    
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    touch.numberOfTapsRequired = 1;
    [self addGestureRecognizer:touch];

}

-(void)handleTap:(UIGestureRecognizer*) recognizer

{
    
    [self becomeFirstResponder];
    
//    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@""
//                             
//                                                      action:@selector(copy:)];
    
//    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
    
}

-(BOOL)canBecomeFirstResponder

{
    return YES;
}

// 可以响应的方法

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    
    return (action == @selector(copy:));
    
}
//针对于响应方法的实现
-(void)copy:(id)sender

{
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    pboard.string = self.text;
    
}

@end
