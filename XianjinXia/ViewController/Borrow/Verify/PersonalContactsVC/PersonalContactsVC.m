//
//  PersonalContactsVC.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "PersonalContactsVC.h"
#import "ContactsModel.h"
#import "VerifyListRequest.h"
#import "PickerCell.h"
#import "SelectionCell.h"
#import "SelectContactsBookVC.h"
#import <AFNetworkReachabilityManager.h>
#import "GetContactsBook.h"
#import "UserManager.h"
#import "VerifyListRequest.h"
#import "GetContactsBook.h"

@interface PersonalContactsVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIBarButtonItem       * navBtn;
@property (nonatomic, strong) UITableView           * tbvMain;
@property (nonatomic, strong) NSMutableArray        * arrDataSource;
@property (nonatomic, strong) ContactsModel         * model;
@property (nonatomic, strong) VerifyListRequest     * request;
@property (nonatomic, strong) NSMutableDictionary   * dictParm;
@property (nonatomic, assign) NSInteger               isContact;//1成功2失败
@property (nonatomic, assign) NSInteger               isContacts;
@end

@implementation PersonalContactsVC

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    [self getDataSource];
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
    self.navigationItem.title = @"紧急联系人";
    [self baseSetup:PageGobackTypePop];
    
    //创建视图等
    self.navigationItem.rightBarButtonItem = self.navBtn;
    [self.view addSubview:self.tbvMain];
    [self.view updateConstraintsIfNeeded];
}

#pragma mark - 初始化数据源
- (void)setUpDataSource {
     _isContact = 0;
     _isContacts = 0;
}

#pragma mark - 按钮事件
- (void)saveData {
    if ([self checkInfo]) {
        [self showLoading:@""];
        [self upLoadAddressBook];
        __weak __typeof(self)weakSelf = self;
        [self.request SaveContactsWithDictionary:self.dictParm success:^(NSDictionary *dictResult) {
            _isContact = 1;
            [weakSelf updateLoading];
        } failed:^(NSInteger code, NSString *errorMsg) {
            _isContact = 2;
            [weakSelf updateLoading];
            [weakSelf showMessage:errorMsg];
//            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:errorMsg leftButtonTitle:nil rightButtonTitle:@"确定"];
//            [alert show];
        }];
    }
}

- (void)updateLoading {
    if (_isContacts && _isContact) {
        [self hideLoading];
        if (_isContacts == 1 && _isContact == 1) {
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"信息保存成功" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                [self popVC];
            };
            [alert show];
        }
        _isContact = _isContacts = 0;
    }
}

- (void)upLoadAddressBook {
    NSMutableArray *addressBook = [[UserDefaults objectForKey:@"contacts"] mutableCopy];
    if (addressBook.count == 0) {
        addressBook = [self uploadAddress];
        if (addressBook.count == 0) {
            _isContacts = 2;
             [self updateLoading];
            return;
        }
    }else {
        [addressBook removeAllObjects];
        addressBook =  [self uploadAddress];
    }
    id package = [self deleteduplicateWith:addressBook];
    
//    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        NSData  *data = [NSJSONSerialization dataWithJSONObject:package options:NSJSONWritingPrettyPrinted error:nil ];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    __weak __typeof(self)weakSelf = self;
        [self.request updateContactsWithDictionary:@{@"data":jsonString,@"type":@"3"} success:^(NSDictionary *dictResult) {
//            [UserDefaults setObject:dictResult[@"item"][@"jsonArr"] forKey:@"contacts"];
            _isContacts = 1;
            [weakSelf updateLoading];
        } failed:^(NSInteger code, NSString *errorMsg) {
            _isContacts = 1;
            [weakSelf updateLoading];
        }];
//    }
}

//去重
- (NSMutableArray *)deleteduplicateWith:(NSMutableArray *)addressBook {
    NSMutableArray * contact = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrContent = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * tDict in addressBook.lastObject) {
        if (![contact containsObject:tDict[@"mobile"]]) {
            [contact addObject:tDict[@"mobile"]];
            [arrContent addObject:tDict];
        }
    }
    return arrContent;
}

