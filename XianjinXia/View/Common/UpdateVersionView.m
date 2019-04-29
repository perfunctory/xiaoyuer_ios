//
//  UpdateVersionView.m
//  XianjinXia
//
//  Created by 刘群 on 2018/10/13.
//  Copyright © 2018 lxw. All rights reserved.
//

#import "UpdateVersionView.h"

@interface UpdateVersionView ()
@property (nonatomic,strong) UIImageView *topImgView;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) UILabel *updateDescLabel;
@property (nonatomic,strong) UILabel *updateContentLabel;
@property (nonatomic,strong) UIButton *noUpdateBtn;
@property (nonatomic,strong) UIButton *nowUpdateBtn;
@property (nonatomic,assign) UpdateType type;
@property (nonatomic,copy) NSString *updateContent;
@end


@implementation UpdateVersionView

- (instancetype)initWithFrame:(CGRect)frame updateType:(NSUInteger)type updateContent:(NSString *)updateContent{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    if (self) {
        _type = type;
        _updateContent = updateContent;
        [self addView];
        [self addLayout];
    }
    return self;
}

- (void)showUpdateAlert{
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dissmissUpdateAlert{
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addView{
    
    [self addSubview:self.backView];
    [self.backView addSubview:self.topImgView];
    [self.backView addSubview:self.whiteView];
    [self.whiteView addSubview:self.updateDescLabel];
    [self.whiteView addSubview:self.updateContentLabel];
    if (_type == 1) { //强制更新
        [self.whiteView addSubview:self.nowUpdateBtn];
    }else{ //非强制更新
        [self.whiteView addSubview:self.noUpdateBtn];
        [self.whiteView addSubview:self.nowUpdateBtn];
    }
}

- (void)addLayout{
    
    __weak typeof (self) weakSelf = self;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(440);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(-30);
        make.center.mas_equalTo(weakSelf);
    }];
    
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf.backView);
        make.height.mas_equalTo((weakSelf.frame.size.width - 60) *(weakSelf.topImgView.image.size.height/weakSelf.topImgView.image.size.width));
    }];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.backView);
        make.top.mas_equalTo(weakSelf.topImgView.mas_bottom).offset(-220);
        make.bottom.mas_equalTo(weakSelf.backView.mas_bottom);
    }];
    

    [self.updateDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(weakSelf.whiteView.mas_top);
        make.height.mas_equalTo(20);
        [weakSelf.updateDescLabel sizeToFit];
    }];

    [self.updateContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.updateDescLabel.mas_left);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(weakSelf.updateDescLabel.mas_bottom).offset(15);
        [weakSelf.updateContentLabel sizeToFit];
    }];

    if (_type == 1) {
        [self.nowUpdateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.backView);
            make.width.mas_equalTo(weakSelf.frame.size.width-60-120);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(weakSelf.backView.mas_bottom).offset(-20);
        }];
    }else{
        [self.noUpdateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.width.mas_equalTo((weakSelf.frame.size.width-60)/2-40);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(weakSelf.backView.mas_bottom).offset(-20);
        }];

        [self.nowUpdateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.width.mas_equalTo((weakSelf.frame.size.width-60)/2-40);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(weakSelf.backView.mas_bottom).offset(-20);
        }];
    }
}


- (UIView *)backView{
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor clearColor];
        _backView.layer.cornerRadius = 8.0f;
        _backView.layer.masksToBounds = YES;
        _backView.alpha = 0;
    }
    return _backView;
}

- (UIImageView *)topImgView{
    if (!_topImgView) {
        _topImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jx_update"]];
    }
    return _topImgView;
}

- (UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [UIView new];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

- (UILabel *)updateDescLabel{
    if (!_updateDescLabel) {
        _updateDescLabel = [UILabel new];
        _updateDescLabel.text = @"更新内容:";
        _updateDescLabel.font = [UIFont systemFontOfSize:17];
        _updateDescLabel.textColor = [UIColor blackColor];
    }
    return _updateDescLabel;
}

- (UILabel *)updateContentLabel{
    if (!_updateContentLabel) {
        _updateContentLabel = [UILabel new];
        _updateContentLabel.text = _updateContent;
        _updateContentLabel.numberOfLines = 0;
        _updateContentLabel.font = [UIFont systemFontOfSize:15];
        _updateContentLabel.textColor = [UIColor darkGrayColor];
    }
    return _updateContentLabel;
}

- (UIButton *)noUpdateBtn{
    if (!_noUpdateBtn) {
        _noUpdateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noUpdateBtn setTitle:@"暂不升级" forState:0];
        _noUpdateBtn.layer.borderColor = Color_Red.CGColor;
        _noUpdateBtn.layer.borderWidth = 1.0f;
        _noUpdateBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_noUpdateBtn setTitleColor:[UIColor blackColor] forState:0];
        [_noUpdateBtn addTarget:self action:@selector(noUpdateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noUpdateBtn;
}

- (UIButton *)nowUpdateBtn{
    if (!_nowUpdateBtn) {
        _nowUpdateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nowUpdateBtn setTitle:@"立即升级" forState:0];
        _nowUpdateBtn.backgroundColor =Color_Red;
        _nowUpdateBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_nowUpdateBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_nowUpdateBtn addTarget:self action:@selector(nowUpdateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nowUpdateBtn;
}



- (void)noUpdateBtnClick{
    [self dissmissUpdateAlert];
}

- (void)nowUpdateBtnClick{
    self.updateblock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
