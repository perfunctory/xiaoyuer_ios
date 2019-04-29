//
//  HomepageContentCell.m
//  KDFDApp
//
//  Created by sword on 2017/1/4.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import "HomepageContentCell.h"

#import "ContentHeadView.h"
#import "AmountContentView.h"
#import "AmountBottomView.h"
#import "BorrowStateView.h"
#import "BorrowStateBottomView.h"
#import "CountDownContentView.h"
#import "CountDownBottomView.h"

#import "UserManager.h"
#import "FeeManager.h"

@interface HomepageContentCell ()

@property (strong, nonatomic) UIView *redBackground;
@property (strong, nonatomic) MASConstraint *redHeight;
@property (strong, nonatomic) UIImageView *background;

@property (nonatomic, strong) ContentHeadView *headView;

@property (strong, nonatomic) NSArray<UIView *> *showViews;

@property (strong, nonatomic) FeeManager *feeManager;
@property (strong, nonatomic) AmountContentView *amountView;
@property (strong, nonatomic) AmountBottomView *amountBottomView;

@property (strong, nonatomic) BorrowStateView *stateView;
@property (strong, nonatomic) BorrowStateBottomView *stateBottom;

@property (strong, nonatomic) CountDownContentView *countDownView;
@property (strong, nonatomic) CountDownBottomView *countDownBottomView;

@end

#define Origin_Red_Height 25

@implementation HomepageContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = Color_Background;
        
        [self.contentView addSubview:self.redBackground];
        [self.contentView addSubview:self.background];
        
        [self.contentView addSubview:self.headView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}
- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.headView.translatesAutoresizingMaskIntoConstraints) {
        
        [self.redBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_top).with.offset(25);
//                        make.top.equalTo(self.mas_top);
            self.redHeight = make.height.equalTo(@(Origin_Red_Height));
        }];
        [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(8);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right).with.offset(-8);
        }];
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(0);//10
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right).with.offset(0);//-10
//            make.height.mas_offset(Origin_Red_Height);
        }];
    }
}

#pragma mark - Public
- (void)scrollViewContentOffsetDidChange:(CGPoint)newOffset {
    
    if (newOffset.y <= 0 && self.redHeight) {
        self.redHeight.equalTo(@(Origin_Red_Height - newOffset.y));
    }
}

- (void)sliderAnimation {
    
    [self.amountView sliderAnimation];
}
#pragma mark - Private

- (NSArray *)changedContentShowViews {
    
    if ([self showCountDown]) {//显示倒计时结束时才可以借款view
        
        self.countDownView.entity = self.entity;
        self.countDownBottomView.entity = self.entity;
        return @[self.countDownView, self.countDownBottomView];
        
    } else if (self.entity.borrowStateList.lists.count > 0) { //有借款的情况下显示借款状态
        
        self.stateView.listEntity = self.entity.borrowStateList;
        return @[self.stateView, self.stateBottom];
        
    } else {
        
        self.amountView.entity = self.entity;
        self.amountBottomView.item = self.entity.item;
        return @[self.amountView, self.amountBottomView];
    }
}

- (BOOL)showCountDown {

    return (0 == self.entity.borrowStateList.button.ids.length && 0 != self.entity.item.next_loan_day.integerValue) || ((0 != self.entity.borrowStateList.loanEndTime.length) && [UserManager sharedUserManager].countDownStateOfLoan);
}

#pragma mark- Setter
- (void)setEntity:(HomeModel *)entity {
    _entity = entity;
    
    self.headView.entity = entity;
    self.feeManager.amountInfo = entity.amountInfo;
    
    self.showViews = [self changedContentShowViews];
    self.contentHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 11;
}
- (void)setShowViews:(NSArray<UIView *> *)showViews {
    if ([_showViews isEqualToArray:showViews]) {
        return;
    }
    
    for (UIView *view in _showViews) {
        [view removeFromSuperview];
    }
    for (UIView *view in showViews) {
        [self.contentView addSubview:view];
    }
    [self updateConstraintsIfNeeded];
    
    _showViews = showViews;
    [showViews.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.headView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.background.mas_bottom);
    }];
    [showViews.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(showViews.firstObject.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).priorityMedium();
    }];
    
    [self layoutIfNeeded];
}

