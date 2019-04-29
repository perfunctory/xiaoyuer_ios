//
//  KDShareBounceView.m
//  KDLC
//
//  Created by haoran on 15/10/23.
//  Copyright © 2015年 llyt. All rights reserved.
//

#import "KDShareBounceView.h"

#import "NSString+Frame.h"

@interface KDShareBounceView ()
@property (nonatomic, assign) id <KDShareBounceDelegate>delegate;
@property (nonatomic, retain) NSArray *titleArr;
@property (nonatomic, retain) NSArray *imageArr;
@property (nonatomic, retain) NSString *actityName;
@property (nonatomic, retain) NSString *shareTitle;
@property (nonatomic, retain) NSString *shareImage;

@property (nonatomic, retain) UIButton *shareTap;//分享扩大按钮
@property (nonatomic, retain) UIButton *shareButton;//分享按钮
@property (nonatomic, retain) UILabel *shareLabel;//分享标题

@property (nonatomic, retain) UIView * SheetView;  //弹框
@property (nonatomic, retain) UIView * BlackView;  //背景视图
@property (nonatomic, retain) UILabel *actityLabel;//活动label
@property (nonatomic, retain) UIView  *actityBackView;//活动label的背景视图
@property (nonatomic, retain) UIScrollView *scrollView;//scrollview
@property (nonatomic, retain) UIButton *cancel;//取消按钮

@property (nonatomic, assign) double btnWid;//按钮宽度
@property (nonatomic, assign) double SheetViewHeight; //Sheet高度
@property (nonatomic, assign) double BtnBianju;//按钮边距

