//
//  RepayVC.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/18.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "RepayVC.h"
#import "CommonWebVC.h"
#import "RepaymentRequest.h"
#import "RepayFirstCell.h"
#import "RepayCell.h"
#import "RepayHeadView.h"
#import "RepaymentModel.h"
#import "BackTbvCell.h"
#import "CommonWebVC.h"
#import "UserManager.h"
#import "DXAlertView.h"
#import "NoDataView.h"
#import "NoNetReloadView.h"
#import <UMMobClick/MobClick.h>

@interface RepayVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIBarButtonItem   * helpBtn;
@property (nonatomic, strong) UITableView       * tbvMain;
@property (nonatomic, strong) RepaymentRequest  * request;
@property (nonatomic, strong) RepaymentModel    * model;
@property (nonatomic, strong) UITableView       * tbvBack;//还款方式说明列表的tableView
@property (nonatomic, strong) UIView            * backTbvHeader;
@property (nonatomic, strong) UILabel           * backTbvHeaderLbl;
@property (nonatomic, strong) NoDataView        * vNoData;
@property (nonatomic, strong) NoNetReloadView   * vNoNet;

@end

@implementation RepayVC

#pragma mark - VC生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:@"还款"];
    [self getDataSource];
    [self checkLoginStatus];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self umengEvent:UmengEvent_Repay];
    [self setUpDataSource];
    [self setUpView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"还款"];
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
    self.navigationItem.title = @"还款";
    [self baseSetup:PageGobackTypeNone];
    
    //创建视图等
    self.navigationItem.rightBarButtonItem = self.helpBtn;
    [self.view addSubview:self.tbvMain];
    [self.view addSubview:self.vNoData];
    [self.view addSubview:self.vNoNet];
    __weak typeof(self) weakSelf = self;
    _vNoData.btnClick = ^() {
        if ([[UserManager sharedUserManager] checkLogin:weakSelf]) {
            [weakSelf.tbvMain.mj_header beginRefreshing];
        }
    };
    _vNoData.getBorrowBlock = ^() {
        [weakSelf umengEvent:UmengEvent_Repay];
        [UserDefaults setObject:@"1" forKey:@"Setp"];
        weakSelf.tabBarController.selectedIndex = 0;
    };
    _vNoNet.btnClick = ^() {
        [weakSelf getDataSource];
    };
    [self.view updateConstraintsIfNeeded];
}

- (void)creatTbvBack {
    [self.view addSubview:self.tbvBack];
    [self.tbvBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH,((iPhone4 ||iPhone5) ? 40 : 60)*self.model.pay_type.count+41*WIDTHRADIUS));
    }];
    self.tbvBack.scrollEnabled = NO;
    self.backTbvHeaderLbl.text = self.model.pay_title;
}

#pragma mark - 初始化数据源
- (void)setUpDataSource {
}

#pragma mark - 按钮事件
- (void)goHelp {
    CommonWebVC * vc = [[CommonWebVC alloc] init];
    vc.strAbsoluteUrl = [NSString stringWithFormat:@"%@%@",Url_Server,@"/help"];
    //    vc.navTitle = @"客服";
    [self umengEvent:UmengEvent_Repay_help];
    [self dsPushViewController:vc animated:YES];
}