-(NSMutableArray *)uploadAddress {
    NSMutableArray *addressBook;
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray * titleArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * arrData = [NSMutableArray arrayWithCapacity:0];
    if ([[GetContactsBook shareControl]getPersonInfo]&&[[GetContactsBook shareControl] sortMethod]) {
        dataDic = [[GetContactsBook shareControl]getPersonInfo];
        titleArr = [[[GetContactsBook shareControl]sortMethod] mutableCopy];
        arrData = [NSMutableArray arrayWithCapacity:0];
        
        [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *indexString = obj;
            NSInteger index = idx;
            [arrData addObject:[@[] mutableCopy]];
            NSArray *tempArr = dataDic[indexString];
            [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrData[index] addObject:obj];
            }];
        }];
    }
    if (arrData.count>0) {
        NSMutableArray *packageArray = [@[] mutableCopy];
        [packageArray addObject:[@[] mutableCopy]];
        __weak __typeof(self)weskSelf = self;
        [arrData enumerateObjectsUsingBlock:^(NSArray  *obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj1 enumerateObjectsUsingBlock:^(NSDictionary *obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                [[packageArray lastObject] addObject:[NSDictionary dictionaryWithObjects:@[obj2[@"name"],[weskSelf phoneNumClear:obj2[@"mobile"]],@([[UserManager sharedUserManager].userInfo.uid floatValue])] forKeys:@[@"name",@"mobile",@"user_id"]]];
            }];
        }];
        [UserDefaults setObject:packageArray forKey:@"contacts"];
        addressBook = packageArray;
    }
    return addressBook;
}

- (BOOL)checkInfo {
    NSString * alertContent = @"";
    if (!self.arrDataSource.count) {
        return NO;
    }
    if ([self.arrDataSource[0][0][@"subTitle"] isEqualToString:@"请选择"]) {
        alertContent = @"请选择与直属亲属联系人关系！";
    }else if ([self.arrDataSource[0][1][@"subTitle"] isEqualToString:@"请选择"]) {
        alertContent = @"请选择直属亲属紧急联系人！";
    }else if ([self.arrDataSource[1][0][@"subTitle"]  isEqualToString:@"请选择"]) {
        alertContent = @"请选择与其他联系人关系！";
    }else if ([self.arrDataSource[1][1][@"subTitle"] isEqualToString:@"请选择"]) {
        alertContent = @"请选择其他联系人！";
    }
    if ([alertContent isEqualToString:@""]) {
        return YES;
    }else {
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:alertContent leftButtonTitle:nil rightButtonTitle:@"确定"];
        [alert show];
        return NO;
    }
}

#pragma mark - Delegate
#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrDataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        SelectionCell * cell = [[SelectionCell alloc] initWithTitle:self.arrDataSource[indexPath.section][indexPath.row][@"title"] subTitle:self.arrDataSource[indexPath.section][indexPath.row][@"subTitle"]];
        [cell setSubTitleTextAlignment:NSTextAlignmentRight];
        return cell;
    }
    PickerCell * cell = [[PickerCell alloc] initWithTitle:self.arrDataSource[indexPath.section][indexPath.row][@"title"] subTitle:@"" selectDes:self.arrDataSource[indexPath.section][indexPath.row][@"subTitle"]];
    @Weak(self)
    cell.numberOfRow = ^NSInteger(){
        @Strong(self)
        return indexPath.section ? self.model.other_list.count : self.model.lineal_list.count;
    };
    cell.stringOfRow = ^(NSInteger row){
        @Strong(self)
        return indexPath.section ? [self.model.other_list[row] name] : [self.model.lineal_list[row] name];
    };
    cell.didSelectBlock = ^(NSInteger row) {
        @Strong(self)
        if (indexPath.section==0) {
            [self umengEvent:UmengEvent_Contact_Relation_Family];
        }else if (indexPath.section==1){
            [self umengEvent:UmengEvent_Contact_Relation_Other];
        }else{
            
        }
        [self reloadCellWithIndexPath:indexPath withRow:row];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row) {
        SelectContactsBookVC * vc = [[SelectContactsBookVC alloc] init];
        
        __weak __typeof(self)weakSelf = self;
        [GetContactsBook CheckAddressBookAuthorization:^(bool isAuthorized) {
            if (isAuthorized) {
                vc.selectBlock = ^(SelectContactsModel * model) {
                    if (indexPath.section == 0) {
                        [self umengEvent:UmengEvent_Contact_Person_Family];
                        [weakSelf.dictParm setObject:model.name forKey:@"name"];
                        [weakSelf.dictParm setObject:model.phone forKey:@"mobile"];
                    }else {
                        [self umengEvent:UmengEvent_Contact_Person_Other];
                        [weakSelf.dictParm setObject:model.name forKey:@"name_spare"];
                        [weakSelf.dictParm setObject:model.phone forKey:@"mobile_spare"];
                    }
                    [weakSelf reploadNameCellWithIndexPath:indexPath withName:model.name];
                };
                [weakSelf dsPushViewController:vc animated:YES];
            }else {
                DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"请检查是否在设置-隐私-通讯录授权给信合宝" leftButtonTitle:nil rightButtonTitle:@"确定"];
                alert.rightBlock = ^{
                    [[ApplicationUtil sharedApplicationUtil] gotoSettings];
                };
                [alert show];
            }
        }];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] init];
    [view addSubview:[self getLabelWithSection:section]];
    return view;
}

