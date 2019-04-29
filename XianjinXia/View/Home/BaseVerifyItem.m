//
//  BaseVerifyItem.m
//  XianjinXia
//
//  Created by sword on 2017/3/30.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseVerifyItem.h"

#import "UIImageView+LoadImage.h"

@interface BaseVerifyItem ()

@property (strong, nonatomic) UIButton *clickButton;
@property (strong, nonatomic) UIView *centerToolView;

@property (strong, nonatomic) UIImageView *itemImageView;
@property (strong, nonatomic) UILabel *itemTitle;
@property (strong, nonatomic) UILabel *itemStatus;

@end

@implementation BaseVerifyItem

+ (instancetype)baseVerifyItemWithTarget:(id)target action:(SEL)action {
    
    BaseVerifyItem *result = [[[self class] alloc] init];
    
    [result.clickButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return result;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.clickButton];
        [self addSubview:self.centerToolView];
        [self.centerToolView addSubview:self.itemImageView];
        [self.centerToolView addSubview:self.itemTitle];
        [self.centerToolView addSubview:self.itemStatus];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.clickButton.translatesAutoresizingMaskIntoConstraints) {
        
        [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.centerToolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.centerToolView.mas_top);
            make.centerX.equalTo(self.centerToolView.mas_centerX);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(40, 40)]);
        }];
        [self.itemTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.itemImageView.mas_bottom).with.offset(10);
            make.left.equalTo(self.centerToolView.mas_left);
            make.right.equalTo(self.centerToolView.mas_right).priorityMedium();
        }];
        [self.itemStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.itemTitle.mas_bottom).with.offset(5);
            make.centerX.equalTo(self.itemTitle.mas_centerX);
            make.bottom.equalTo(self.centerToolView.mas_bottom).priorityMedium();
        }];
    }
}

- (void)configureBaseVerifyItemWithModel:(VerifyListModel *)model {
    
    [self.itemImageView loadImageWithImagePath:model.logo];
    self.itemTitle.text = model.title;
    self.itemStatus.attributedText = model.operators;
    
    
    //[[NSAttributedString alloc] initWithData:[model.operators dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];//[GToolUtil addAttributeWithHtml5String:model.operators];
}

- (void)setTag:(NSInteger)tag {
    [super setTag:tag];
    self.clickButton.tag = tag;
}

- (UIButton *)clickButton {
    
    if (!_clickButton) {
        _clickButton = [[UIButton alloc] init];
    }
    return _clickButton;
}
- (UIView *)centerToolView {
    
    if (!_centerToolView) {
        _centerToolView = [[UIView alloc] init];
        _centerToolView.userInteractionEnabled = NO;
    }
    return _centerToolView;
}
- (UIImageView *)itemImageView {
    
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc] init];
        
        _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _itemImageView;
}
- (UILabel *)itemTitle {
    
    if (!_itemTitle) {
        _itemTitle = [[UILabel alloc] init];
        
        _itemTitle.textColor = [UIColor colorWithHex:0x656565];
        _itemTitle.font = FontSystem(15);
    }
    return _itemTitle;
}
- (UILabel *)itemStatus {
    
    if (!_itemStatus) {
        _itemStatus = [[UILabel alloc] init];
        
        _itemStatus.textColor = [UIColor colorWithHex:0x2B77EA];
        _itemStatus.font = FontSystem(11);
    }
    return _itemStatus;
}

@end
