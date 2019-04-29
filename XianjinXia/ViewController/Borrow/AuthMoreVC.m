//
//  AuthMoreVC.m
//  XianjinXia
//
//  Created by 童欣凯 on 2018/1/25.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "AuthMoreVC.h"
#import "InputCell.h"
#import "PickerCell.h"
#import "LabelCell.h"
#import "VerifyListRequest.h"
#import "AuthMoreInfoModel.h"
#import "NSString+Calculate.h"
#import "NSObject+InitWithDictionary.h"

//加分认证
@interface AuthMoreVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *navBtn;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) PickerCell *maritalStatus;
@property (strong, nonatomic) NSArray *maritalList;
@property (strong, nonatomic) PickerCell *liveTime;
@property (strong, nonatomic) NSArray *liveList;

@property (strong, nonatomic) LabelCell *workInfoLabel;

@property (strong, nonatomic) InputCell *workInfoInput;
@property (strong, nonatomic) InputCell *companyNameInput;
@property (strong, nonatomic) InputCell *companyAddressInput;

//原来的信息，用以区分信息是否修改
@property (strong, nonatomic) NSDictionary *originInfo;
@property (strong, nonatomic) VerifyListRequest *request;
@property (strong, nonatomic) NSDictionary *personalInfo;
@property (strong, nonatomic) AuthMoreInfoModel *infoModel;

@end

@implementation AuthMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseSetup:PageGobackTypePop];
    self.title = @"加分认证";
    [self.view addSubview:self.tableView];
    [self.view updateConstraintsIfNeeded];
    [self loadData];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.tableView.translatesAutoresizingMaskIntoConstraints) {
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)popVC {//覆盖父类方法
    if ([self infoDidChange]) {
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:nil contentText:@"有修改尚未保存，您确定退出" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        alert.rightBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)nameOfValue:(NSInteger)value array:(NSArray<NSDictionary *> *)aArr keyInDictionary:(NSString *)key {
    NSString *result = @"选择";
    
    for (NSInteger i = 0; i < aArr.count; ++i) {
        
        NSDictionary *aDic = aArr[i];
        if ([aDic[key] integerValue] == value) {
            result = aDic[@"name"];
            break;
        }
    }
    return result;
}

- (void)setPersonalInfo:(NSDictionary *)personalInfo {
    _personalInfo = personalInfo;
    
    self.infoModel = [AuthMoreInfoModel yy_modelWithDictionary:personalInfo];
    self.originInfo = [self getDictionaryData:self.infoModel];
    
    self.maritalList = personalInfo[@"marriage_all"];
    self.maritalStatus.selectDes = [self nameOfValue:[self.infoModel.marriage intValue] array:self.maritalList keyInDictionary:@"marriage"];
    [self.maritalStatus reloadPickerView];
    self.liveList = personalInfo[@"live_time_type_all"];
    self.liveTime.selectDes = [self nameOfValue:[self.infoModel.live_period intValue] array:self.liveList keyInDictionary:@"live_time_type"];
    [self.liveTime reloadPickerView];
    
    self.workInfoInput.inputValue = self.infoModel.work_industry;
    self.companyNameInput.inputValue = self.infoModel.company_name;
    self.companyAddressInput.inputValue = self.infoModel.company_address;
    
    [self.tableView reloadData];
    self.tableView.tableHeaderView.hidden = NO;
    if (!self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = self.navBtn;
    }
}

- (void)refreshInfoModel {
    self.infoModel.work_industry = self.workInfoInput.inputValue;
    self.infoModel.company_name = self.companyNameInput.inputValue;
    self.infoModel.company_address = self.companyAddressInput.inputValue;
}

- (BOOL)infoDidChange {
    [self refreshInfoModel];
    
    return ![self.originInfo isEqual:[self getDictionaryData:self.infoModel]];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return self.maritalStatus;
        case 1:
            return self.liveTime;
        case 2:
            return self.workInfoLabel;
        case 3:
            return self.workInfoInput;
        case 4:
            return self.companyNameInput;
        case 5:
            return self.companyAddressInput;
        default:
            return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 2 == indexPath.row ? 30 : 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 30)];
    label.backgroundColor = Color_Background;
    label.font = FontSystem(13);
    label.textColor = [UIColor colorWithHex:0x9F9F9F];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = 0 == section ? @"认证越多，信用额度就越高哦" : @"加分认证有助于获得更高的额度哦";
    return label;
}

