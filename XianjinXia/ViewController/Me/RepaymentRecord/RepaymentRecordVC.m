//
//  RepaymentRecordVC.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/14.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "RepaymentRecordVC.h"
#import "CommonWebVC.h"
#import "RequestmentRecordRequest.h"
#import "RepaymentRecordCell.h"
#import "RepaymentRecordModel.h"
#import "NoDataView.h"
#import "NoNetReloadView.h"

#define kPageSize           @"15"

@interface RepaymentRecordVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView                   * tbvMain;
@property (nonatomic, strong) RequestmentRecordRequest      * request;
@property (nonatomic, assign) NSInteger                       page;
@property (nonatomic, assign) NSInteger                       totalPage;
@property (nonatomic, strong) NSMutableArray                * arrDataSource;
@property (nonatomic, strong) RepaymentRecordModel          * model;
@property (nonatomic, strong) NoDataView                    * vNoData;
@property (nonatomic, strong) NoNetReloadView               * vNoNet;
@end

@implementation RepaymentRecordVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpDataSource];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tbvMain.mj_header beginRefreshing];
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
    self.navigationItem.title = @"借款记录";
    [self baseSetup:PageGobackTypePop];
    
    //创建视图等
    [self.view addSubview:self.tbvMain];
    [self.view addSubview:self.vNoData];
    [self.view addSubview:self.vNoNet];
    __weak __typeof(self)weakSelf = self;
    _vNoNet.btnClick = ^() {
        [weakSelf getDataSource];
    };
    [self.view updateConstraintsIfNeeded];
}

#pragma mark - 初始化数据源
- (void)setUpDataSource {
    _page = 1;
}

#pragma mark - Delegate
#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.f * WIDTHRADIUS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepaymentRecordCell * cell = [RepaymentRecordCell repaymentRecordCellWithTableView:tableView];
    if (self.arrDataSource.count > indexPath.row) {
        [cell configCellWithModel:self.arrDataSource[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonWebVC * vc = [[CommonWebVC alloc] init];
    if (self.arrDataSource.count > indexPath.row) {
        RecordModel * model = self.arrDataSource[indexPath.row];
        vc.strAbsoluteUrl = model.url;
    }
    [self dsPushViewController:vc animated:YES];
}

#pragma mark - 请求数据
- (void)refreshData {
    [self.arrDataSource removeAllObjects];
    _page = 1;
    [self getDataSource];
}

- (void)getDataSource {
//    [self showLoading:@""];
    __weak __typeof(self)weakSelf = self;
    [self.request getRepaymentRecordInfoWithDict:@{@"page":[NSString stringWithFormat:@"%ld",(long)_page],@"pagsize":kPageSize} onSuccess:^(NSDictionary *dictResult) {
//        [weakSelf hideLoading];
        weakSelf.model = [[RepaymentRecordModel alloc] initWithDict:dictResult];
        [weakSelf.arrDataSource addObjectsFromArray:self.model.item];
        [weakSelf configDataSuccess];
        [weakSelf.tbvMain.mj_header endRefreshing];
        [weakSelf.tbvMain.mj_footer endRefreshing];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        weakSelf.vNoData.hidden = code == -200 ? YES : NO;
        weakSelf.vNoNet.hidden = code == - 200 ? NO : YES;
        weakSelf.tbvMain.hidden = YES;
        weakSelf.vNoData.imageTop.constant = 168 * WIDTHRADIUS;
//        [weakSelf hideLoading];
        [weakSelf.tbvMain.mj_header endRefreshing];
        [weakSelf.tbvMain.mj_footer endRefreshing];
    }];
}

- (void)configDataSuccess {
    self.vNoData.hidden = YES;
    self.vNoNet.hidden = YES;
    self.tbvMain.hidden = NO;
    if (self.arrDataSource.count) {
        [self.tbvMain reloadData];
    }else {
        self.vNoData.hidden = NO;
        self.vNoNet.hidden = YES;
        self.tbvMain.hidden = YES;
        _vNoData.imageTop.constant = SCREEN_WIDTH / 2 - 50;
    }
}

- (void)getMoreDate {
    if (_page >= self.model.pageTotal) {
        [_tbvMain.mj_footer endRefreshing];
        [self showMessage:@"您没有更多的借款记录～"];
    }else {
        _page ++;
        [self getDataSource];
    }
}

#pragma mark - Other
- (void)updateViewConstraints {
    [super updateViewConstraints];
    if (self.tbvMain.translatesAutoresizingMaskIntoConstraints) {
        [self.tbvMain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (UITableView *)tbvMain {
    if (!_tbvMain) {
        _tbvMain = [[UITableView alloc] init];
        _tbvMain.delegate = self;
        _tbvMain.dataSource = self;
        _tbvMain.backgroundColor = Color_Background;
        _tbvMain.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbvMain.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _tbvMain.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreDate)];
    }
    return _tbvMain;
}

- (RequestmentRecordRequest *)request {
    if (!_request) {
        _request = [[RequestmentRecordRequest alloc] init];
    }
    return _request;
}

- (NSMutableArray *)arrDataSource {
    if (!_arrDataSource) {
        _arrDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _arrDataSource;
}

- (NoDataView *)vNoData {
    if (!_vNoData) {
        _vNoData = [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _vNoData.backgroundColor = Color_White;
        _vNoData.hidden = YES;
        _vNoData.detailLabel.text = @"您还没有借款记录哦～";
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
