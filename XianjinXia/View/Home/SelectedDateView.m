//
//  SelectedDateView.m
//  KDFDApp
//
//  Created by sword on 2017/1/4.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import "SelectedDateView.h"

#import "ExclusiveButton.h"

@interface SelectedDateView ()

@property (strong, nonatomic) ExclusiveButton *exclusiveButton;

@property (strong, nonatomic) UILabel *borrowTimeLimit;

@property (strong, nonatomic) NSMutableArray <UIButton *> *dateButtuns;

@end

@implementation SelectedDateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.borrowTimeLimit];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.borrowTimeLimit.translatesAutoresizingMaskIntoConstraints) {
        
        [self.borrowTimeLimit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.centerX.equalTo(self.mas_centerX);
        }];
    }
}

#pragma mark - Public
- (NSString *)selectedDay {
    
    //return self.days[self.exclusiveButton.invalidButton.tag] ? : @"";
    
    if (self.days[self.exclusiveButton.invalidButton.tag]) {
        return 0;
    }
    
    return @"";
    
}

#pragma mark  -返回的选中按钮的tag值 七天为0 14天为1  强制性返回0-
- (NSUInteger)selectedIndex {
 
   
    //return self.exclusiveButton.invalidButton.tag;
     return 0;
}

#pragma mark - Private
- (void)updateDateView {
    
    [self updateConstraintsIfNeeded];
    [self removePreView];
    
    for (NSInteger i = 0; i < self.days.count; ++i) {
        UIButton *button = [self createDateButtonWithTitle:[NSString stringWithFormat:@"%@天", self.days[i]]];
        
        button.tag = i;
        [self addSubview:button];
        [self.dateButtuns addObject:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(@(40*WIDTHRADIUS));
            make.top.equalTo(self.borrowTimeLimit.mas_bottom).with.offset(20*WIDTHRADIUS);
            if (0 == i) {
                make.left.equalTo( self.mas_left);
                make.bottom.equalTo(self.mas_bottom).priorityMedium();
            } else {
                make.left.equalTo( self.dateButtuns[i - 1].mas_right).with.offset(20);
                make.width.equalTo( self.dateButtuns[i - 1]);
                if (self.days.count - 1 == i) {
                    make.right.equalTo(self.mas_right);
                }
            }
            
        }];
        
    }
    self.dateButtuns.lastObject.enabled = NO;
    self.exclusiveButton.allButtons = self.dateButtuns;
}

- (void)removePreView {
    
    for (UIView *view in self.dateButtuns) {
        [view removeFromSuperview];
    }
    [self.dateButtuns removeAllObjects];
}

- (UIButton *)createDateButtonWithTitle:(NSString *)title {
    
    UIButton *result = [[UIButton alloc] init];
    
    [result setTitleColor:[UIColor colorWithHex:0xc1c1c1] forState:UIControlStateNormal];
//    [result setTitleColor:[UIColor colorWithHex:0xCDCDCD] forState:UIControlStateNormal];

//    [result setTitleColor:[UIColor colorWithHex:0xFCC225] forState:UIControlStateDisabled];
    [result setTitleColor:Color_Red forState:UIControlStateDisabled];
       [result setTitle:title forState:UIControlStateNormal];
    [result setImage:ImageNamed(@"time_limit_Choose") forState:UIControlStateDisabled];
//    NSLog(@"%f",(SCREEN_WIDTH-100)/4+13.5);
         [result setImageEdgeInsets:UIEdgeInsetsMake(40*WIDTHRADIUS-12.5,(SCREEN_WIDTH-100)/2-13.5, 0, 0)];
    [result setBackgroundImage:ImageNamed(@"time_limit_unselected") forState:UIControlStateNormal];
    [result setBackgroundImage:ImageNamed(@"time_limit_selected") forState:UIControlStateDisabled];
    result.titleLabel.font = [UIFont systemFontOfSize:16];
    
    return result;
}

#pragma mark - Setter  可选借款天数的数组
- (void)setDays:(NSArray *)days {
    
    if (days.count > 0 && ![_days isEqualToArray:days]) {
        _days = days;

        [self updateDateView];
    }
}

#pragma mark - Getter

- (ExclusiveButton *)exclusiveButton {
    
    if (!_exclusiveButton) {
        _exclusiveButton = [[ExclusiveButton alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        _exclusiveButton.invalidButtonDidChangeBlock = ^(UIButton *button) {
            
            !weakSelf.selectedDayDidChange ? : weakSelf.selectedDayDidChange(weakSelf);
        };
    }
    return _exclusiveButton;
}


- (UILabel *)borrowTimeLimit {
    
    if (!_borrowTimeLimit) {
        UILabel *result = [[UILabel alloc] init];
        
        result.font = [UIFont systemFontOfSize:14];
        result.textColor = [UIColor colorWithHex:0x3B3B3B];
        result.text = @"借款期限（天）";
        _borrowTimeLimit = result;
    }
    
    return _borrowTimeLimit;
}

- (NSMutableArray<UIButton *> *)dateButtuns {
    
    if (!_dateButtuns) {
        _dateButtuns = [NSMutableArray array];
    }
    return _dateButtuns;
}



@end
