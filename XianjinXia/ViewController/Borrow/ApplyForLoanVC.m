//
//  KDBorrowChangeVC.m
//  KDIOSApp
//
//  Created by haoran on 16/5/9.
//  Copyright © 2016年 KDIOSApp. All rights reserved.
//

#import "ApplyForLoanVC.h"

#import "CommonWebVC.h"
#import "SetTradingPasswordVC.h"

#import "UIView+Masonry.h"
#import "UIButton+Masonry.h"
#import "UILabel+Masonry.h"

#import "ApplyForLoanCell.h"
#import "ApplyForLoanCommitView.h"
#import "BankDataEncryptionView.h"

#import "UserManager.h"
#import "ApplyForLoanRequest.h"
#import "KDPayPasswordView.h"
#import "IQKeyboardManager.h"
#import "HomeRequest.h"
#import "FMDeviceManager.h"//同盾设备指纹
//#import "CafintechSecurityForiOS.h"//诚安聚力设备指纹

//#import <AMapFoundationKit/AMapFoundationKit.h>//获取经纬度信息需要高德地图SDK
#import <AMapLocationKit/AMapLocationKit.h>
#import "GDLocationManager.h"



@interface ApplyForLoanVC () <UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) HomeRequest     *updateRequest;
@property (nonatomic, retain) UITableView *tableView;
@property (strong, nonatomic) ApplyForLoanCommitView *footerView;

@property (strong, nonatomic) NSDictionary *borrowInfo;
@property (strong, nonatomic) NSArray *listInfo;

@property (strong, nonatomic) ApplyForLoanRequest *request;

@property (nonatomic, strong) HomeRequest     * requestHome;

@property (nonatomic, strong) NSString * tongDunDeviceInfo;

@property (nonatomic, assign) int status;

@property (nonatomic, assign) BOOL isErr;

//@property (nonatomic,strong) NSString * chengAnJuLiDeviceInfo;//诚安聚力设备指纹
//@property (nonatomic,strong) AMapLocationManager * locationManager;

@end

@implementation ApplyForLoanVC

#pragma mark - Life Cycle
- (instancetype)initWithBorrowInfo:(NSDictionary *)borrowInfo {
    
    if (self = [super init]) {
        _borrowInfo = borrowInfo;
        _listInfo = [self createBorrowListInfo];
    }
    return self;
}

