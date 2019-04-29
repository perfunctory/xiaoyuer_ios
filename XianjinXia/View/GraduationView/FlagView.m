//
//  FlagView.m
//  GraduationView
//
//  Created by Sword on 11/9/16.
//  Copyright © 2016 sword. All rights reserved.
//

#import "FlagView.h"

@interface FlagView()

@property (strong, nonatomic) UILabel *flagTitle;
@end

@implementation FlagView
@synthesize flagValue = _flagValue;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        [self addSubview:self.flagTitle];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.flagTitle.translatesAutoresizingMaskIntoConstraints) {
        _flagTitle.translatesAutoresizingMaskIntoConstraints = NO;
        NSArray *hCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_flagTitle]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_flagTitle)];
        NSArray *vCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_flagTitle]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_flagTitle)];
        
        [self addConstraints:hCon];
        [self addConstraints:vCon];
    }
}

- (void)setFlagValue:(NSString *)flagValue {
    self.flagTitle.text = flagValue;
}

- (NSString *)flagValue {
    return self.flagTitle.text;
}

- (UILabel *)flagTitle {
    
    if (!_flagTitle) {
        _flagTitle = [[UILabel alloc] init];
        _flagTitle.font = [UIFont boldSystemFontOfSize:30];
        _flagTitle.textColor = UIColorFromRGB(0xeba221);//[UIColor colorWithHex:YGBBLUE];
    }
    return _flagTitle;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    
    CGContextSaveGState(ctx);
    CGContextSetStrokeColorWithColor(ctx, LIGHT_COLOR.CGColor);
    CGContextMoveToPoint(ctx, 0, CGRectGetMaxY(self.flagTitle.frame));
    CGContextAddLineToPoint(ctx, CGRectGetWidth(rect), CGRectGetMaxY(self.flagTitle.frame));
    CGFloat arr[] = {3, 1};
    CGContextSetLineDash(ctx, 0, arr, 2);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);

    CGContextSetStrokeColorWithColor(ctx, DEEP_COLOR.CGColor);
    CGContextMoveToPoint(ctx, CGRectGetMidX(rect), CGRectGetMaxY(self.flagTitle.frame));
    CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawPath(ctx, kCGPathStroke);
}
@end
