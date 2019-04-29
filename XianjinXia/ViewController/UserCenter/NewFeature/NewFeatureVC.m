//
//  NewFeatureVC.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "NewFeatureVC.h"
#import "UIColor+Extensions.h"

#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)
float const scale5 = 0.853333;
float const scale6p = 1.104000;
int const imageCount = 3;

@interface NewFeatureVC ()<UIScrollViewDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;
@property (nonatomic,weak)UIPageControl *pc;
@property (nonatomic,assign)BOOL isFirstNote; // 保证一次手势通知

@end

@implementation NewFeatureVC
#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    //delegate 置为nil
    //删除通知
}

#pragma mark - View创建与设置

- (void)setUpView {
    
    //创建视图等
    [self setupScrollView];
    [self setupPageControl];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake((imageCount ) * self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    //添加图片
    CGFloat welcomeImageY = 0.0;
    CGFloat welcomeImageW = scrollView.frame.size.width;
    CGFloat welcomeImageH = scrollView.frame.size.height;
    for (int i = 0; i < imageCount; i++) {
        UIImageView *welcomeImage = [[UIImageView alloc] init];
        
        NSString *imageName = nil;
        if (iPhone4) {
            imageName = [NSString stringWithFormat:@"4_welcome%d",i + 1];
        }else{
            imageName = [NSString stringWithFormat:@"6_welcome%d",i + 1];
        }
        welcomeImage.image = [UIImage imageNamed:imageName];
        if (!welcomeImage.image) {
            welcomeImage.image = [UIImage imageNamed:[imageName stringByAppendingString:@".jpg"]];
        }
        CGFloat welcomeImageX = welcomeImageW * i;
        welcomeImage.frame = CGRectMake(welcomeImageX, welcomeImageY, welcomeImageW, welcomeImageH);
        [scrollView addSubview:welcomeImage];
        if (i == (imageCount - 1)) {
            [self setupFourthImage:welcomeImage];
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (iPhone4) {
                btn.frame = CGRectMake(40 + SCREEN_WIDTH * i, SCREEN_HEIGHT - 200, SCREEN_WIDTH -80, 40);
            }else{
                btn.frame = CGRectMake(40 + SCREEN_WIDTH * i, SCREEN_HEIGHT - 200 * WIDTHRADIUS, SCREEN_WIDTH-80, 40);
            }
            [btn setBackgroundImage:[UIImage imageNamed:@"button_red_background"] forState:UIControlStateNormal];
            [btn setTitle:@"立即进入" forState:normal];
            btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
            //            btn.backgroundColor = [UIColor colorWithHex:YGBBLUE];
            [btn setTitleColor:[UIColor whiteColor] forState:normal];
            [btn addTarget:self action:@selector(gotoTabbarController) forControlEvents:UIControlEventTouchUpInside];
            //            btn.layer.cornerRadius = 4.0;
            //            btn.layer.masksToBounds = YES;
            [scrollView addSubview:btn];
        }
    }
}

#pragma mark - 设置pagecontrol
-(void)setupPageControl
{
    UIPageControl *pc = [[UIPageControl alloc] init];
    pc.numberOfPages = imageCount;
    pc.userInteractionEnabled = NO;
//    pc.currentPageIndicatorTintColor = [UIColor colorWithHex:0xc4c4c4];
//    pc.pageIndicatorTintColor = [UIColor colorWithHex:0xececec];
    pc.currentPageIndicatorTintColor = [UIColor clearColor];
    pc.pageIndicatorTintColor = [UIColor clearColor];
    if (iPhone4) {
        pc.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 30);
    }else if (iPhone5){
        pc.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 40 * scale5);
    }else if (iPhone6p){
        pc.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 40 * scale6p);
    }else{
        pc.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 40);
    }
    pc.bounds = CGRectMake(0, 0, 150, 30);
    [self.view addSubview:pc];
    self.pc = pc;
}
#pragma mark - 设置第四张图片
- (void)setupFourthImage:(UIImageView *)imageView
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTabbarController)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:gesture];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double order = scrollView.contentOffset.x / SCREEN_WIDTH;
    int page = (int)(order + 0.5);
    self.pc.currentPage = page;
    
    if (scrollView.contentOffset.x >= SCREEN_WIDTH * imageCount && self.isFirstNote == YES) {
        [self gotoTabbarController];
        self.isFirstNote = NO;
    }
}

- (void)gotoTabbarController {
    if (self.start) {
        self.start();
    }
}


@end