- (instancetype)initWithBorrowInfo:(NSDictionary *)borrowInfo dicParam:(NSDictionary *)dicParam {
    
    if (self = [super init]) {
        _dicParam = dicParam;
        _borrowInfo = borrowInfo;
        _listInfo = [self createBorrowListInfo];
    }
    return self;
}
#pragma mark -获取同盾设备指纹-
-(void)gettongDunDeviceInfo{

    if (!_tongDunDeviceInfo) {
        FMDeviceManager_t * manager = [FMDeviceManager sharedManager];
        _tongDunDeviceInfo = manager->getDeviceInfo();
    }
}
//诚安聚力设备指纹
//-(void)getChengAnJuLiDeviceInfoWith:(CLLocation *)location {
//
//    CLLocationDegrees latitude = location.coordinate.latitude;//维度
//    CLLocationDegrees longitude = location.coordinate.longitude;//经度
//    
//    CafintechSecurityForiOS *cafintechSecurity = [[CafintechSecurityForiOS alloc] init];
//    
//    self.chengAnJuLiDeviceInfo = [cafintechSecurity getPhoneInfoWithJsonStringLongitude:[NSString stringWithFormat:@"%f",longitude] Latitude:[NSString stringWithFormat:@"%f",latitude]];
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
    self.navigationItem.title = @"借款";
    [self baseSetup:PageGobackTypePop];

    self.footerView.tipString = self.borrowInfo[@"tips"];
    self.tableView.tableFooterView = self.footerView;
    [self.view addSubview:self.tableView];
    [self.view updateConstraintsIfNeeded];
    
    //同盾设备指纹
    [self gettongDunDeviceInfo];
    
}
#pragma mark -诚安聚力设备指纹的获取-
//-(void)getAdressInfo{
//
//    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
//    self.locationManager = [[AMapLocationManager alloc]init];
//    // 带逆地理信息的一次定位（返回坐标和地址信息）
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//    // 定位超时时间，最低2s，此处设置为2s
//    self.locationManager.locationTimeout =2;
//
//    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
//    __weak typeof(self) weakSelf = self;
//    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//        if (error)
//        {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//            [weakSelf showMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
//            //error.code == AMapLocationErrorLocateFailed
//            return;
//        }
//        NSLog(@"location:%@", location);
//        [weakSelf getChengAnJuLiDeviceInfoWith:location];//拿到地理位置信息之后获取诚安聚力设备指纹
//    }];
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self refreshBankInfo];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.tableView.translatesAutoresizingMaskIntoConstraints) {
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
        }];
    }
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listInfo.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *result = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 10)];
    result.backgroundColor = [UIColor clearColor];
    return result;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ApplyForLoanCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ApplyForLoanCell class]) forIndexPath:indexPath];
    
    [cell configureApplyForCellWithDictionary:self.listInfo[indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {//绑定银行卡
        NSString * url = self.borrowInfo[@"firstUserBank_url"];
        if ([url rangeOfString:@"www.bindcardinfo.com"].location != NSNotFound) {
            [self umengEvent:UmengEvent_Lend_Bank_No_Bind];
        }else{
            [self umengEvent:UmengEvent_Lend_Bank_Bind];
        }
        CommonWebVC *bankcardWeb = [[CommonWebVC alloc] init];
        bankcardWeb.strAbsoluteUrl =url;
        [self dsPushViewController:bankcardWeb animated:YES];
        
        bankcardWeb.bindBankcardSuccess = ^{
//            [self updateBorrowInfo];
            [self refreshBankInfo];
        };
    }
    
    if (self.listInfo.count > 5 && indexPath.row == 5) {//签署合同
        CommonWebVC *agreementWeb = [[CommonWebVC alloc] init];
        agreementWeb.strAbsoluteUrl = self.borrowInfo[@"sign_and_view_url"];
        [self dsPushViewController:agreementWeb animated:YES];
        
        agreementWeb.getAgreementStatus = ^{
            [self refreshAgreementStatus];
        };
        
        agreementWeb.isAgreementSignErr = ^{
            self.isErr = TRUE;
            [self refreshBtnEnable];
        };
    }
}

#pragma mark - Private
- (NSArray *)createBorrowListInfo {
    
    id bankStr;
    if (0 == [self.borrowInfo[@"bank_name"] length]) {
        NSMutableAttributedString *mutAtt = [[NSMutableAttributedString alloc] initWithString:@"未绑卡" attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHex:0xFD9F41]}];
        bankStr = mutAtt;
    } else {
        bankStr = [NSString stringWithFormat:@"%@(%@)", self.borrowInfo[@"bank_name"], self.borrowInfo[@"card_no_lastFour"]];
    }
    
    NSNumber *isShow = [self.borrowInfo objectForKey:@"is_show_cfca"];
    int isShowCfca = [isShow intValue];
    
    NSString *sign_url = [self.borrowInfo objectForKey:@"sign_and_view_url"];
    
    if (0 == isShowCfca && ![self isBlankString:sign_url]) {
        id agreementStatus;
        if (2 == self.status) {
            NSMutableAttributedString *mutAtt = [[NSMutableAttributedString alloc] initWithString:@"已签署" attributes:@{ NSForegroundColorAttributeName:Color_Red_New}];
            agreementStatus = mutAtt;
        } else {
            NSMutableAttributedString *mutAtt = [[NSMutableAttributedString alloc] initWithString:@"未签署" attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithHex:0xFD9F41]}];
            agreementStatus = mutAtt;
        }
        
        return @[@{@"title":@"借款金额",@"content":self.borrowInfo[@"money"],@"status":@"（元）"},
                 @{@"title":@"借款期限",@"content":self.borrowInfo[@"period"],@"status":@"（天）"},
                 @{@"title":@"实际到账",@"content":self.borrowInfo[@"true_money"],@"status":@"（元）"},
                 @{@"title":@"服务费用",@"content":self.borrowInfo[@"counter_fee"],@"status":@"（元）"},
                 @{@"title":@"到账银行",@"content":bankStr,@"showDetail":@(true)},
                 @{@"title":@"合同签署",@"content":agreementStatus,@"showDetail":@(true)}];
    }

    return @[@{@"title":@"借款金额",@"content":self.borrowInfo[@"money"],@"status":@"（元）"},
             @{@"title":@"借款期限",@"content":self.borrowInfo[@"period"],@"status":@"（天）"},
             @{@"title":@"实际到账",@"content":self.borrowInfo[@"true_money"],@"status":@"（元）"},
             @{@"title":@"服务费用",@"content":self.borrowInfo[@"counter_fee"],@"status":@"（元）"},
             @{@"title":@"到账银行",@"content":bankStr,@"showDetail":@(true)}];
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//申请借款
- (void)applyBorrow {
    
    if ([self needSettingTradePassword]) {//是否设置交易密码
        [self intoSettingTradePassword];
        return;
    }
    
    @Weak(self)
    [self inputTradePasswordWithComplete:^(NSString *password) {
        @Strong(self)
        
        NSString *contract_id = [self.borrowInfo objectForKey:@"contract_id"] ? self.borrowInfo[@"contract_id"] : @"";
        
        [self.request confirmUserBorrowWithDictionary:@{@"money":self.borrowInfo[@"money"], @"period":self.borrowInfo[@"period"], @"pay_password":DSStringValue(password),@"td_device":self.tongDunDeviceInfo,@"contract_id":contract_id} success:^(NSDictionary *dictResult) {
            @Strong(self)
            
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"申请成功" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            [alert show];
        } failed:^(NSInteger code, NSString *errorMsg) {
            @Strong(self)
            
            if (200 == code) {
                [[[DXAlertView alloc]initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"] show];
            } else {
                [self showMessage:errorMsg];
            }
        }];
    }];
}

/**
 判断是否设置交易密码

 @return 返回是否需要设置交易密码
 */
- (BOOL)needSettingTradePassword {
    
    return (1 != [self.borrowInfo[@"real_pay_pwd_status"] integerValue]) && (1 != [[UserManager sharedUserManager].userInfo.real_pay_pwd_status integerValue]);
}
- (void)intoSettingTradePassword {
    
    SetTradingPasswordVC *vc = [[SetTradingPasswordVC alloc]initWithType:KDSetPayPassword];
    vc.controllIndex = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)inputTradePasswordWithComplete:(void(^)(NSString *password))complete {
    
    KDPayPasswordView *pay = [[KDPayPasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds type:borrow];
    pay.payMoneyNum = self.borrowInfo[@"money"];
    pay.bankInfoStr = self.borrowInfo[@"bank_name"];
    [pay refreshUI];
    [self.view addSubview:pay];
    
    pay.allPasswordPut = ^(NSString *password) {
        !complete ? : complete(password);
    };
}


#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        [_tableView registerClass:[ApplyForLoanCell class] forCellReuseIdentifier:NSStringFromClass([ApplyForLoanCell class])];
        _tableView.backgroundColor = Color_Background;
        _tableView.separatorColor = Color_LineColor;
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.rowHeight = 50.f;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (ApplyForLoanCommitView *)footerView {
    
    if (!_footerView) {
        _footerView = [ApplyForLoanCommitView applyForLoanCommitView];
        
        _footerView.protocolArray = @[ DSStringValue(self.borrowInfo[@"protocol_url"]), DSStringValue(self.borrowInfo[@"platformservice_url"])];
        
        @Weak(self)
        _footerView.clickCommitBlock = ^{
            @Strong(self)
            [self umengEvent:UmengEvent_Lend_Confirm];
            [self applyBorrow];
        };
        
        _footerView.checkProtocolBlock  = ^(NSString *url){
            @Strong(self)
            
            CommonWebVC * vc = [[CommonWebVC alloc] init];
            vc.strAbsoluteUrl = url; //;
            [self dsPushViewController:vc animated:YES];
        };
        
        _footerView.checkBlock = ^{
            @Strong(self)
            
            [self refreshBtnEnable];
        };
        
        BankDataEncryptionView *view = [BankDataEncryptionView bankDataEncryptionView];
        [self refreshBtnEnable];
        [_footerView addSubview:view];
        view.frame = CGRectMake(0, CGRectGetHeight(_footerView.bounds), SCREEN_WIDTH, 40);
    }
    return _footerView;
}
- (ApplyForLoanRequest *)request {
    
    if (!_request) {
        _request = [[ApplyForLoanRequest alloc] init];
    }
    return _request;
}

- (HomeRequest *)requestHome {
    if (!_requestHome) {
        _requestHome = [[HomeRequest alloc] init];
    }
    return _requestHome;
}

/**
 *  刷新按钮状态
 */
- (void)refreshBtnEnable{
    if (self.listInfo.count > 5) {
        self.footerView.enableOfApplyButton = (0 != [self.borrowInfo[@"bank_name"] length]) && (self.footerView.checked) && (self.status == 2 || (self.status != 2 && self.isErr));
    } else {
        self.footerView.enableOfApplyButton = (0 != [self.borrowInfo[@"bank_name"] length]) && (self.footerView.checked);
    }
}

/**
 刷新银行卡信息
 */
- (void)refreshBankInfo{
    [self showLoading:@""];
    @Weak(self)
    [self.requestHome userApplyBorrowWithDictionary:_dicParam  success:^(NSDictionary *dictResult) {
        @Strong(self)
        
        [self hideLoading];
        
        self.borrowInfo = dictResult[@"item"];
        [self refreshBtnEnable];
        self.listInfo = [self createBorrowListInfo];
        [self.tableView reloadData];
    } failed:^(NSInteger code, NSString *errorMsg) {
        @Strong(self)
        
        [self hideLoading];
        if (200 == code) {
            [[[DXAlertView alloc] initWithTitle:nil contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"] show];
        } else {
            [self showMessage:errorMsg];
        }
    }];
    
}

/**
 * 获取合同签署状态
 */
- (void) refreshAgreementStatus {
    [self showLoading:@"获取签署状态"];
    
    @Weak(self)
    [self.request getAgreementStatus:@{@"contract_id":self.borrowInfo[@"contract_id"]} success:^(NSDictionary *dictResult) {
        @Strong(self)
        [self hideLoading];
        
        NSNumber *nStatus = [dictResult objectForKey:@"status"];
        self.status = [nStatus intValue];
        [self refreshBtnEnable];
        
        self.listInfo = [self createBorrowListInfo];
        [self.tableView reloadData];
        
    } failed:^(NSInteger code, NSString *errorMsg) {
        @Strong(self)
        
        [self hideLoading];
        if (200 == code) {
            [[[DXAlertView alloc]initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"] show];
        } else {
            [self showMessage:errorMsg];
        }
    }];
    
}



@end
