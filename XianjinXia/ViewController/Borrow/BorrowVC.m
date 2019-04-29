//
//  BorrowVC.m
//  XianjinXia
//
//  Created by lxw on 17/1/23.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BorrowVC.h"

#import "VerifyListVC.h"
#import "CommonWebVC.h"
#import "ApplyForLoanVC.h"
#import "FeeDetailVC.h"

#import "HomeRequest.h"
#import "HomeModel.h"
#import "UIColor+Extensions.h"
#import <MJRefresh.h>
#import "ActivityHeaderView.h"
#import "HomeActivityCell.h"
#import "UIButton+LoadImage.h"
#import "DSUtils.h"
#import "UserManager.h"
#import "HomepageContentCell.h"
#import <UMMobClick/MobClick.h>
#import "EventCalendar.h"
#import "NoticeView.h"

@interface BorrowVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView     * tbvMain;
@property (nonatomic, strong) HomepageContentCell *contentCell;
@property (nonatomic, strong) NSDictionary *homeData; /**< 属性用来防止请求到同样的数据还需要刷新界面 */

@property (nonatomic, strong) UIBarButtonItem * newsBtn;
@property (nonatomic, strong) HomeRequest     * request;
@property (nonatomic, strong) ActivityHeaderView * activityHeaderView;

@property (nonatomic, strong) FeeDetailPresentationAnimation *presentationAnimation;

@end

@implementation BorrowVC
#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self umengEvent:UmengEvent_Home];
    [self setUpView];
}
- (void)updateViewConstraints {
    
    [super updateViewConstraints];
    
    if (self.tbvMain.translatesAutoresizingMaskIntoConstraints) {
        
        [self.tbvMain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:@"首页"];
    [self loadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"首页"];
}

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

#pragma mark - Delegate
#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contentCell.entity ? (0 == self.contentCell.entity.activities.count ? 1 : 2) : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0 == section ? 1 : self.contentCell.entity.activities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1 == section ? 35 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        HomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeActivityCell class])];
        
        if (!cell) {
            cell = [[HomeActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HomeActivityCell class])];
        }
        cell.bottomCon = [self increasedBottomHeightOfActivityRow:indexPath];
        [cell.apactivityImage loadBackgroundImageWithImagePath:[self.contentCell.entity.activities[indexPath.row] url]];
        
        @Weak(self)
        cell.clickImageBlock = ^{
            @Strong(self)
            [self jumpToWebViewWithUrl:self.contentCell.entity.activities[indexPath.row].reurl];
        };
        return cell;
    } else {
        return  self.contentCell;
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 0 == indexPath.section ? self.contentCell.contentHeight : (SCREEN_WIDTH/(75.0/34) - [self increasedBottomHeightOfActivityRow:indexPath]);;
}
- (NSInteger)increasedBottomHeightOfActivityRow:(NSIndexPath *)indexPath {
    
    return indexPath.row == ( self.contentCell.entity.activities.count - 1 ) ? -10 : 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  1 == section ? self.activityHeaderView : nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tbvMain) {
        [self.contentCell scrollViewContentOffsetDidChange:scrollView.contentOffset];
    }
}

#pragma mark - 请求数据
- (void)loadData {
    [self showLoading:@""];
    [self.request getHomeAdsWithDict:nil success:^(NSDictionary *dictResult) {
        if (![[UserDefaults objectForKey:@"adUrl"] isEqualToString:dictResult[@"tcImage"]]) {
            [UserDefaults setObject:dictResult[@"tcImage"] forKey:@"adUrl"];
            NoticeView * vNotice = [[NoticeView alloc] init];
            __weak __typeof(self)weakSelf = self;
            vNotice.nBlock = ^() {
                CommonWebVC * vc = [[CommonWebVC alloc] init];
                vc.strAbsoluteUrl = dictResult[@"tcUrl"];
                [weakSelf dsPushViewController:vc animated:YES];
            };
            [vNotice showWithPic:dictResult[@"tcImage"] withType:adsAlert];
        }
    } failed:^(NSInteger code, NSString *errorMsg) {
    }];
    [self.request getHomeDataWithDict:nil onSuccess:^(NSDictionary *dictResult) {
        [self.tbvMain.mj_header endRefreshing];
        [self hideLoading];
        self.homeData = dictResult;
        
        if (dictResult[@"item"][@"loan_infos"][@"loanEndTime"]) {
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"repayDate"] isEqualToString:dictResult[@"item"][@"loan_infos"][@"loanEndTime"]] || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"intoMoney"] isEqualToString:dictResult[@"item"][@"loan_infos"][@"intoMoney"]]) {
                
                if ([EventCalendar checkEventStoreAccessForCalendarOrNotDetermined]) {
                    
                    [self loadUserBorrowMoneyData:dictResult[@"item"][@"loan_infos"]];
                }else{
                    [self openCalendar];
                }
            }
        }
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self showMessage:errorMsg];
        [self hideLoading];
        [self.tbvMain.mj_header endRefreshing];
    }];
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

