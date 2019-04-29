//
//  TextFieldToobar.m
//  XianjinXia
//
//  Created by sword on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "TextFieldToolbar.h"

@interface TextFieldToolbar ()

@property (strong, nonatomic) UIBarButtonItem *cancelItem;
@property (strong, nonatomic) UIBarButtonItem *doneItem;
@property (strong, nonatomic) UIBarButtonItem *spaceItem;

@property (copy, nonatomic) void(^confirmBlock)();
@property (copy, nonatomic) void(^cancelBlock)();

@end

@implementation TextFieldToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.items = @[self.cancelItem, self.spaceItem, self.doneItem];
    }
    return self;
}

+ (instancetype)textFieldToolbarWithConfirm:(void(^)())confirmBlock cancel:(void(^)())cancelBlock {
    
    TextFieldToolbar *result = [[[self class] alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    result.confirmBlock = confirmBlock;
    result.cancelBlock = cancelBlock;
    
    return result;
}

- (void)cancel {
    !self.cancelBlock ? : self.cancelBlock();
}
- (void)done {
    !self.confirmBlock ? : self.confirmBlock();
}

- (UIBarButtonItem *)cancelItem {
    
    if (!_cancelItem) {
        _cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    }
    return _cancelItem;
}
- (UIBarButtonItem *)doneItem {
    
    if (!_doneItem) {
        _doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    }
    return _doneItem;
}
- (UIBarButtonItem *)spaceItem {
    
    if (!_spaceItem) {
        _spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return _spaceItem;
}

@end
