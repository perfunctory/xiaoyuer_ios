//
//  BorrowStateView.m
//  KDFDApp
//
//  Created by sword on 2017/1/5.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import "BorrowStateView.h"

#import "BorrowStateSubView.h"

@interface BorrowStateView ()

@property (strong, nonatomic) NSMutableArray<BorrowStateSubView *> *subStateViews;
@property (strong, nonatomic) UIButton *knowReject;
@property (strong, nonatomic) UIImageView *imvIocn;

@end

@implementation BorrowStateView

- (void)configureInterface {
    
    for (NSInteger i = 0; i < self.listEntity.lists.count; ++i) {
        
        if (0 == i) {
            [self.subStateViews[i] configureFirstCellWithEntity:self.listEntity.lists[i]];
        } else if (i == self.listEntity.lists.count - 1) {
            [self.subStateViews[i] configureLastCellWithEntity:self.listEntity.lists[i]];
        } else {
            [self.subStateViews[i] configureNormalCellWithEntity:self.listEntity.lists[i]];
        }
    }
}

- (NSInteger)addStateSubViewsWithNumber:(NSInteger)number {
    
    NSInteger offset = number - self.subStateViews.count;
    
    if (offset < 0) {
        
        [self removeBottomConstraint];
        for (NSInteger i = 0; i < labs(offset); ++i) {
            [[self.subStateViews lastObject] removeFromSuperview];
            [self.subStateViews removeLastObject];
        }
    } else if (offset > 0) {
        
        [self removeBottomConstraint];
        for (NSInteger i = 0; i < offset; ++i) {
            BorrowStateSubView *view = [[BorrowStateSubView alloc] init];
            [self addSubview:view];
            __weak __typeof(self) weakSelf = self;
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.mas_left);
                make.right.equalTo(weakSelf.mas_right);
                if ((0 == i) && ( 0 == self.subStateViews.count)) {
                    make.top.equalTo(weakSelf.mas_top).with.offset(25);
                } else {
                    make.top.equalTo(weakSelf.subStateViews[self.subStateViews.count - 1].mas_bottom);
                }
            }];
            
            [self.subStateViews addObject:view];
        }
    }
    return offset;
}
- (void)iKnowIt {
    
    !self.cancelRejectStateBlock ? : self.cancelRejectStateBlock(@{@"id": DSStringValue(self.listEntity.button.ids)});
}

- (void)removeBottomConstraint {
    
    for (NSLayoutConstraint *con in self.constraints) {
        
        if (con.firstAttribute == NSLayoutAttributeBottom &&
            (con.firstItem == self.subStateViews.lastObject || con.firstItem == self) &&
            con.secondAttribute == NSLayoutAttributeBottom &&
            (con.secondItem == self || con.secondItem == self.subStateViews.lastObject)) {
            [self removeConstraint:con];
            break;
        }
    }
}

#pragma mark - Setter
- (void)setListEntity:(HomeBorrowStateListModel *)listEntity {
    
    if (0 == listEntity.lists.count) {
        return;
    }
    _listEntity = listEntity;
    
    NSInteger offset = [self addStateSubViewsWithNumber:listEntity.lists.count];
    [self configureInterface];
    
    if (!listEntity.button.ids.length && 0 == listEntity.loanEndTime.length) { //没有Button
        if (self.knowReject.superview || 0 != offset) {
            
            [self.knowReject removeFromSuperview];
            [self.subStateViews.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom).priorityMedium();
            }];
        }
    } else if (!self.knowReject.superview) {
        
        [self removeBottomConstraint];
        [self addSubview:self.knowReject];
        [self.knowReject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(40);
            make.right.equalTo(self.mas_right).with.offset(-40);
            make.top.equalTo(self.subStateViews.lastObject.mas_bottom).with.offset(0).priorityMedium();
            make.bottom.equalTo(self.mas_bottom).with.offset(-45);
            make.height.equalTo(@40);
        }];
    };
    [self addSubview:self.imvIocn];
    [self.imvIocn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

#pragma mark - Getter
- (NSMutableArray<BorrowStateSubView *> *)subStateViews {
    
    if (!_subStateViews) {
        _subStateViews = [[NSMutableArray alloc] init];
    }
    return _subStateViews;
}

- (UIButton *)knowReject {
    
    if (!_knowReject) {
        _knowReject = [[UIButton alloc] init];
        
        _knowReject.titleLabel.font = [UIFont systemFontOfSize:18];
        [_knowReject setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_knowReject setBackgroundImage:[UIImage imageNamed:@"button_red_background"] forState:UIControlStateNormal];
        [_knowReject setTitle:@"朕知道了" forState:UIControlStateNormal];
        [_knowReject addTarget:self action:@selector(iKnowIt) forControlEvents:UIControlEventTouchUpInside];
    }
    return _knowReject;
}

-(UIImageView *)imvIocn{
    if (!_imvIocn) {
        _imvIocn = [[UIImageView alloc]init];
    }
    _imvIocn.image = ImageNamed(@"home_JC");
    return _imvIocn;
}

@end
