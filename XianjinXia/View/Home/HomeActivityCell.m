//
//  HomeActivityCell.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/7.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "HomeActivityCell.h"

@interface HomeActivityCell ()

@property (strong, nonatomic) MASConstraint *bottomConstraint;

@end

@implementation HomeActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _bottomCon = 0;
        [self.contentView addSubview:self.apactivityImage];
        
        [self setNeedsUpdateConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.apactivityImage.translatesAutoresizingMaskIntoConstraints) {
        
        [self.apactivityImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.top.equalTo(self.mas_top).with.offset(10);
            self.bottomConstraint = make.bottom.equalTo(self.mas_bottom).with.offset(self.bottomCon);
        }];
    }
}

- (void)setBottomCon:(CGFloat)bottomCon {
    _bottomCon = bottomCon;
    
    if (self.bottomConstraint) {
        self.bottomConstraint.with.offset(bottomCon);
    }
}

- (UIButton *)apactivityImage {
    
    if (!_apactivityImage) {
        
        _apactivityImage = [[UIButton alloc] init];
        _apactivityImage.backgroundColor = [UIColor grayColor];
        [_apactivityImage addTarget:self action:@selector(clickActivity) forControlEvents:UIControlEventTouchUpInside];
    }
    return _apactivityImage;
}

- (void)clickActivity {
    
    !self.clickImageBlock ? : self.clickImageBlock();
}

@end
