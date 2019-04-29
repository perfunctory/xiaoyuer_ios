//
//  BindBankVC.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/10.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BindBankVC.h"
#import "BindBankCell.h"
#import "UserManager.h"
#import "UserManager.h"
#import "SelectBankVC.h"
#import "BindBankVCodeCell.h"
#import "BindBankRequest.h"
#import "DXAlertView.h"
#import "CommonWebVC.h"
#import "BindBankFooterView.h"

@interface BindBankVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView           * tbvMain;
@property (nonatomic, strong) UIView                * tbvMainHeader;
@property (nonatomic, strong) UIBarButtonItem       * btnSave;
@property (nonatomic, strong) NSMutableArray        * arrDataSource;
@property (nonatomic, strong) NSMutableDictionary   * dictParm;
@property (nonatomic, strong) BindBankRequest       * request;
@property (nonatomic, strong) NSTimer               * timerGetPassword;
@property (nonatomic, assign) NSInteger               timerCount;
@property (nonatomic, strong) UIButton              * btnCode;
@property (nonatomic, strong) UILabel               * lblCode;
@end

@implementation BindBankVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpDataSource];
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
    self.navigationItem.title = @"添加银行卡";
    [self baseSetup:PageGobackTypePop];
    
    //创建视图等
    self.navigationItem.rightBarButtonItem = self.btnSave;
    [self.view addSubview:self.tbvMain];
    [self.view updateConstraintsIfNeeded];
}

#pragma mark - 初始化数据源
- (void)setUpDataSource {
}

#pragma mark - 按钮事件
- (void)saveData {
    if ([self checkInfoWithCode:YES]) {
        [self showLoading:@""];
        __weak __typeof(self)weakSelf = self;
        [self.request SaveBankDataWithDict:_dictParm onSuccess:^(NSDictionary *dictResult) {
            [weakSelf hideLoading];
            [weakSelf loadRechar:dictResult];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [weakSelf hideLoading];
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
        }];
    }
}

- (void)requestGetCodeWithlbl:(UILabel *)lblCode withBtn:(UIButton *)btnCode {
    if ([self checkInfoWithCode:NO]) {
        __weak __typeof(self)weakSelf = self;
        [self showLoading:@""];
        [self.request getVCodeDataWithDict:@{@"phone":_dictParm[@"phone"]} onSuccess:^(NSDictionary *dictResult) {
            weakSelf.timerGetPassword = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(handleGetPasswordTimer) userInfo:nil repeats:YES];
            weakSelf.timerCount = 60;
            btnCode.userInteractionEnabled = NO;
            lblCode.text = [NSString stringWithFormat:@"%ldS",(long)self.timerCount];
            weakSelf.lblCode = lblCode;
            weakSelf.btnCode = btnCode;
            [self hideLoading];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            [self hideLoading];
            [weakSelf showMessage:errorMsg];
//            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
//            [alert show];
        }];
    }
}

