//
//  CheckImagesCell.m
//  XianjinXia
//
//  Created by sword on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "CheckImagesCell.h"

#import "UIButton+LoadImage.h"

@interface CheckImagesCell ()

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray<UIButton *> *buttons;

@end

@implementation CheckImagesCell

- (instancetype)initWithTitle:(NSString *)title {
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])]) {
        
        self.title.text = title;
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.scrollView];
        
        [self setNeedsUpdateConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.title.translatesAutoresizingMaskIntoConstraints) {
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeft);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(100);
            make.top.equalTo(self.contentView.mas_top).with.offset(kPaddingTop);
            make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeft);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-kPaddingTop);
        }];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIButton *button in self.buttons) {
        button.frame = [self buttonFrameWithIndex:button.tag];
    }
    self.scrollView.contentSize = CGSizeMake(self.buttons.count*(kPaddingTop + [self heightOfButton]) + kPaddingTop, CGRectGetHeight(self.scrollView.bounds));
}

#pragma mark - Private
- (CGRect)buttonFrameWithIndex:(NSInteger)index {
    CGRect result = CGRectZero;
    
    result.origin = [self originOfButtonWithIndex:index];
    result.size = CGSizeMake([self heightOfButton], [self heightOfButton]);
    
    return result;
}
- (CGPoint)originOfButtonWithIndex:(NSInteger)index {
    CGPoint result = CGPointZero;
    
    result.x = index*[self heightOfButton] + (index + 1)*kPaddingTop;
    result.y = 0;
    
    return result;
}
- (CGFloat)heightOfButton {
    
    return CGRectGetHeight(self.contentView.bounds) - 2*kPaddingTop;
}

- (void)buttonClick:(UIButton *)sender {
    
    !self.clickImageBlock ? : self.clickImageBlock(sender.tag, !([self.images[sender.tag] isKindOfClass:[UIImage class]] || [self.images[sender.tag] hasPrefix:@"http"]), sender);
}

- (void)setImages:(NSArray *)images {
    
    if ([_images isEqualToArray:images]) {
        return;
    }
    _images = images;
    
    for (UIButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    
    for (NSInteger i = 0; i < images.count; ++i) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if ([images[i] isKindOfClass:[UIImage class]]) { //照片数据
            [button setImage:images[i] forState:UIControlStateNormal];
        } else if ([images[i] hasPrefix:@"http"]) { //服务器
            [button loadImageWithImagePath:images[i] placeholderImage:ImageNamed(@"ascending_icon_normal")];
        } else {
            [button setImage:ImageNamed(images[i]) forState:UIControlStateNormal];
        }
        
        [self.scrollView addSubview:button];
        [self.buttons addObject:button];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (NSMutableArray<UIButton *> *)buttons {
    
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
- (UILabel *)title {
    
    if (!_title) {
        _title = [[UILabel alloc] init];
        
        _title.font = Font_Text_Label;
        _title.textColor = Color_SubTitle;
    }
    return _title;
}
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

@end
