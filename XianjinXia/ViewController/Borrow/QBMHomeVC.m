//
//  BorrowVC.m
//  XianjinXia
//
//  Created by lxw on 17/1/23.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "QBMHomeVC.h"

#import "VerifyListVC.h"
#import "CommonWebVC.h"
#import "ApplyForLoanVC.h"
#import "FeeDetailVC.h"

#import "HomeRequest.h"
#import "HomeModel.h"
#import "UIColor+Extensions.h"
#import <MJRefresh.h>
//#import "ActivityHeaderView.h"
#import "HomeActivityCell.h"
#import "UIButton+LoadImage.h"
#import "DSUtils.h"
#import "UserManager.h"
#import "HomepageContentCell.h"
#import <UMMobClick/MobClick.h>
#import "EventCalendar.h"
#import "NoticeView.h"
#import "ZLImageViewDisplayView.h"
#import "LSFloatingActionMenu.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "MeRequest.h"
#import "MeModel.h"
#import "UpdateVersionView.h"

//在线客服
#import "QYSessionViewController.h"
#import "QYSource.h"
#import "QYSDK.h"

@interface  QBMHomeVC()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView     * tbvMain;
@property (nonatomic, strong) HomepageContentCell *contentCell;
@property (nonatomic, strong) NSDictionary *homeData; /**< 属性用来防止请求到同样的数据还需要刷新界面 */
@property (nonatomic, strong) UIBarButtonItem * newsBtn;/**界面右上角消息中心按钮*/
@property (nonatomic, strong) HomeRequest     * request;/**数据请求对象*/
//@property (nonatomic, strong) ActivityHeaderView * activityHeaderView;
@property (nonatomic, strong) FeeDetailPresentationAnimation *presentationAnimation;
@property (nonatomic,strong)ZLImageViewDisplayView *imageViewDisplay;//轮播图对象
@property (nonatomic,strong) UIView *vHeader;//tableviewHeaderView
@property (nonatomic,strong) UIButton *button;//message  btn

@property (nonatomic,strong) UIButton *floatingButton;
@property (nonatomic,strong) LSFloatingActionMenu *floatingMenu;

@property (nonatomic,strong) MeRequest *meRequest;
@property (nonatomic,strong) MeModel *meModel;

@property (nonatomic,assign) BOOL hasAlertAd;
@property (nonatomic,assign) BOOL toImproveMoney;
@property (nonatomic,assign) NSInteger alert_type;
@property (nonatomic,copy) NSString *tcUrl;
@property (nonatomic,copy) NSString *shopUrl;
@property (nonatomic,assign) NSInteger isForce; // 1 强制更新
@property(nonatomic,copy) NSString *updateContent; //更新内容
@property (nonatomic,copy) NSString *updateUrl; //更新链接

@property (nonatomic,strong) UpdateVersionView *updateView;

@property (nonatomic, assign)BOOL isNeedUpdate; ///< 是否需要更新


@end

@implementation QBMHomeVC

#pragma mark - VC生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [MobClick beginLogPageView:@"首页"];
    [self loadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GraduationView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutApp) name:@"logoutApp" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVersion) name:@"isUpdate" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if (self.isNeedUpdate) {
        [self updateVersion];
    }
}

- (void)logoutApp{
    self.floatingButton.hidden = YES;
}

- (void)loginSuccess{
    self.floatingButton.hidden = NO;
    [self saveUserClientInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    
    [self umengEvent:UmengEvent_Home];
    [self setUpView];
    [self loadData_ads];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self saveUserClientInfo];
    });
    
    //版本更新接口
    [self updateVersion];
}
- (void)updateVersion{
    NSDictionary *param = @{@"appVersion":CurrentAppVersion,@"clientType":@"ios"};
    [[[BaseRequest alloc]init]doHttpWithUrl:[NSString stringWithFormat:@"%@%@", Url_Server, kCheckVersion] andMetohd:kHttpRequestPost andParameters:param andHeaders:nil withSuccessHandler:^(id responseObject, NSInteger statusCode) {
        
        if ([responseObject[@"code"]integerValue] == 0) {
            if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                //更新
                _isForce = [responseObject[@"data"][@"forceType"]integerValue];
                _updateContent = responseObject[@"data"][@"content"];
                _updateUrl = responseObject[@"data"][@"appUrl"];
                [[UIApplication sharedApplication].keyWindow addSubview:self.updateView];
                [self.updateView showUpdateAlert];
                if (self.isForce == 1) {
                    self.isNeedUpdate = YES;
                }
            }else{
                //不更新
                self.isNeedUpdate = NO;
            }
        }
       
        
    } andFailHandler:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        
    }];
}