#pragma mark - TableView Delegate Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tbvBack) {
        //return self.model.count ? 0 : self.model.pay_type.count;
        return self.model.pay_type.count;
    }
    return self.model.count ? self.model.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tbvBack) {//暂无数据  !self.model.count &&
        BackTbvCell * cell = [BackTbvCell backTbvCellWithTableView:tableView];
        [cell configCellWithModel:self.model.pay_type[indexPath.row] withIndexPath:indexPath];
        return cell;
    }else {
        if ([[[_model.list[indexPath.row] status] description] isEqualToString:@"-11"] || [[[_model.list[indexPath.row] status] description] isEqualToString:@"-20"]) {
            //        if ([[_model.list[indexPath.row] text_tip] rangeOfString:@"已逾期"].location!=NSNotFound) {
            RepayFirstCell * cell = [RepayFirstCell repayFirstCellWithTableView:tableView];
            [cell configCellWithModel:_model.list[indexPath.row] withIndexPath:indexPath];
            return cell;
        }
        RepayCell * cell = [RepayCell repayCellWithTableView:tableView];
        [cell configCellWithData:_model.list[indexPath.row] withIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommonWebVC * vc = [[CommonWebVC alloc] init];
    
    if (tableView == self.tbvBack) {
        switch (indexPath.row) {
            case 0:
                [self umengEvent:UmengEvent_Repay_Bank];
                break;
                
            case 1:
                [self umengEvent:UmengEvent_Repay_More];
                break;
                
            default:
                break;
        }
        vc.strAbsoluteUrl = [_model.pay_type[indexPath.row] link_url];
    }else{
        vc.strAbsoluteUrl = [_model.list[indexPath.row] url];
        [self umengEvent: UmengEvent_Repay_cellClick];
    }
    //vc.strAbsoluteUrl = _model.list.count ? [_model.list[indexPath.row] url] : [_model.pay_type[indexPath.row] link_url];
    [self dsPushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView != self.tbvBack) {
        RepayHeadView * headView = [[RepayHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30*WIDTHRADIUS)];
        [headView configViewWithModel:self.model withSection:section];
        return headView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (self.model.count == 0) {//当待还款列表为零的时候返回的高度
    //        return (iPhone4 ||iPhone5) ? 40 : 60;
    //    }
    
    if (tableView == self.tbvBack) {
        return (iPhone4 ||iPhone5) ? 40 : 60;
    }
    
    if ([[_model.list[indexPath.row] text_tip] rangeOfString:@"已逾期"].location!=NSNotFound) {
        return 120;
    }
    return 96;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView != self.tbvBack) {
        return self.model.count ? 30*WIDTHRADIUS : 0;
    }
    return 0.001;
}

#pragma mark - 数据请求 处理 -
- (void)getDataSource {
    [self showLoading:@""];
    __weak __typeof(self)weakSelf = self;
    [self.request getLoanDataWithDict:nil onSuccess:^(NSDictionary *dictResult) {//有待还款订单
        [weakSelf hideLoading];
        weakSelf.model = [[RepaymentModel alloc] initWithDict:dictResult[@"item"]];
        [self.tbvMain.mj_header endRefreshing];
        //        [weakSelf configDataSuccess];
    } andFailed:^(NSInteger code, NSString *errorMsg) {//没有待还款订单
        [weakSelf hideLoading];
        _model = nil;
        weakSelf.vNoData.hidden = code == -200 ? YES : NO;
        weakSelf.vNoNet.hidden = code == - 200 ? NO : YES;
        weakSelf.tbvMain.hidden = YES;
        weakSelf.vNoData.imageTop.constant = 168 * WIDTHRADIUS;
        //[weakSelf.tbvBack removeFromSuperview];
        if (code != -2) {
            [weakSelf showMessage:errorMsg];
        }
    }];
}

- (void)setModel:(RepaymentModel *)model {
    if ([_model isEqualToRepaymentModel:model]) {
        return;
    }
    _model = model;
    [self configDataSuccess];
}

- (void)configDataSuccess {
    self.vNoData.hidden = YES;
    self.vNoNet.hidden = YES;
    self.tbvMain.hidden = NO;
#pragma mark  -就是在这个地方 还款方式被隐藏掉了-
    //[self.tbvBack removeFromSuperview];
    [self creatTbvBack];
    if (self.model.list.count) {
        [self.tbvMain reloadData];
        [self.tbvMain.mj_header endRefreshing];
    }else {
        self.vNoData.hidden = NO;
        self.vNoData.btnBorrow.hidden = NO;
        self.vNoNet.hidden = YES;
        self.tbvMain.hidden = YES;
        //[self creatTbvBack];
        _vNoData.imageTop.constant = iPhone4 ? 20 : 50*WIDTHRADIUS;
        _vNoData.btnTop.constant = iPhone4 ? 10 : 50*WIDTHRADIUS;
        if (iPhone5) {
            _vNoData.imageTop.constant = iPhone4 ? 20 : 25*WIDTHRADIUS;
            _vNoData.btnTop.constant = iPhone4 ? 10 : 25*WIDTHRADIUS;
        }
        [_vNoData.btnBorrow setTitle:@"立即借款" forState:normal];
    }
}
#pragma mark  - 检查登录状态 -
- (void)checkLoginStatus {
    if ([UserManager sharedUserManager].isLogin) {
        self.vNoData.detailLabel.text = @"您还没有需要还款的记录哦~";
        self.vNoData.btnBorrow.hidden = NO;
        self.vNoData.btnRepay.hidden = YES;
        self.tbvBack.hidden = NO;
    }else {
        self.vNoData.detailLabel.text = @"点我登录哦~";
        self.vNoData.btnBorrow.hidden = YES;
        self.vNoData.btnRepay.hidden = YES;
        self.tbvBack.hidden = YES;
    }
}


#pragma mark - 更新UI约束  懒加载
- (void)updateViewConstraints {
    [super updateViewConstraints];
    if (self.tbvMain.translatesAutoresizingMaskIntoConstraints) {
        [self.tbvMain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (UIBarButtonItem *)helpBtn {
    if (!_helpBtn) {
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goHelp) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _helpBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _helpBtn;
}

- (RepaymentRequest *)request {
    if (!_request) {
        _request = [[RepaymentRequest alloc] init];
    }
    return _request;
}

- (UITableView *)tbvMain {
    if (!_tbvMain) {
        _tbvMain = [[UITableView alloc] init];
        _tbvMain.backgroundColor = Color_Background;
        _tbvMain.layoutMargins = UIEdgeInsetsZero;
        _tbvMain.separatorInset = UIEdgeInsetsZero;
        _tbvMain.separatorColor = Color_LineColor;
        _tbvMain.dataSource = self;
        _tbvMain.delegate = self;
        _tbvMain.tableFooterView = [UIView new];
        _tbvMain.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDataSource)];
    }
    return _tbvMain;
}

- (UITableView *)tbvBack {
    if (!_tbvBack) {
        _tbvBack = [[UITableView alloc] init];
        _tbvBack.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbvBack.delegate = self;
        _tbvBack.dataSource = self;
        _tbvBack.scrollEnabled = NO;
        _tbvBack.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        _tbvBack.tableHeaderView = self.backTbvHeader;
    }
    return _tbvBack;
}

- (UIView *)backTbvHeader {
    if (!_backTbvHeader) {
        _backTbvHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30*WIDTHRADIUS)];
        _backTbvHeader.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        _backTbvHeaderLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 30*WIDTHRADIUS)];
        _backTbvHeaderLbl.font = Repayment_SubTitle;
        _backTbvHeaderLbl.textColor = Color_content;
        _backTbvHeaderLbl.text = self.model.pay_title ? self.model.pay_title : @"支持多种还款方式,方便快捷";
        [_backTbvHeader addSubview:_backTbvHeaderLbl];
    }
    return _backTbvHeader;
}

- (NoDataView *)vNoData {
    if (!_vNoData) {
        _vNoData = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _vNoData.backgroundColor = Color_White;
        _vNoData.hidden = YES;
    }
    return _vNoData;
}

- (NoNetReloadView *)vNoNet {
    if (!_vNoNet) {
        _vNoNet = [[NoNetReloadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _vNoNet.hidden = YES;
    }
    return _vNoNet;
}

@end