@end
@implementation KDShareBounceView
#pragma mark - 初始化
- (instancetype)initWithTitleArray:(NSArray *)titleArray ImageArray:(NSArray *)imageArray ActivityName:(NSString *)activityName Delegate:(id<KDShareBounceDelegate>)delegate
{
    self = [super init];
    if (self) {
        _titleArr = titleArray;
        _imageArr = imageArray;
        _actityName = activityName;
        _delegate = delegate;
        if (SCREEN_WIDTH<375) {
            _btnWid = 45.0f;
        }else
        {
            _btnWid = 50.0f;
        }
        _BtnBianju = (SCREEN_WIDTH-_btnWid*4)/5;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self setUI];
    }
    return self;
}
#pragma mark - 构建页面元素
- (void)setUI
{
    _BlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _BlackView.backgroundColor = [UIColor colorWithRed:106/255.00f green:106/255.00f blue:106/255.00f alpha:0.4];
    [self addSubview:_BlackView];
    UITapGestureRecognizer * Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapCancel)];
    [_BlackView addGestureRecognizer:Tap];
    
    [self addSubview:self.SheetView];
}
- (UIView *)SheetView
{
    if (!_SheetView) {
        _SheetView = [[UIView alloc]initWithFrame:CGRectZero];
        _SheetView.backgroundColor = [UIColor whiteColor];
        
        CGFloat height = [_actityName heightWIthFontSize:15 maxWidth:SCREEN_WIDTH-64];
        
        _actityBackView = [[UIView alloc]init];
        _actityBackView.frame =  _actityName&&![_actityName isEqualToString:@""]?CGRectMake(0, 0, SCREEN_WIDTH, 23+height):CGRectZero;
        _actityBackView.backgroundColor = [UIColor clearColor];
        [_SheetView addSubview:_actityBackView];
        
        _actityLabel = [[UILabel alloc]initWithFrame:CGRectMake(32, 23, SCREEN_WIDTH-64, height)];
        _actityLabel.font = [UIFont systemFontOfSize:15];
        _actityLabel.text = _actityName;
        _actityLabel.numberOfLines = 0;
        _actityLabel.backgroundColor = [UIColor clearColor];
        _actityLabel.textColor = [UIColor colorWithHex:0x333333];
        [_actityBackView addSubview:_actityLabel];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_actityBackView.frame), SCREEN_WIDTH, 85)];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH+10, 85);
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.scrollEnabled = NO;
        [_SheetView addSubview:self.scrollView];
        //排列按钮
        [self setBtn];
        
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancel.frame = CGRectMake(15, CGRectGetMaxY(self.scrollView.frame), SCREEN_WIDTH-30, 44);;
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        _cancel.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancel.layer.cornerRadius = 3;
        [_cancel.layer setMasksToBounds:YES];
        [_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancel addTarget:self action:@selector(TapCancel) forControlEvents:UIControlEventTouchUpInside];
        _cancel.backgroundColor = [UIColor colorWithHex:0xFF5145];
        [_SheetView addSubview:_cancel];
    }
    return _SheetView;
}
- (void)setBtn
{
    if (_titleArr&&_titleArr.count>0) {

        NSInteger hang =0;//几行
        NSInteger yushu = 0;
        //判断能否除尽4
        if (_titleArr.count%4==0) {
            hang = _titleArr.count/4;
        }else
        {
            yushu = _titleArr.count%4;
            hang = _titleArr.count/4+1;
        }
        CGFloat yJianju = 40;
        CGFloat y = 21;
        for (int i=0; i<hang; i++) {
            for (int j=0; j<4; j++) {
                //范围view
                _shareTap = [[UIButton alloc]initWithFrame:CGRectZero];
                _shareTap.backgroundColor = [UIColor clearColor];
                _shareTap.tag = 1000+i*4+j;
                
                //title
                _shareLabel = [[UILabel alloc]initWithFrame:CGRectZero];
                _shareLabel.font = [UIFont systemFontOfSize:13];
                _shareLabel.backgroundColor = [UIColor clearColor];
                //btn
                _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
                _shareButton.tag = 1000+i*4+j;
                _shareButton.frame = CGRectMake(_BtnBianju*(j+1)+_btnWid*j, i*yJianju+i*_btnWid+y, _btnWid, _btnWid);
                if (j==0) {
                    _actityLabel.frame = CGRectMake(CGRectGetMinX(_shareButton.frame), CGRectGetMinY(_actityLabel.frame), SCREEN_WIDTH-2*CGRectGetMinX(_shareButton.frame), CGRectGetHeight(_actityLabel.frame));
                }
                
                //隐藏多余的button
                if (i==hang-1&&yushu&&yushu!=0&&j+1>yushu) {
                    _shareButton.hidden = YES;
//                    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(_actityBackView.frame), WIDTHOFSCREEN, CGRectGetMaxY(_shareButton.frame)+40);
                }else
                {
                    _shareTitle = _titleArr[i*4+j];
                    _shareImage = _imageArr[i*4+j];
                    [_shareButton setImage:[UIImage imageNamed:_shareImage] forState:UIControlStateNormal];
                    [_shareButton addTarget:self action:@selector(ShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [_shareTap addTarget:self action:@selector(ShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    _shareLabel.text = _shareTitle;
                }
                CGFloat shareLabelWidth = [_shareTitle widthWithFontSize:13];
                _shareLabel.frame = CGRectMake(0, 0, shareLabelWidth, 14);
                _shareLabel.center = CGPointMake(_shareButton.center.x, _shareButton.center.y+38);
                _shareTap.frame = CGRectMake(CGRectGetMinX(_shareButton.frame)-_BtnBianju/2, CGRectGetMinY(_shareButton.frame)-y, CGRectGetWidth(_shareButton.frame)+_BtnBianju, y+_btnWid+CGRectGetHeight(_shareLabel.frame));
                [self.scrollView addSubview:_shareTap];
                [self.scrollView addSubview:_shareLabel];
                [self.scrollView addSubview:_shareButton];
            }
        }
        self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(_actityBackView.frame), SCREEN_WIDTH, CGRectGetMaxY(_shareButton.frame)+40);
        _SheetViewHeight =CGRectGetMaxY(_scrollView.frame)+44+15;
        _SheetView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,_SheetViewHeight);
        
    }

}
#pragma mark - 代理事件
- (void)ShareButtonAction:(UIButton *)btn
{
    [self.delegate KDShareButtonAction:btn.tag-1000];
//    [self TapCancelAction];
}
#pragma mark - 消失
- (void)TapCancelAction
{
    //控制摇一摇的分享状态
    [UserDefaults setBool:NO forKey:@"shareBackSuccess"];
    [UserDefaults synchronize];
    
    [UIView animateWithDuration:0.2 animations:^{
        _SheetView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
        
    }completion:^(BOOL finished){
        [_SheetView removeFromSuperview];
        [_BlackView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
#pragma mark - 不影响埋点取消
- (void)TapCancel
{
    [self TapCancelAction];
}
#pragma mark - show
- (void)ShowInView:(UIView *)view
{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            _SheetView.frame = CGRectMake(0, SCREEN_HEIGHT - _SheetViewHeight, SCREEN_HEIGHT, _SheetViewHeight);
        }];

}
#pragma mark - show
- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        _SheetView.frame = CGRectMake(0, SCREEN_HEIGHT - _SheetViewHeight, SCREEN_HEIGHT, _SheetViewHeight);
    }];
}
@end
