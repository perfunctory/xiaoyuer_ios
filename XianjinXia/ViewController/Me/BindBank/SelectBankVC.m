//
//  SelectBankVC.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SelectBankVC.h"
#import "SelectBankListCell.h"
#import "BindBankRequest.h"
#import "SelectBankListModel.h"

@interface SelectBankVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView           * tbvMain;
@property (nonatomic, strong) BindBankRequest       * request;
@property (nonatomic, strong) SelectBankListModel   * model;
@end

@implementation SelectBankVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     [self getDataSource];
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
    self.navigationItem.title = @"银行卡列表";
    [self baseSetup:PageGobackTypePop];
    
    //创建视图等
    [self.view addSubview:self.tbvMain];
    [self.view updateConstraintsIfNeeded];
}

#pragma mark - 初始化数据源

#pragma mark - 按钮事件

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.item.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectBankListCell * cell = [SelectBankListCell selectBankListCellWithTableView:tableView];
    [cell configCellWithModel:self.model.item[indexPath.row] withIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBlock) {
        self.selectBlock(self.model.item[indexPath.row]);
        [self popVC];
    }
}

#pragma mark - UITableView DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 47.f;
}

#pragma mark - 请求数据
- (void)getDataSource {
    [self showLoading:@""];
    __weak __typeof(self)weskSelf = self;
    [self.request getBankListDataWithDict:nil onSuccess:^(NSDictionary *dictResult) {
        self.model = [[SelectBankListModel alloc] initWithDict:dictResult];
        [weskSelf hideLoading];
        [weskSelf.tbvMain reloadData];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [weskSelf showMessage:errorMsg];
        [weskSelf hideLoading];
    }];
}

#pragma mark - Other
- (void)updateViewConstraints {
    [super updateViewConstraints];
    if (self.tbvMain.translatesAutoresizingMaskIntoConstraints) {
        [self.tbvMain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
        }];
    }
}

- (UITableView *)tbvMain {
    if (!_tbvMain) {
        _tbvMain = [[UITableView alloc] init];
        _tbvMain.backgroundColor = [UIColor colorWithHex:0xeff3f5];
        _tbvMain.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbvMain.dataSource = self;
        _tbvMain.delegate = self;
    }
    return _tbvMain;
}

- (BindBankRequest *)request {
    if (!_request) {
        _request = [[BindBankRequest alloc] init];
    }
    return _request;
}

@end
