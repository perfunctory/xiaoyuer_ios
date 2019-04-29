//
//  WorkInfoVC.m
//  XianjinXia
//
//  Created by 刘燕鲁 on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "WorkInfoVC.h"
#import "WorkInfoRequest.h"
#import "WorkInfoModel.h"
#import "InputCell.h"
#import "SelectionCell.h"
#import "PickerCell.h"
#import <YYModel.h>
#import "KDAscendingUpLoadVC.h"
#import "GDLocationVC.h"

@interface WorkInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) WorkInfoRequest *request;
@property (nonatomic,strong) WorkInfoModel *workInfoModel;
@property (nonatomic,strong) WorkTimeModel *workTimeModel;
@property (nonatomic, retain) NSMutableArray *entry_time_type_all_name;
@property (nonatomic, retain) NSArray<WorkTimeModel *> *entry_time_type_all;

@property (strong, nonatomic) InputCell *companyNameInput;
@property (strong, nonatomic) InputCell *companyTel;
@property (strong, nonatomic) SelectionCell *selectAddressCell;
@property (strong, nonatomic) InputCell *detailAddressInput;
@property (strong, nonatomic) SelectionCell *workPhotoCell;
@property (strong, nonatomic) PickerCell *workTimeCell;
@property (nonatomic, strong) UIBarButtonItem *navBtn;
@property (assign, nonatomic) NSInteger pickerMaritalIndex;
@end

@implementation WorkInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
     [self getData];
}

- (WorkInfoRequest *)request{
    
    if (!_request) {
        _request = [WorkInfoRequest new];
    }
    return _request;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHex:0xeff3f5];

    self.navigationItem.title = @"工作信息";
    
}
- (void)createUI{
    [self baseSetup:PageGobackTypePop];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHex:0xeff3f5];
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    header.text = @"    为保证借款申请顺利通过，请务必填写真实信息";
    header.font = Font_SubTitle;
    header.textColor = Color_Title;
    
    _tableView.tableHeaderView = header;
    [_tableView setSeparatorColor:Color_LineColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    if (!self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = self.navBtn;
    }
}


- (void)saveData
{
   
    
    NSString *name = self.companyNameInput.inputTextField.text;
    NSString *address = self.selectAddressCell.subTitle.text == nil?NULL:self.selectAddressCell.subTitle.text;
    NSString *addressDetail = self.detailAddressInput.inputTextField.text;
    NSString *phone = self.companyTel.inputTextField.text;
    NSString *longitude = @"0.000000";
    NSString *latitude = @"0.000000";
    if (!name || [name isEqualToString:@""]) {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请输入单位名称" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if(!phone||[phone isEqualToString:@""]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请输入单位电话" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if (!address || [address isEqualToString:@""]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请输入单位地址" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if(!addressDetail || [addressDetail isEqualToString:@""]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请输入详细地址" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }else if([self.workTimeCell.selectDes isEqualToString:@"选择"]){
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"请输入工作时长" leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return;
    }
     [self showLoading:@""];
    NSString *company_period = [NSString stringWithFormat:@"%ld",self.pickerMaritalIndex+1] ;
    __weak typeof(self) weakSelf = self;
    
    [self.request saveWorkInfoWithDict: @{@"company_name":name,
                                          @"company_address_distinct":address == nil?@"":address,
                                          @"company_address":addressDetail,
                                          @"company_phone":phone,
                                          @"company_period":company_period,
                                          @"longitude":longitude,
                                          @"latitude":latitude
                                          } onSuccess:^(NSDictionary *dictResult) {
                                              [self hideLoading];
        DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"" contentText:@"信息保存成功" leftButtonTitle:nil rightButtonTitle:@"确定"];
        alertView.rightBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [alertView show];
        
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        [self showMessage:errorMsg];
    }];
}

- (NSMutableArray *)entry_time_type_all_name{
    
    if (!_entry_time_type_all_name) {
        _entry_time_type_all_name = [NSMutableArray array];
    }
    return _entry_time_type_all_name;
}

- (void)getData
{
    __weak typeof(self) weakSelf = self;
    [self showLoading:@""];
    [self.request getWorkInfoWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
        [self hideLoading];
        weakSelf.workInfoModel = [WorkInfoModel yy_modelWithDictionary:dictResult[@"item"]];
        /**********入司时长数据**********/
        [weakSelf.entry_time_type_all_name removeAllObjects];
        weakSelf.entry_time_type_all = weakSelf.workInfoModel.company_period_list;
        for (NSDictionary *dic in weakSelf.entry_time_type_all ) {
            
            [weakSelf.entry_time_type_all_name addObject:dic[@"name"]];
        }
        
        weakSelf.workTimeModel.entry_time_type = weakSelf.workInfoModel.company_period;
        [_tableView reloadData];
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        
    }];
    
    
}
#pragma mark - Getter
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