#pragma mark - Private
- (void)jumpToWebViewWithUrl:(NSString *)webUrl {
    
    CommonWebVC * vc = [[CommonWebVC alloc] init];
    vc.strAbsoluteUrl = webUrl;
    [self dsPushViewController:vc animated:YES];
}

- (void)applyWitParam:(NSDictionary *)param {
    
    if ([[UserManager sharedUserManager] checkLogin:self]) {
        
        if ([param[@"money"] integerValue] <= 0) {
            [self showMessage:@"借款额度为0,暂不可借款"];
            return;
        }
        
        if (1 == [self.contentCell.entity.item.verify_loan_pass integerValue]) {
            
            [self showLoading:@""];
            @Weak(self)
            [self.request userApplyBorrowWithDictionary:param success:^(NSDictionary *dictResult) {
                @Strong(self)
                
                [self hideLoading];
                [UserManager sharedUserManager].countDownStateOfLoan = NO;
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"NextBorrowCalendar"];
//                [self.navigationController pushViewController:[[ApplyForLoanVC alloc] initWithBorrowInfo:dictResult[@"item"]] animated:YES];
                //新 添加参数
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
            
            [self.navigationController pushViewController:[[VerifyListVC alloc] init] animated:YES];
        }
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

- (void)goNews {
    
    CommonWebVC * vc = [[CommonWebVC alloc] init];
    vc.strTitle = @"消息中心";
    vc.strAbsoluteUrl = [NSString stringWithFormat:@"%@%@",Url_Server,@"/content/activity"];
    [self dsPushViewController:vc animated:YES];
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

#pragma mark - Getter
- (UITableView *)tbvMain {
    if (!_tbvMain) {
        _tbvMain = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tbvMain.backgroundColor = [UIColor colorWithHex:0xf2f1f1];
        _tbvMain.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbvMain.sectionFooterHeight = 0;
        _tbvMain.showsVerticalScrollIndicator = NO;
        _tbvMain.dataSource = self;
        _tbvMain.delegate = self;
        
        _tbvMain.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 5)];
        footerView.backgroundColor = [UIColor clearColor];
        _tbvMain.tableFooterView = footerView;

        UIImageView *footerShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_shadow"]];
        [footerView addSubview:footerShadow];
        
        [footerShadow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footerView.mas_top);
            make.left.equalTo(footerView.mas_left);
            make.right.equalTo(footerView.mas_right);
        }];
        
        _tbvMain.tableFooterView.hidden = YES;
    }
    return _tbvMain;
}

- (HomepageContentCell *)contentCell {
    
    if (!_contentCell) {
        _contentCell = [[HomepageContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HomepageContentCell class])];
        
        _contentCell.frame = self.view.bounds;
        _contentCell.clipsToBounds = NO;
        
        @Weak(self)
        _contentCell.clickBlock = ^(kHomepageContentClickType type, NSDictionary *param) {
            @Strong(self)
            
            switch (type) {
                case kHomepageContentClickApplyBorrow: {
                    [self applyWitParam:param];
                } break;
                case kHomepageContentClickCancelRejectState: {
                    [self cancelRejectStateWithParam:param];
                } break;
                case kHomepageContentClickCheckFee: {
                    [self checkBorrowFeeWithParam:param];
                } break;
                case kHomepageContentClickPromoteCreditLine: {
                    [self jumpToWebViewWithUrl:kSouyijieURL];
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

- (ActivityHeaderView *)activityHeaderView {
    if (!_activityHeaderView) {
        _activityHeaderView = [[ActivityHeaderView alloc] init];
    }
    return _activityHeaderView;
}

- (FeeDetailPresentationAnimation *)presentationAnimation {
    
    if (!_presentationAnimation) {
        _presentationAnimation = [[FeeDetailPresentationAnimation alloc] init];
    }
    return _presentationAnimation;
}

@end