- (UpdateVersionView *)updateView{
    __weak typeof (self) weakSelf = self;
    if (!_updateView) {
        _updateView = [[UpdateVersionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) updateType:_isForce updateContent:_updateContent];
        _updateView.updateblock = ^{
            [weakSelf nowUpdateVersion];
        };
    }
    return _updateView;
}

- (void)nowUpdateVersion{
    //链接可以打开 此时跳转链接并隐藏弹框
    [self.updateView dissmissUpdateAlert];
    if (_updateUrl.length) {
        CommonWebVC * vc = [[CommonWebVC alloc] init];
        vc.strAbsoluteUrl = _updateUrl;
        vc.from = @"home";
        [self dsPushViewController:vc animated:YES];
    }else{
        [self showMessage:@"更新链接不可用"];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [MobClick endLogPageView:@"首页"];
//    if ([UserManager sharedUserManager].isLogin&&[[UserDefaults objectForKey:@"Setp"]isEqualToString:@"1"]) {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
}


- (void)saveUserClientInfo{
    if (![[MyHandle shareHandle].clientId length]) {
        [MyHandle shareHandle].clientId =  [[NSUserDefaults standardUserDefaults]objectForKey:@"ClientId"];
        if (![MyHandle shareHandle].clientId.length) {
            return;
        }
    }
    [self.request updateCliendIdWithDic:@{@"clientId":[MyHandle shareHandle].clientId} success:^(NSDictionary *dictResult) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isSaveClientId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } failed:^(NSInteger code, NSString *errorMsg) {
    }];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

/**
 更新UI约束
 */
- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.tbvMain.translatesAutoresizingMaskIntoConstraints) {
        
        [self.tbvMain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

/**
 收到内存警告
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View创建与设置
- (void)setUpView {
    self.navigationItem.title = APP_NAME;
    [self baseSetup:PageGobackTypeNone];
    
    //创建视图等
    self.navigationItem.rightBarButtonItem = self.newsBtn;
    [self.view addSubview:self.tbvMain];
    [self.view updateConstraintsIfNeeded];
}


#pragma mark - UITableView DataSource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    //0 == section ? 1 : self.contentCell.entity.activities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return  self.contentCell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.contentCell.contentHeight ;//0 == indexPath.section ? self.contentCell.contentHeight : (SCREEN_WIDTH/(75.0/34) - [self increasedBottomHeightOfActivityRow:indexPath]);;
}

#pragma mark - 首页广告数据 -
- (void)loadData_ads {
    
    __weak typeof(self) weakSelf = self;
    [self.request getHomeAdsWithDict:nil success:^(NSDictionary *dictResult) {//type 0显示 其他不显示人脸识别的弹窗
        if([dictResult[@"type"] isEqualToString:@"0"]){
            _tcUrl = dictResult[@"tcUrl"];
            
            if (_toImproveMoney) {
                if (!_tcUrl.length) {
                    _tcUrl = _shopUrl;
                }
            }
            
            if (!_tcUrl.length) {
                return ;
            }
            
            if (_toImproveMoney) {
                _toImproveMoney = FALSE;
                
                NoticeView * vNotice = [[NoticeView alloc] init];
                vNotice.nBlock = ^() {
                    [self umengEvent:UmengEvent_Lend_Increase_Limit_Click];
                    [weakSelf gotoWeb];
                };
                [vNotice showWithPic:dictResult[@"tcImage"] withType:adsAlert];
                
                if (_alert_type == 2) {
                    [self umengEvent:UmengEvent_Lend_Increase_Limit_Auto];
//                    [NSTimer scheduledTimerWithTimeInterval:0.8f target:weakSelf selector:@selector(gotoWeb) userInfo:nil repeats:NO];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self gotoWeb];
                        [vNotice dismiss];
                    });

                }
                
                _alert_type = 0;
            } else {
                if (![[UserDefaults objectForKey:@"adUrl"] isEqualToString:dictResult[@"tcImage"]]) {
                    [UserDefaults setObject:dictResult[@"tcImage"] forKey:@"adUrl"];
                    
                    NoticeView * vNotice = [[NoticeView alloc] init];
                    vNotice.nBlock = ^() {
                        [self umengEvent:UmengEvent_Lend_Increase_Limit_Click];
                        [weakSelf gotoWeb];
                    };
                    [vNotice showWithPic:dictResult[@"tcImage"] withType:adsAlert];
                }
            }
        }
    } failed:^(NSInteger code, NSString *errorMsg) {
    
    }];
}

- (void) gotoWeb{
//    if (_tcUrl) {
//        _tcUrl = kSouyijieURL;
//    }
    CommonWebVC * vc = [[CommonWebVC alloc] init];
    vc.strAbsoluteUrl = _tcUrl;
    [self dsPushViewController:vc animated:YES];
}

#pragma mark -首页数据加载 处理-
- (void)loadData {
    [self showLoading:@""];
    __weak typeof(self) weakSelf = self;
    [self.request getHomeDataWithDict:nil onSuccess:^(NSDictionary *dictResult) {
        
        NSLog(@"首页数据---首页数据---%@",dictResult);
        
        _shopUrl = dictResult[@"item"][@"shop_url"];
        NSMutableArray *arrayImg = [[NSMutableArray alloc]init];
        NSMutableArray *arrayImgUrl = [[NSMutableArray alloc]init];
        [_imageViewDisplay removeFromSuperview];
        [_button removeFromSuperview];
        [weakSelf.tbvMain.mj_header endRefreshing];
        [weakSelf hideLoading];
        weakSelf.homeData = dictResult;
        for(NSDictionary *dic in dictResult[@"index_images"]){
            [arrayImg addObject:dic[@"url"]];
            [arrayImgUrl addObject:dic[@"reurl"]];
        }
        //初始化控件
        if (arrayImg.count == 0) {
            [arrayImg addObject:@"1"];
        }
        weakSelf.imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,150*WIDTHRADIUS) WithImages:arrayImg];
        //设定轮播时间
        weakSelf.imageViewDisplay.scrollInterval = 2;
        
        //图片滚动的时间
        weakSelf.imageViewDisplay.animationInterVale = 0.6;
        
        //把该视图添加到相应的父视图上
        [_vHeader addSubview:weakSelf.imageViewDisplay];
        _button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-27-15,25, 27, 27)];
        [_button setBackgroundImage:ImageNamed(@"home_news") forState:UIControlStateNormal];
        [_button addTarget:weakSelf action:@selector(goNews) forControlEvents:UIControlEventTouchUpInside];
        [_vHeader addSubview:_button];
        [weakSelf.imageViewDisplay addTapEventForImageWithBlock:^(NSInteger imageIndex) {
            if (imageIndex-1<arrayImgUrl.count&&arrayImgUrl.count!=0) {
                NSString *url = arrayImgUrl[imageIndex-1];
                [weakSelf umengEvent:UmengEvent_Home_Banner];
                [weakSelf jumpToWebViewWithUrl:url];
            }
         }];
        
        if (dictResult[@"item"][@"loan_infos"][@"loanEndTime"]) {
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"repayDate"] isEqualToString:dictResult[@"item"][@"loan_infos"][@"loanEndTime"]] || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"intoMoney"] isEqualToString:dictResult[@"item"][@"loan_infos"][@"intoMoney"]]) {
                
                if ([EventCalendar checkEventStoreAccessForCalendarOrNotDetermined]) {
                    
                    [weakSelf loadUserBorrowMoneyData:dictResult[@"item"][@"loan_infos"]];
                }else{
                    [weakSelf openCalendar];
                }
            }
        }
        
        if (dictResult[@"item"][@"risk_status"] && [dictResult[@"item"][@"risk_status"] isEqualToString:@"1"]) {
            if (!_hasAlertAd) {
                _hasAlertAd = TRUE;
                
                [NSTimer scheduledTimerWithTimeInterval:0.8f target:weakSelf selector:@selector(getAad) userInfo:nil repeats:NO];
            }
        }
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [weakSelf showMessage:errorMsg];
        [weakSelf hideLoading];
        [weakSelf.tbvMain.mj_header endRefreshing];
        NSMutableArray *arrayImg = [[NSMutableArray alloc]init];
        NSMutableArray *arrayImgUrl = [[NSMutableArray alloc]init];
        [_imageViewDisplay removeFromSuperview];
        [_button removeFromSuperview];
        //初始化控件
        if (arrayImg.count == 0) {
            [arrayImg addObject:@"1"];
        }
        weakSelf.imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,150*WIDTHRADIUS) WithImages:arrayImg];
        //设定轮播时间
        weakSelf.imageViewDisplay.scrollInterval = 2;
        //图片滚动的时间
        weakSelf.imageViewDisplay.animationInterVale = 0.6;
        //把该视图添加到相应的父视图上
        [_vHeader addSubview:weakSelf.imageViewDisplay];
        _button =[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-27-15,25, 27, 27)];
        [_button setBackgroundImage:ImageNamed(@"home_news") forState:UIControlStateNormal];
        [_button addTarget:weakSelf action:@selector(goNews) forControlEvents:UIControlEventTouchUpInside];
        [_vHeader addSubview:_button];
        [weakSelf.imageViewDisplay addTapEventForImageWithBlock:^(NSInteger imageIndex) {
            if (imageIndex-1<arrayImgUrl.count&&arrayImgUrl.count!=0) {
                [weakSelf jumpToWebViewWithUrl:arrayImgUrl[imageIndex-1]];
            }
            
        }];
    }];
    
    [self getCallMeInfo];
}

- (void) getAad{
    if ([self.homeData[@"item"][@"alter_type"] isEqualToString:@"1"]) {
        //弹出广告
        _toImproveMoney = TRUE;
        _alert_type = 1;
        [self loadData_ads];
    } else if ([self.homeData[@"item"][@"alter_type"] isEqualToString:@"2"]){
        _toImproveMoney = TRUE;
        _alert_type = 2;
        [self loadData_ads];
    }
}

#pragma mark - 懒加载数据model -
- (MeRequest *) meRequest{
    
    if (!_meRequest) {
        _meRequest = [[MeRequest alloc] init];
    }
    
    return _meRequest;
}

#pragma mark - 数据请求和处理 -
- (void) getCallMeInfo{
    if ([UserManager sharedUserManager].isLogin && !_meModel) {
        __weak typeof(self) weakSelf = self;
        [self.meRequest getUserInfoWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
            _meModel = [MeModel yy_modelWithDictionary:dictResult[@"item"]];
            [weakSelf showMenu];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [weakSelf showMenu];
        }];
    }else{
        [self showMenu];
    }
}

- (void) showMenu{
    if ([UserManager sharedUserManager].isLogin && _meModel) {
        [self.view addSubview:self.floatingButton];
        [self.floatingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(70, 70));
            make.left.equalTo(self.view.mas_left).with.offset(5);
        }];
    } else {
        [self.floatingButton removeFromSuperview];
    }
}

/**
 加载显示用户借款、还款信息

 @param dict 加载数据接口中返回用户借款、还款信息
 */
- (void)loadUserBorrowMoneyData:(NSDictionary *)dict{
    
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"loanEndTime"] forKey:@"repayDate"];
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"intoMoney"] forKey:@"intoMoney"];
    NSArray *dataArray = @[@{@"repaymentDate":dict[@"loanEndTime"],@"borrowMoney":dict[@"intoMoney"]}];
    EventCalendar *calendar = [EventCalendar sharedEventCalendar];
    
    if (dataArray.count >0 ){
        
        for (NSInteger i=0; i<dataArray.count; i++) {
            
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            
            [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
            
            NSDate *date = [dateFormat dateFromString:[dataArray[i] objectForKey:@"repaymentDate"]];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSInteger interval = [zone secondsFromGMTForDate: date];
            NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
            //取出日期中的月份和日期
            [dateFormat setDateFormat:@"MM"];
            NSInteger currentMonth=[[dateFormat stringFromDate:localeDate]integerValue];
            [dateFormat setDateFormat:@"dd"];
            NSInteger currentDay=[[dateFormat stringFromDate:localeDate] integerValue];
            //[NSDate dateWithTimeInterval:360000 sinceDate:localeDate]
            
            [calendar loadEventstartDate:[NSDate dateWithTimeInterval:7200 sinceDate:localeDate]  endDate:[NSDate dateWithTimeInterval:43200 sinceDate:localeDate]];
            [calendar createEventCalendarTitle:@"信合宝还款提醒" location:[NSString stringWithFormat:@"明日%ld月%ld日  信合宝 还款%@元(如已提前还款请忽略)",currentMonth,currentDay,[dataArray[i] objectForKey:@"borrowMoney"]] startDate:[NSDate dateWithTimeInterval:7200 sinceDate:localeDate] endDate:[NSDate dateWithTimeInterval:43200 sinceDate:localeDate] allDay:NO alarmArray:@[@"-86400"] ];
        }
    }
}
#pragma mark --  日历模块
- (void)openCalendar{
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"申请成功,开启日历还款提醒,不再忘记还钱,更快提高额度" leftButtonTitle:@"不允许" rightButtonTitle:@"允许"];
    alert.rightBlock = ^{
        
        [[ApplicationUtil sharedApplicationUtil] gotoSettings];
    };
    [alert show];
    return;
}