#pragma mark --UITableView代理


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
        {
            if (![self.workInfoModel.company_name isEqualToString:@""]) {
                self.companyNameInput.inputTextField.text = self.workInfoModel.company_name;
            }
            
            return self.companyNameInput;
        }
            break;
        case 1:{
            if (![self.workInfoModel.company_phone isEqualToString:@""]) {
                self.companyTel.inputTextField.text = self.workInfoModel.company_phone;
            }
            return self.companyTel;
        }
            break;
        case 2:{
            if (![self.workInfoModel.company_address_distinct isEqualToString:@""]) {
                self.selectAddressCell.subTitle.text = self.workInfoModel.company_address_distinct;
            }
            return self.selectAddressCell;
        }
            break;
        case 3:{
            if (![self.workInfoModel.company_address isEqualToString:@""]) {
                self.detailAddressInput.inputTextField.text = self.workInfoModel.company_address;
            }
            return self.detailAddressInput;
        }
            break;
        case 4:{
            if([self.workInfoModel.company_picture isEqualToString:@"1"]){
                self.workPhotoCell.subTitle.text = @"已上传";
            }
            return self.workPhotoCell;
        }
            break;
        case 5:{
            if (![self.workInfoModel.company_period isEqualToString:@""]) {
                for (NSDictionary *dic in self.workInfoModel.company_period_list) {
                    if([dic[@"entry_time_type"] isEqualToString:self.workInfoModel.company_period]){
                    
                        self.workTimeCell.selectDes = dic[@"name"];
                    };
                    
                }
            }
            return self.workTimeCell;
        }
        default:
            return [UITableViewCell new];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 2:
        {
            GDLocationVC *vc = [[GDLocationVC alloc]init];
            vc.address = ^(AMapPOI * model, MAUserLocation* Usermodel){
                self.selectAddressCell.subTitle.text = model.address;
                [self.selectAddressCell setSubTitleValue:model.name];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{
        
            KDAscendingUpLoadVC *vc = [[KDAscendingUpLoadVC alloc]initWithType:workCard];
            vc.uploadImgSuccss = ^{
                self.workPhotoCell.subTitle.text = @"已上传";
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SelectionCell *)selectAddressCell {
    
    if (!_selectAddressCell) {
        _selectAddressCell = [[SelectionCell alloc] initWithTitle:@"单位所在地" subTitle:@""];
    }
    return _selectAddressCell;
}
- (SelectionCell *)workPhotoCell {
    
    if (!_workPhotoCell) {
        _workPhotoCell = [[SelectionCell alloc] initWithTitle:@"工作照片" subTitle:@"(选填,可提高通过率)"];
        
    }
    return _workPhotoCell;
}
- (InputCell *)companyNameInput {
    
    if (!_companyNameInput) {
        _companyNameInput = [[InputCell alloc] initWithTitle:@"单位名称" placeholder:@"请输入单位名称"];
    }
    return _companyNameInput;
}
- (InputCell *)companyTel {
    
    if (!_companyTel) {
        _companyTel = [[InputCell alloc] initWithTitle:@"单位电话" placeholder:@"请输入单位电话"];
    }
    return _companyTel;
}
- (InputCell *)detailAddressInput {
    
    if (!_detailAddressInput) {
        _detailAddressInput = [[InputCell alloc] initWithTitle:@"" placeholder:@"请填写具体街道门牌号"];
    }
    return _detailAddressInput;
}

- (PickerCell *)workTimeCell {
    
    if (!_workTimeCell) {
        _workTimeCell = [[PickerCell alloc] initWithTitle:@"工作时长" subTitle:@"" selectDes:@"选择"];
        
        @Weak(self)
        _workTimeCell.numberOfRow = ^NSInteger{
            @Strong(self)
            return self.entry_time_type_all_name.count;
        };
        _workTimeCell.stringOfRow = ^(NSInteger row){
            @Strong(self)
            return self.entry_time_type_all_name[row];
        };
        _workTimeCell.didSelectBlock = ^(NSInteger selectedRow) {
            @Strong(self)
            self.pickerMaritalIndex = selectedRow;
            
            self.workTimeCell.selectDes = self.entry_time_type_all_name.count ? self.entry_time_type_all_name[selectedRow] : @"";
        };
    }
    return _workTimeCell;
}


@end
