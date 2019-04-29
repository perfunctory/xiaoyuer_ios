//
//  UIButton+lyt.m
//  KDIOSApp
//
//  Created by appleMac on 16/5/1.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "UIButton+lyt.h"

@implementation UIButton (lyt)

+(UIButton *)getButtonWithFontSize:(NSInteger)size TextColorHex:(UIColor *)colorHex backGroundColor:(UIColor *)color superView:(UIView *)superView lytSet:(void (^)(UIButton *))block
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    [btn setTitleColor:colorHex forState:UIControlStateNormal];
    if (color) {
        [btn setBackgroundColor:color];
    }
    [superView addSubview:btn];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (block) {
        block(btn);
    }
    
    return btn;
}
+(UIButton *)getButtonWithFontSize:(NSInteger)size TextColorHex:(UIColor *)colorHex backGroundColor2:(UIColor *)color superView:(UIView *)superView lytSet:(void (^)(UIButton *))block
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    [btn setTitleColor:colorHex forState:UIControlStateNormal];
    [btn setBackgroundColor:color];

    [superView addSubview:btn];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (block) {
        block(btn);
    }
    
    return btn;
}


+ (UIButton *)getCustomButtonWithTitleEdge:(UIEdgeInsets)titleEdge imageEdge:(UIEdgeInsets)imageEdge imageDirection:(ImageEdgeDirection)imageDirection FontSize:(NSInteger)size TextColorHex:(UIColor *)colorHex backGroundColor:(UIColor *)color superView:(UIView *)superView masonrySet:(void (^)(UIButton *view,MASConstraintMaker *make))block{
    return [UIButton getCustomButtonWithTitleEdge:titleEdge imageEdge:imageEdge imageDirection:imageDirection FontSize:size TextColorHex:colorHex backGroundColor2:color superView:superView masonrySet:block];
}

+ (UIButton *)getCustomButtonWithTitleEdge:(UIEdgeInsets)titleEdge imageEdge:(UIEdgeInsets)imageEdge imageDirection:(ImageEdgeDirection)imageDirection FontSize:(NSInteger)size TextColorHex:(UIColor *)colorHex backGroundColor2:(UIColor *)color superView:(UIView *)superView masonrySet:(void (^)(UIButton *view,MASConstraintMaker *make))block{
    KDCustombutton *btn = [KDCustombutton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    btn.titleEdge = titleEdge;
    btn.imageEdge = imageEdge;
    btn.imageDirection = imageDirection;
    [btn setTitleColor:colorHex forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    [superView addSubview:btn];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (block) {
            block(btn,make);
        }
    }];
    return btn;
}

+(void)startRunSecond:(UIButton *)btn stringFormat:(NSString *)str finishBlock:(dispatch_block_t)finish
{
    [btn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                if (finish) {
                    finish();
                }
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [btn setTitle:[NSString stringWithFormat:str,strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                btn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark --自定义右箭头
+ (UIButton *)rightArrowCustom{
    UIImage *image= [UIImage   imageNamed:@"borrow_arrowright"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    
    button.frame = frame;
    
    [button setImage :image forState:UIControlStateNormal];
    
    button.backgroundColor= [UIColor clearColor];
    return button;
}
@end