//更新与本人关系
- (void)reloadCellWithIndexPath:(NSIndexPath *)indexPath withRow:(NSInteger)row {
    indexPath.section == 0 ? [self.dictParm setObject:[self.model.lineal_list[row] type] forKey:@"type"] : [self.dictParm setObject:[self.model.other_list[row] type] forKey:@"relation_spare"];
    NSDictionary * dict = @{@"title":@"与本人关系",@"subTitle":indexPath.section ? [self.model.other_list[row] name] : [self.model.lineal_list[row] name]};
    NSMutableArray * arr = [_arrDataSource[indexPath.section] mutableCopy];
    [arr replaceObjectAtIndex:indexPath.row withObject:dict];
    [_arrDataSource replaceObjectAtIndex:indexPath.section withObject:arr];
    [_tbvMain reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

//更新紧急联系人
- (void)reploadNameCellWithIndexPath:(NSIndexPath *)indexPath withName:(NSString *)name {
    NSDictionary * dict = @{@"title":@"紧急联系人",@"subTitle":name};
    NSMutableArray * arr = [_arrDataSource[indexPath.section] mutableCopy];
    [arr replaceObjectAtIndex:indexPath.row withObject:dict];
    [_arrDataSource replaceObjectAtIndex:indexPath.section withObject:arr];
    [_tbvMain reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 请求数据
- (void)getDataSource {
    [self showLoading:@""];
    __weak __typeof(self)weakSelf = self;
    [self.request getContactsListWithDictionary:nil success:^(NSDictionary *dictResult) {
        [weakSelf hideLoading];
        weakSelf.model = [[ContactsModel alloc] initWithDict:dictResult[@"item"]];
        [weakSelf configDataWithModel];
        [weakSelf.tbvMain reloadData];
    } failed:^(NSInteger code, NSString *errorMsg) {
        [weakSelf showMessage:errorMsg];
        [weakSelf hideLoading];
    }];
}

- (void)configDataWithModel {
    NSInteger linealStatus = [self.model.lineal_relation integerValue];
    NSInteger otherStatus = [self.model.other_relation integerValue];
    _arrDataSource = [NSMutableArray arrayWithArray:@[@[@{@"title":@"与本人关系",@"subTitle":linealStatus >= 1 ? [self.model.lineal_list[linealStatus - 1] name] : @"请选择"},
                                                        @{@"title":@"紧急联系人",@"subTitle":linealStatus >= 1 ? self.model.lineal_name : @"请选择"}],
                                                      @[@{@"title":@"与本人关系",@"subTitle":otherStatus >= 1 ? [self.model.other_list[otherStatus - 1] name] : @"请选择"},
                                                        @{@"title":@"紧急联系人",@"subTitle":otherStatus >= 1 ? self.model.other_name : @"请选择"}]]];
    [self.dictParm setObject:self.model.lineal_name ? : @"" forKey:@"name"];
    [self.dictParm setObject:self.model.lineal_mobile ? : @"" forKey:@"mobile"];
    [self.dictParm setObject:self.model.lineal_relation ? : @"" forKey:@"type"];
    [self.dictParm setObject:self.model.other_name ? : @"" forKey:@"name_spare"];
    [self.dictParm setObject:self.model.other_mobile ? : @"" forKey:@"mobile_spare"];
    [self.dictParm setObject:self.model.other_relation ? : @"" forKey:@"relation_spare"];
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

- (UITableView *)tbvMain {
    if (!_tbvMain) {
        _tbvMain = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tbvMain.delegate = self;
        _tbvMain.dataSource = self;
        _tbvMain.backgroundColor = Color_Background;
        _tbvMain.layoutMargins = UIEdgeInsetsZero;
        _tbvMain.separatorInset = UIEdgeInsetsZero;
        _tbvMain.separatorColor = Color_LineColor;
        _tbvMain.sectionFooterHeight = 0;
    }
    return _tbvMain;
}

- (NSMutableArray *)arrDataSource {
    if (!_arrDataSource) {
        _arrDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _arrDataSource;
}

- (VerifyListRequest *)request {
    if (!_request) {
        _request = [[VerifyListRequest alloc] init];
    }
    return _request;
}

- (NSMutableDictionary *)dictParm {
    if (!_dictParm) {
        _dictParm = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dictParm;
}

- (UILabel *)getLabelWithSection:(NSInteger)section {
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 45)];
    lbl.text = section ? @"其他联系人" : @"直属亲属联系人";
    lbl.textColor = Color_Title;
    lbl.font = Font_SubTitle;
    return lbl;
}

//过滤手机号
- (NSString *)phoneNumClear:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}

@end
