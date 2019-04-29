//
//  KDCustomTextField.m
//  KDLC
//
//  Created by apple on 15/12/5.
//  Copyright © 2015年 llyt. All rights reserved.
//

#import "KDCustomTextField.h"
#import "NSString+Frame.h"
@interface KDCustomTextField()

@property (assign, nonatomic) NSInteger gap;
@property (retain, nonatomic) UIColor *changeColor;   //要改变的placeHolder的颜色
@property (assign, nonatomic) NSInteger fontSize;

@end

@implementation KDCustomTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andGap:0 andChangeColor:nil andFont:0];
}

- (instancetype)initWithFrame:(CGRect)frame andGap:(NSInteger)gap
{
    return [self initWithFrame:frame andGap:gap andChangeColor:nil andFont:0];
}

- (instancetype)initWithFrame:(CGRect)frame andGap:(NSInteger)gap andChangeColor:(UIColor *)changeColor
{
    return [self initWithFrame:frame andGap:gap andChangeColor:changeColor andFont:0];
}

- (instancetype)initWithFrame:(CGRect)frame andGap:(NSInteger)gap andChangeColor:(UIColor *)changeColor andFont:(NSInteger)fontSize{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KDCustomTextField" owner:nil options:nil] lastObject];
        self.frame = frame;
        self.gap = gap;
        self.changeColor = changeColor;
        self.fontSize = fontSize;
    }
    return self;
}

//重置占位符区域
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGFloat fontHeight = [self.text sizeWithSystemFont:_fontSize == 0 ? self.font : [UIFont systemFontOfSize:_fontSize]].height;
    CGRect inset = CGRectMake(bounds.origin.x+_gap, (self.changeColor && (([[[UIDevice currentDevice] systemVersion] doubleValue]) >= 7.0)) ? (bounds.size.height - fontHeight) / 2 : 0, bounds.size.width, bounds.size.height);
    return inset;
}

//改变绘文字属性.重写时调用super可以按默认图形属性绘制,若自己完全重写绘制函数，就不用调用super了.
- (void)drawPlaceholderInRect:(CGRect)rect
{
    if (self.changeColor) {
        
        [self.changeColor setFill];
        [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName : _fontSize == 0 ? self.font : [UIFont systemFontOfSize:_fontSize]}];
    }else{
        [super drawPlaceholderInRect:rect];
    }
}

//重置编辑区域
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+_gap, bounds.origin.y, bounds.size.width, bounds.size.height);
    return inset;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+_gap, bounds.origin.y, bounds.size.width, bounds.size.height);
    return inset;
}

@end