#pragma mark - Getter
- (UIView *)redBackground {
    
    if (!_redBackground) {
        _redBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Origin_Red_Height)];
        _redBackground.backgroundColor = [UIColor whiteColor];
    }
    return _redBackground;
}
- (UIImageView *)background {
    
    if (!_background) {
        _background = [[UIImageView alloc] initWithImage:ImageNamed(@"")];//home_head_background
    }
    return _background;
}
- (ContentHeadView *)headView {
    
    if (!_headView) {
        _headView = [[ContentHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 25*WIDTHRADIUS)];
        _headView.backgroundColor = [UIColor whiteColor];
        @Weak(self)
        _headView.promoteCreditLineBlock = ^{
            @Strong(self)
            !self.clickBlock ? : self.clickBlock(kHomepageContentClickPromoteCreditLine, nil);
        };
    }
    return _headView;
}
- (FeeManager *)feeManager {
    
    if (!_feeManager) {
        _feeManager = [[FeeManager alloc] init];
    }
    return _feeManager;
}
- (AmountContentView *)amountView {
    
    if (!_amountView) {
        _amountView = [[AmountContentView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 100*WIDTHRADIUS)];
        _amountView.backgroundColor = [UIColor whiteColor];
        @Weak(self)
        _amountView.moneyDidChange = ^(NSInteger money, NSUInteger index) {
            @Strong(self)
            [self.feeManager configureManagerWithAmount:money feeIndex:index];
//            [self.amountBottomView.amountView configureWithFeeManager:self.feeManager];//lxw
        };
        _amountView.applyOrCheckFeeBlock = ^(BOOL isApply){
            @Strong(self)
            !self.clickBlock ? : self.clickBlock(isApply ? kHomepageContentClickApplyBorrow : kHomepageContentClickCheckFee, [self.amountView selectedDicionary]);
        };
    }
    return _amountView;
}
- (AmountBottomView *)amountBottomView {
    
    if (!_amountBottomView) {
        _amountBottomView = [[AmountBottomView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 100)];
        _amountBottomView.backgroundColor = [UIColor clearColor];
        @Weak(self)
        _amountBottomView.applyOrCheckFeeBlock = ^(BOOL isApply){
            @Strong(self)
            !self.clickBlock ? : self.clickBlock(isApply ? kHomepageContentClickApplyBorrow : kHomepageContentClickCheckFee, [self.amountView selectedDicionary]);
        };
    }
    return _amountBottomView;
}
- (BorrowStateView *)stateView {
    
    if (!_stateView) {
        _stateView = [[BorrowStateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _stateView.backgroundColor = [UIColor whiteColor];
        @Weak(self)
        _stateView.cancelRejectStateBlock = ^(NSDictionary *param) {
            @Strong(self)
            if (0 == self.entity.borrowStateList.loanEndTime.length) {
                !self.clickBlock ? : self.clickBlock(kHomepageContentClickCancelRejectState, param);
            } else {
                [UserManager sharedUserManager].countDownStateOfLoan = YES;
                self.showViews = [self changedContentShowViews];
                self.contentHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 11;
                !self.contentViewDidChangeBlock ? : self.contentViewDidChangeBlock();
            }
        };
    }
    return _stateView;
}
- (BorrowStateBottomView *)stateBottom {
    
    if (!_stateBottom) {
        _stateBottom = [[BorrowStateBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    }
    return _stateBottom;
}
- (CountDownContentView *)countDownView {
    
    if (!_countDownView) {
        _countDownView = [[CountDownContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    _countDownView.backgroundColor = [UIColor whiteColor];
    return _countDownView;
}
- (CountDownBottomView *)countDownBottomView {
    
    if (!_countDownBottomView) {
        _countDownBottomView = [[CountDownBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    return _countDownBottomView;
}

@end
