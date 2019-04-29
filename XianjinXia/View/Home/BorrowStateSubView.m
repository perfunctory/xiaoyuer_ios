//
//  BorrowStateSubView.m
//  KDFDApp
//
//  Created by sword on 2017/1/5.
//  Copyright © 2017年 cailiang. All rights reserved.
//

#import "BorrowStateSubView.h"

@implementation BorrowStateSubView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.flag];
        [self addSubview:self.upright];
        [self addSubview:self.titleLabel];
        [self addSubview:self.descriptionLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.flag.translatesAutoresizingMaskIntoConstraints) {
        
        __weak __typeof(self) weakSelf = self;
        [self.flag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.mas_left).with.offset(40);
            make.top.equalTo(weakSelf.mas_top);
        }];
        [self.flag setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.flag setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.flag setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.flag setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        [self.upright mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.flag.mas_centerX);
            make.top.equalTo(weakSelf.flag.mas_bottom);
            make.bottom.equalTo(weakSelf.mas_bottom);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.flag.mas_right).with.offset(5);
            make.top.equalTo(weakSelf.flag.mas_top).with.offset(0);
            make.right.equalTo(weakSelf.mas_right).with.offset(-40);
        }];
        [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLabel.mas_left);
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).with.offset(5);
            make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-25);
            make.right.equalTo(weakSelf.mas_right).with.offset(-40);
        }];
        [self.descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
}

- (void)configureFirstCellWithEntity:(HomeBorrowStateModel *)entity {
    self.flag.image = [UIImage imageNamed:[self configStatusWithTag:entity.tag.integerValue]];//[UIImage imageNamed: 2 == entity.tag.integerValue ? @"state_no" : @"state_underway"];
    self.upright.image = [UIImage imageNamed: 2 == entity.tag.integerValue ? @"upright_line" : @"upright_imaginary_line"];
    
    [self configureText:entity];
}
- (void)configureNormalCellWithEntity:(HomeBorrowStateModel *)entity {
    self.flag.image = [UIImage imageNamed:@"state_yes"];
    self.upright.image = [UIImage imageNamed:@"upright_line"];
    
    [self configureText:entity];
}
- (void)configureLastCellWithEntity:(HomeBorrowStateModel *)entity {
    self.flag.image = [UIImage imageNamed:@"state_yes"];
    self.upright.image = nil;
    
    [self configureText:entity];
}

- (void)configureText:(HomeBorrowStateModel *)entity {
    
    self.titleLabel.text = entity.title;
    self.descriptionLabel.text = entity.body;
    
    [self.titleLabel sizeToFit];
    [self.descriptionLabel sizeToFit];
}

- (NSString *)configStatusWithTag:(NSInteger)tag {
    if (tag == 0) {
        return @"state_yes";
    }else if (tag == 1) {
        return @"state_underway";
    }else if (tag == 2) {
        return @"state_no";
    }
    return @"state_done";
}

#pragma mark - Getter
- (UIImageView *)flag {
    
    if (!_flag) {
        _flag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"state_yes"]];
    }
    return _flag;
}
- (UIImageView *)upright {
    
    if (!_upright) {
        _upright = [[UIImageView alloc] init];
    }
    return _upright;
}
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.minimumScaleFactor = 0.8f;
        _titleLabel.textColor = [UIColor colorWithHex:0x616161];
        _titleLabel.numberOfLines = 1;
        _titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 85 - self.flag.bounds.size.width;
        _titleLabel.text = @"title";
    }
    return _titleLabel;
}
- (UILabel *)descriptionLabel {
    
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        
        _descriptionLabel.font = [UIFont systemFontOfSize:10];
        _descriptionLabel.textColor = [UIColor colorWithHex:0x8B8B8B];
        _descriptionLabel.numberOfLines = 3;
        _descriptionLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 85 - self.flag.bounds.size.width;
        _descriptionLabel.text = @"description";
    }
    return _descriptionLabel;
}

@end
