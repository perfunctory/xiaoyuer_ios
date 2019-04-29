//
//  ApplyForLoanCell.m
//  XianjinXia
//
//  Created by sword on 13/02/2017.
//  Copyright © 2017 lxw. All rights reserved.
//

#import "ApplyForLoanCell.h"

@interface ApplyForLoanCell ()

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *content;
@property (strong, nonatomic) UILabel *state;

@end

@implementation ApplyForLoanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeCell];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initializeCell];
}

- (void)initializeCell {
    
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.content];
    [self.contentView addSubview:self.state];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.title.translatesAutoresizingMaskIntoConstraints) {
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.state.mas_left).with.offset(-5);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-15));
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
}

- (void)configureApplyForCellWithDictionary:(NSDictionary *)aDic {
    
    self.title.text = aDic[@"title"];
    self.state.text = aDic[@"status"];

    if ([aDic[@"content"] isKindOfClass:[NSAttributedString class]]) {
        self.content.attributedText = aDic[@"content"];
    } else {
        self.content.text = [NSString stringWithFormat:@"%@",aDic[@"content"]];
    }
    self.accessoryType = [aDic[@"showDetail"] boolValue] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.userInteractionEnabled = [aDic[@"showDetail"] boolValue];
}

- (UILabel *)createNormalLabel {
    UILabel *result = [[UILabel alloc] init];
    
    result.font = Font_Cell_TextLabel;
    result.textColor = Color_Title;
    
    return result;
}

#pragma mark - Getter
- (UILabel *)title {
    
    if (!_title) {
        _title = [self createNormalLabel];
    }
    return _title;
}
- (UILabel *)content {
    
    if (!_content) {
        _content = [self createNormalLabel];
    }
    return _content;
}
- (UILabel *)state {
    
    if (!_state) {
        _state = [self createNormalLabel];
    }
    return _state;
}

@end