- (void)loadRechar:(NSDictionary*)dict{
    CommonWebVC *vc = [[CommonWebVC alloc]init];
    vc.blockChoose = ^(){
        [self performSelector:@selector(popVC) withObject:nil afterDelay:1];
    };
    vc.strAbsoluteUrl = [NSString stringWithFormat:@"%@",dict[@"data"][@"signpath"]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Delegate
#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrDataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        SelectBankVC * vc = [[SelectBankVC alloc] init];
        vc.selectBlock = ^(BankList * model) {
            NSDictionary * dict = @{@"title":@"选择银行",@"placeHolder":model.bank_name,@"hasArrow":@"1",@"textColor":@"",@"vcode":@"0"};
            [self.dictParm setObject:model.bank_id forKey:@"bank_id"];
            [_arrDataSource replaceObjectAtIndex:indexPath.row withObject:dict];
            [_tbvMain reloadData];
        };
        [self dsPushViewController:vc animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.arrDataSource.count - 1 == indexPath.row) {
        BindBankVCodeCell * cell = [BindBankVCodeCell bindBankVCodeCellWithTableView:tableView];
        [cell configCellWithDict:self.arrDataSource[indexPath.row] withIndexPath:indexPath];
        __weak __typeof(self)weakSelf = self;
        cell.getVCodeBlock = ^(NSInteger status, NSString * code, UILabel * lblCode, UIButton * btnCode) {
            if (status) {
                [weakSelf requestGetCodeWithlbl:lblCode withBtn:btnCode];
            }else {
                [weakSelf.dictParm setObject:code forKey:@"code"];
            }
        };
        return cell;
    }
    BindBankCell * cell = [BindBankCell bindBankCellWithTableView:tableView];
    [cell configCellWithDict:self.arrDataSource[indexPath.row] withIndexPath:indexPath];
    __weak __typeof(self)weakSelf = self;
    cell.changeBlock = ^(NSString * parmKey, NSString * parmValue) {
        [weakSelf.dictParm setObject:parmValue forKey:parmKey];
    };
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - 请求数据
- (void)getDataSource {
    [self showLoading:@""];
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

- (UIBarButtonItem *)btnSave {
    if (!_btnSave) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"保存" forState:normal];
        [button addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        [button setTitleColor:Color_White forState:normal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _btnSave = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _btnSave;
}

- (UITableView *)tbvMain {
    if (!_tbvMain) {
        _tbvMain = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tbvMain.backgroundColor = [UIColor colorWithHex:0xeff3f5];
        _tbvMain.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbvMain.dataSource = self;
        _tbvMain.delegate = self;
        _tbvMain.tableHeaderView = self.tbvMainHeader;
        _tbvMain.tableFooterView = [BindBankFooterView bindBankEncryptionView];;
    }
    return _tbvMain;
}

- (NSMutableArray *)arrDataSource {
    if (!_arrDataSource) {
        _arrDataSource = [NSMutableArray arrayWithObjects:@{@"title":@"持卡人",@"placeHolder":[UserManager sharedUserManager].userInfo.realname,@"hasArrow":@"0",@"textColor":@"",@"vcode":@"0"},
                                                          @{@"title":@"选择银行",@"placeHolder":@"请选择银行(仔细核对，否则打款失败)",@"hasArrow":@"1",@"textColor":@"red",@"vcode":@"0"},
                                                          @{@"title":@"卡号",@"placeHolder":@"请输入银行卡号(仔细核对，否则打款失败)",@"hasArrow":@"0",@"textColor":@"red",@"vcode":@"0"},
                                                          @{@"title":@"手机号",@"placeHolder":@"请输入银行预留手机号",@"hasArrow":@"0",@"textColor":@"",@"vcode":@"0"},
                                                          @{@"title":@"验证码",@"placeHolder":@"请输入验证码",@"hasArrow":@"0",@"textColor":@"",@"vcode":@"1"},nil];
    }
    return _arrDataSource;
}

- (NSMutableDictionary *)dictParm {
    if (!_dictParm) {
        _dictParm = [[NSMutableDictionary alloc] initWithDictionary:@{@"card_no":@"",@"bank_id":@"",@"phone":@"",@"code":@""}];
    }
    return _dictParm;
}

- (UIView *)tbvMainHeader {
    if (!_tbvMainHeader) {
        _tbvMainHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _tbvMainHeader.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(15*WIDTHRADIUS, 0, SCREEN_WIDTH - 30*WIDTHRADIUS, 40)];
        lbl.text = @"添加您的银行卡用于收款";
        lbl.textColor = Color_Title;
        lbl.font = Font_SubTitle;
        [_tbvMainHeader addSubview:lbl];
    }
    return _tbvMainHeader;
}

- (BindBankRequest *)request {
    if (!_request) {
        _request = [[BindBankRequest alloc] init];
    }
    return _request;
}

- (void)handleGetPasswordTimer {
    if (self.timerCount <= 0) {
        [self.timerGetPassword invalidate];
        _btnCode.userInteractionEnabled = YES;
        _lblCode.text = @"重发";
    }else{
        self.timerCount--;
        _btnCode.userInteractionEnabled = NO;
        _lblCode.text = [NSString stringWithFormat:@"%ldS",(long)self.timerCount];
    }
}

- (BOOL)checkInfoWithCode:(BOOL)needCode {
    NSString * alertContent = @"";
    if (needCode) {
        alertContent = [_dictParm[@"code"] isEqualToString:@""] ? @"请先输入验证码" : @"";
    }
    if ([self.dictParm[@"bank_id"] isEqualToString:@""]) {
        alertContent = @"请先选择银行";
    }else if ([_dictParm[@"card_no"] isEqualToString:@""]) {
        alertContent = @"请先输入银行卡号！";
    }else if ([_dictParm[@"phone"] isEqualToString:@""]) {
        alertContent = @"请先输入银行预留手机号！";
    }
    if ([alertContent isEqualToString:@""]) {
        return YES;
    }else {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:alertContent leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return NO;
    }
}

@end
