//
//  KDAscendingUpLoadVC.m
//  KDIOSApp
//
//  Created by appleMac on 16/5/7.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "KDAscendingUpLoadVC.h"
#import "UpImageRequest.h"
#import "KDAscendingUpLoadEntity.h"
#import "KDUpLoadImgCV.h"
#import "UILabel+lyt.h"
#import <Lyt.h>
#import "UIImageView+lyt.h"
#import "UIButton+lyt.h"
#import <YYModel.h>
@interface KDAscendingUpLoadVC ()

@property (nonatomic, retain) UILabel *descLabel;
@property (nonatomic, retain) KDUpLoadImgCV *uploadImg;

@property (nonatomic, retain) UpImageRequest *getDataRequest;

@property (assign, nonatomic) uploadImgType type;
@property (nonatomic, retain) KDAscendingUpLoadEntity *pageEntity;

@property (nonatomic, retain) UIView *shapView;

@end

@implementation KDAscendingUpLoadVC

- (instancetype)initWithType:(uploadImgType)type
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithHex:0xeff3f5];
        self.type = type;
    }
    return self;
}

- (UpImageRequest *)getDataRequest
{
    if (!_getDataRequest) {
        _getDataRequest = [[UpImageRequest alloc] init];
        
    }
    return _getDataRequest;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.descLabel = [UILabel getLabelWithFontSize:15 textColor:Color_Title superView:self.view lytSet:^(UILabel *label) {
        [label lyt_alignLeftToParentWithMargin:15];
        [label lyt_alignRightToParentWithMargin:15];
        [label lyt_alignTopToParentWithMargin:15];
    }];
    
   
    self.descLabel.numberOfLines = 0;
    
    __weak typeof(self) weakSelf = self;
    _uploadImg = [KDUpLoadImgCV getcollection];
    _uploadImg.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_uploadImg];
    [_uploadImg lyt_placeBelowView:weakSelf.descLabel margin:15];
    [_uploadImg lyt_alignLeftToParentWithMargin:15];
    [_uploadImg lyt_alignRightToParentWithMargin:15];
    [_uploadImg lyt_alignBottomToParent];
}

-(void)leftBtnclick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)updateView
{
    self.descLabel.text = self.pageEntity.notice;
    
    _uploadImg.dataArray = self.pageEntity.data;
    _uploadImg.maxNum = [self.pageEntity.max_pictures integerValue];
    _uploadImg.type = self.type;
    [_uploadImg reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _uploadImg.uploadImgSuccss = [self.uploadImgSuccss copy];
    //	1:身份证,2:学历证明,3:工作证明,4:收入证明,5:财产证明,6、工牌照片、7、个人名片，8、银行卡 100:其它证明
    NSString *navTitle = @"";
    switch (_type) {
        case IdCard:
            navTitle = @"身份证";
            break;
        case Certificate:
            navTitle = @"学历证明";
            break;
        case Work:
            navTitle = @"工作证明";
            break;
        case Salary:
            navTitle = @"收入证明";
            break;
        case Property:
            navTitle = @"财产证明";
            break;
        case workCard:
            navTitle = @"工牌照片";
            break;
        case personCard:
            navTitle = @"个人名片";
            break;
        case bankCard:
            navTitle = @"信用卡信息";
            break;
        default:
            navTitle = @"其它证明";
            break;
    }
    self.navigationItem.title = navTitle;
    if (!self.pageEntity) {
        [self getPageData];
    }
    
    if (_type == IdCard) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"样照" style:UIBarButtonItemStylePlain target:self action:@selector(showShape)];
    }
    self.navigationController.navigationBar.tintColor  = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationBar_popBack"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    
}

- (void)showShape
{
    if (!_shapView) {
        _shapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _shapView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
        _shapView.hidden = YES;
        [self.view addSubview:_shapView];
        
        UIImageView *imgView = [UIImageView getImageViewWithImageName:@"ascending_shap" superView:_shapView lytSet:^(UIImageView *imageView) {
            [imageView lyt_centerXInParent];
            [imageView lyt_centerYInParentWithOffset:-30];
            [imageView lyt_setSize:CGSizeMake(SCREEN_WIDTH * 522.f / 750.f, SCREEN_WIDTH * 586.f / 750.f)];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.userInteractionEnabled = YES;
        }];
        
        __weak typeof(self) weakSelf = self;
        [UIButton getButtonWithFontSize:15 TextColorHex:Color_BLACK backGroundColor2:[UIColor clearColor] superView:imgView lytSet:^(UIButton *button) {
            [button lyt_alignRightToParent];
            [button lyt_alignTopToParent];
            [button lyt_setSize:CGSizeMake(40, 40)];
            [button addTarget:weakSelf action:@selector(hideShape) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"borrow_close"] forState:UIControlStateNormal];
        }];
    }
    _shapView.hidden = NO;
}

- (void)hideShape
{
    _shapView.hidden = YES;
}

- (void)getPageData
{
    __weak typeof(self) weakSelf = self;
    [self.getDataRequest getImageInfoWithDict:@{@"type":@(_type)} onSuccess:^(NSDictionary *dictResult) {
        
        weakSelf.pageEntity = [KDAscendingUpLoadEntity yy_modelWithDictionary:dictResult[@"item"]];
        [weakSelf updateView];
        
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        
    }];

    
}

- (void)back
{
    if (self.uploadImg.uploadArray && self.uploadImg.uploadArray.count > 0) {

        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