#pragma mark - Private
- (void)jumpToWebViewWithUrl:(NSString *)webUrl {
    
    CommonWebVC * vc = [[CommonWebVC alloc] init];
    vc.strAbsoluteUrl = webUrl;
    [self dsPushViewController:vc animated:YES];
}
#pragma  mark -cell点击事件block回调处理方法-
- (void)applyWitParam:(NSDictionary *)param {
    [self umengEvent:UmengEvent_Home_Lend];
    
    if ([[UserManager sharedUserManager] checkLogin:self]) {
        
        if ([param[@"money"] integerValue] <= 0) {
            [self showMessage:@"借款额度为0,暂不可借款"];
            return;
        }
        
        if (1 == [self.contentCell.entity.item.verify_loan_pass integerValue]) {
            
            [self showLoading:@""];
            @Weak(self)
#pragma mark  - 用户点击我要借款按钮 -
            [self.request userApplyBorrowWithDictionary:param success:^(NSDictionary *dictResult) {
                @Strong(self)
                
                [self hideLoading];
                [UserManager sharedUserManager].countDownStateOfLoan = NO;
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"NextBorrowCalendar"];
//                [self.navigationController pushViewController:[[ApplyForLoanVC alloc] initWithBorrowInfo:dictResult[@"item"]] animated:YES];
                
                
                //新 添加参数
                [self umengEvent:UmengEvent_Lend_Btn_To_Lend];
                [self.navigationController pushViewController:[[ApplyForLoanVC alloc] initWithBorrowInfo:dictResult[@"item"] dicParam:param] animated:YES];
            } failed:^(NSInteger code, NSString *errorMsg) {
                @Strong(self)
                
                [self hideLoading];
                if (200 == code) {
                    [[[DXAlertView alloc] initWithTitle:nil contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"] show];
                } else {
                    [self showMessage:errorMsg];
                }
            }];
            
        } else {
            //跳转至认证中心
            [self umengEvent:UmengEvent_Lend_Btn_To_Verify];
            [self.navigationController pushViewController:[[VerifyListVC alloc] init] animated:YES];
        }
    }else{
        
        [self umengEvent:UmengEvent_Lend_Btn_To_Login];
    }
}

- (void)cancelRejectStateWithParam:(NSDictionary *)param {
    
    [self showLoading:@""];
    [self.request cancenUserBorrowFailureWithDictionary:param success:^(NSDictionary *dictResult) {
        [self hideLoading];
        [self loadData];
        
    } failed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
}

- (void)checkBorrowFeeWithParam:(NSDictionary *)param {
    
    [self showLoading:@""];
    [self.request fetchServiceChargeWithDictionary:@{@"moneyAmount":param[@"money"], @"loanTerm":param[@"period"]} success:^(NSDictionary *dictResult) {
        [self hideLoading];
        
        if (0 == dictResult.count) {
            return;
        }
        FeeDetailVC *vc = [[FeeDetailVC alloc] initWithFeeList:(NSArray *)dictResult];
        
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.transitioningDelegate = self.presentationAnimation;
        
        [self.tabBarController presentViewController:vc animated:YES completion:^{
            vc.transitioningDelegate = nil;
        }];
        
    } failed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
}
#pragma mark -前往消息中心-
- (void)goNews {
    [self umengEvent:UmengEvent_Home_Msg];
    CommonWebVC * vc = [[CommonWebVC alloc] init];
    vc.strTitle = @"消息中心";
    vc.strAbsoluteUrl = [NSString stringWithFormat:@"%@%@",Url_Server,@"/content/activity"];
    [self dsPushViewController:vc animated:YES];
}

#pragma mark - 浮动菜单
- (void) handleMenu:(UIButton *) sender {
    [self showMenuFromButton:sender withDirection:LSFloatingActionMenuDirectionDown];
}

- (void)showMenuFromButton:(UIButton *)button withDirection:(LSFloatingActionMenuDirection)direction {
    button.hidden = YES;
    
    NSArray *menuIcons = @[@"menu_service_press", @"ic_phone", @"ic_qq"];
    NSMutableArray *menus = [NSMutableArray array];
    
    CGSize itemSize = button.frame.size;
    for (NSString *icon in menuIcons) {
        LSFloatingActionMenuItem *item = [[LSFloatingActionMenuItem alloc] initWithImage:[UIImage imageNamed:icon] highlightedImage:[UIImage imageNamed:icon]];
        item.itemSize = itemSize;
        [menus addObject:item];
    }
    
    self.floatingMenu = [[LSFloatingActionMenu alloc] initWithFrame:self.view.bounds direction:direction menuItems:menus menuHandler:^(LSFloatingActionMenuItem *item, NSUInteger index) {
        switch (index) {
            case 1:
                [self contectByPhone];//拨打电话
                break;
                
            case 2:
                [self contactQQ];   //联系在线客服
                break;
        }
    } openHandler:^{
        
    } closeHandler:^{
        [self.floatingMenu removeFromSuperview];
        self.floatingMenu = nil;
        button.hidden = NO;
    }];
    
    self.floatingMenu.itemSpacing = 10;
    self.floatingMenu.startPoint = button.center;
    //    self.floatingMenu.rotateStartMenu = YES;//旋转
    
    [self.view addSubview:self.floatingMenu];
    [self.floatingMenu open];
}

-(void)contectByPhone{
    NSMutableString * str = [NSMutableString stringWithFormat:@"tel:%@",self.meModel.service.service_phone];
    UIWebView * callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)contactQQ
{
//    if ( ![QQApiInterface isQQInstalled]) {
//        //没有安装QQ
//        [[[DXAlertView alloc] initWithTitle:@"" contentText:@"跳转异常，请确认是否安装过qq" leftButtonTitle:nil rightButtonTitle:@"确认"] show];
//    }
//
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    // 提供uin, 你所要联系人的QQ号码
//    NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", DSStringValue(self.meModel.service.qq_group) ];
//    NSURL *url = [NSURL URLWithString:qqstr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
//    [self.view addSubview:webView];
    self.title = @"返回";
    [self.floatingMenu close];
    QYSource *source = [[QYSource alloc] init];
    source.title = @"小鱼儿";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"小鱼儿客服";
    sessionViewController.source = source;
    sessionViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionViewController animated:YES];
    
    //            UserModel *userModel =  [[KDCacheManager sharedCacheManager] getCacheObjectWithKey:LoginUser];
    //            if (userModel.username.length==11) {
    //                QYUserInfo *userInfo = [[QYUserInfo alloc]init];
    //                userInfo.userId = userModel.username;
    //                userInfo.data = [NSString stringWithFormat:@"[{\"key\":\"real_name\", \"value\":\"%@\"}]",userModel.username];
    //                [[QYSDK sharedSDK] setUserInfo:userInfo];
    //            }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"registerQimo" object:nil];
}

#pragma mark - Setter
- (void)setHomeData:(NSDictionary *)homeData {
    
    if ([_homeData isEqualToDictionary:homeData]) {
        return;
    }
    _homeData = homeData;
    
    self.contentCell.entity = [[HomeModel alloc] initWithDict:homeData];
    self.tbvMain.tableFooterView.hidden = NO;
    [self.tbvMain reloadData];
    [self.contentCell performSelector:@selector(sliderAnimation) withObject:nil afterDelay:0.25f];
}

#pragma mark - Getter  懒加载
- (UITableView *)tbvMain {
    if (!_tbvMain) {
        _tbvMain = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        if (@available(iOS 11.0, *)) {
            _tbvMain.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tbvMain.backgroundColor = [UIColor colorWithHex:0xf2f1f1];
        _tbvMain.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbvMain.sectionFooterHeight = 0;
        _tbvMain.showsVerticalScrollIndicator = NO;
        _tbvMain.dataSource = self;
        _tbvMain.delegate = self;
        _vHeader =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 150 * WIDTHRADIUS)];
        _tbvMain.tableHeaderView = _vHeader;
    }
    return _tbvMain;
}

- (UIButton *) floatingButton {
    if (!_floatingButton) {
//        _floatingButton =[[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT/2 - 60, 70, 70)];
        _floatingButton = [[UIButton alloc] init];
        [_floatingButton setBackgroundImage:ImageNamed(@"menu_service") forState:UIControlStateNormal];
        [_floatingButton addTarget:self action:@selector(handleMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _floatingButton;
}

- (HomepageContentCell *)contentCell {
    
    if (!_contentCell) {
        _contentCell = [[HomepageContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HomepageContentCell class])];
        
        _contentCell.frame = self.view.bounds;
        _contentCell.clipsToBounds = NO;
        
        //cell block 点击回调
        @Weak(self)
        _contentCell.clickBlock = ^(kHomepageContentClickType type, NSDictionary *param) {
            @Strong(self)
            
            switch (type) {
                case kHomepageContentClickApplyBorrow: {//点击立即申请
                    [self applyWitParam:param];
                } break;
                case kHomepageContentClickCancelRejectState: {
                    [self cancelRejectStateWithParam:param];
                } break;
                case kHomepageContentClickCheckFee: {//点击服务费用查看按钮
                    [self checkBorrowFeeWithParam:param];
                } break;
                case kHomepageContentClickPromoteCreditLine: {
                    [self jumpToWebViewWithUrl:self.homeData[@"item"][@"shop_url"] ? self.homeData[@"item"][@"shop_url"] : kSouyijieURL];
                } break;
            }
        };
        _contentCell.contentViewDidChangeBlock = ^{
            @Strong(self)
            
            [self.tbvMain reloadData];
        };
    }
    return _contentCell;
}

- (UIBarButtonItem *)newsBtn {
    if (!_newsBtn) {
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:ImageNamed(@"home_news") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goNews) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _newsBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _newsBtn;
}

- (HomeRequest *)request {
    if (!_request) {
        _request = [[HomeRequest alloc] init];
    }
    return _request;
}

//- (ActivityHeaderView *)activityHeaderView {
//    if (!_activityHeaderView) {
//        _activityHeaderView = [[ActivityHeaderView alloc] init];
//    }
//    return _activityHeaderView;
//}

- (FeeDetailPresentationAnimation *)presentationAnimation {
    
    if (!_presentationAnimation) {
        _presentationAnimation = [[FeeDetailPresentationAnimation alloc] init];
    }
    return _presentationAnimation;
}


@end