#pragma mark - Getter 懒加载
- (UIBarButtonItem *)navBtn {
    if (!_navBtn) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"保存" forState:normal];
        [button setTitleColor:[UIColor whiteColor] forState:normal];
        button.titleLabel.font = Font_Title;
        [button addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _navBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _navBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.backgroundColor = Color_Background;
        _tableView.separatorColor = Color_LineColor;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.layoutMargins = UIEdgeInsetsZero;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        _tableView.tableHeaderView.hidden = YES;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (PickerCell *)maritalStatus {
    
    if (!_maritalStatus) {
        _maritalStatus = [[PickerCell alloc] initWithTitle:@"婚姻状态" subTitle:@"(选填)" selectDes:@"选择"];
        
        @Weak(self)
        _maritalStatus.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.maritalList.count;
        };
        _maritalStatus.stringOfRow = ^(NSInteger row){
            @Strong(self)
            return self.maritalList[row][@"name"];
        };
        _maritalStatus.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            self.infoModel.marriage = self.maritalList[selectedRow][@"marriage"];
            self.maritalStatus.selectDes = self.maritalList[selectedRow][@"name"];
        };
    }
    return _maritalStatus;
}

- (PickerCell *)liveTime {
    
    if (!_liveTime) {
        _liveTime = [[PickerCell alloc] initWithTitle:@"居住时长" subTitle:@"(选填)" selectDes:@"选择"];
        
        @Weak(self)
        _liveTime.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.liveList.count;
        };
        _liveTime.stringOfRow = ^(NSInteger row){
            @Strong(self)
            return self.liveList[row][@"name"];
        };
        _liveTime.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            self.infoModel.live_period = self.liveList[selectedRow][@"live_time_type"];
            self.liveTime.selectDes = self.liveList[selectedRow][@"name"];
        };
    }
    return _liveTime;
}

- (LabelCell *) workInfoLabel {
    if (!_workInfoLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 30)];
        label.font = FontSystem(13);
        label.textColor = [UIColor colorWithHex:0x9F9F9F];
        label.text = @"工作信息";
        _workInfoLabel = [[LabelCell alloc] initWithLabel:label backgroundColor:Color_Background];
    }
    return _workInfoLabel;
}

- (InputCell *) workInfoInput {
    if (!_workInfoInput) {
        _workInfoInput = [[InputCell alloc] initWithTitle:@"工作行业" placeholder:@""];
    }
    return _workInfoInput;
}

-(InputCell *) companyNameInput {
    if(!_companyNameInput){
        _companyNameInput = [[InputCell alloc] initWithTitle:@"公司名称" placeholder:@""];
    }
    return _companyNameInput;
}

-(InputCell *) companyAddressInput {
    if (!_companyAddressInput) {
        _companyAddressInput = [[InputCell alloc] initWithTitle:@"公司地址" placeholder:@"请输入详细地址"];
    }
    return _companyAddressInput;
}

#pragma mark - 保存数据
- (void)saveData {
        [self refreshInfoModel];
    
        [self showLoading:@""];
    
        @Weak(self)
        [self.request saveAuthMoreInfoWithDictionary: [self getDictionaryData:self.infoModel] success:^(NSDictionary *dictResult) {
            @Strong(self)
            [self hideLoading];
    
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:nil contentText:@"信息保存成功" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            [alert show];
        } failed:^(NSInteger code, NSString *errorMsg) {
            @Strong(self)
            [self hideLoading];
            
            [self showMessage:errorMsg];
        }];
}

#pragma mark - 初始化加载数据
- (void)loadData {
    [self showLoading:@""];
    
    @Weak(self)
    [self.request fetchAuthMoreInfoWithDictionary:@{} success:^(NSDictionary *dictResult) {
        @Strong(self)
        [self hideLoading];
        self.personalInfo = dictResult[@"item"];
    } failed:^(NSInteger code, NSString *errorMsg) {
        @Strong(self)
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
}

- (VerifyListRequest *)request {
    if (!_request) {
        _request = [[VerifyListRequest alloc] init];
    }
    return _request;
}

@end
