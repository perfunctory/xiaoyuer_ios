//
//  SettingVC.m
//  XianjinXia
//
//  Created by liu xiwang on 2017/2/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SettingVC.h"
#import "SettingCell.h"
#import "UserManager.h"
#import "CommonWebVC.h"
#import "FeedBackVC.h"
#import "DXAlertView.h"
#import "SetTradingPasswordVC.h"
#import "LoginOrRegistRequest.h"
#import <UMMobClick/MobClick.h>
#import "ChangePasswordVC.h"
#import "VerifyListVC.h"

@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray            *arrayData;
@property (nonatomic, strong) UITableView               *tbvSetting;
@property (nonatomic, retain) UIView                    *footerView;
@property (nonatomic, retain) UIView                    *headerView;
@property (nonatomic, retain) UIButton                  *btnLoginOut;
@property (nonatomic,strong) LoginOrRegistRequest       *request;
@end

@implementation SettingVC
#pragma mark - VC生命周期
{
    BOOL userOut;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpDataSource];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(userOut){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOut" object:nil];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (LoginOrRegistRequest *)request{
    
    if (!_request) {
        _request = [[LoginOrRegistRequest alloc] init];
    }
    return _request;
}

- (void)dealloc{
    //delegate 置为nil
    
    //删除通知
    
}

#pragma mark - View创建与设置

- (void)setUpView{
    self.navigationItem.title = @"设置";
    [self baseSetup:PageGobackTypePop];

    //创建视图等
    //创建tableview
    _tbvSetting = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tbvSetting.delegate = self;
    _tbvSetting.dataSource = self;
    _tbvSetting.backgroundColor = [UIColor clearColor];
    _tbvSetting.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tbvSetting];
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 11*WIDTHRADIUS)];
    _headerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,(SCREEN_HEIGHT-200)*WIDTHRADIUS)];
    _footerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    //创建退出按钮
    [_footerView addSubview:self.btnLoginOut];
    [self.btnLoginOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.equalTo([self switchNumberWithFloat:15.f*WIDTHRADIUS]);
        make.topMargin.equalTo([self switchNumberWithFloat:32.5*WIDTHRADIUS]);
        make.width.equalTo([self switchNumberWithFloat:SCREEN_WIDTH-30]);
        make.height.equalTo([self switchNumberWithFloat:46*WIDTHRADIUS]);
    }];
//    [_btnLoginOut setTitleColor:UIColorFromRGB(0xFF5145) forState:UIControlStateNormal];
    [_btnLoginOut setTitleColor:Color_Red_New forState:UIControlStateNormal];

    self.btnLoginOut.backgroundColor = UIColorFromRGB(0xffffff);
    [self.btnLoginOut setTitle:@"退出登录" forState:UIControlStateNormal];
    self.btnLoginOut.layer.cornerRadius = 46*WIDTHRADIUS/2;
    self.btnLoginOut.layer.masksToBounds = YES;
    self.btnLoginOut.layer.borderWidth = 0.5;
//    self.btnLoginOut.layer.borderColor = UIColorFromRGB(0xFF5145).CGColor;
    self.btnLoginOut.layer.borderColor = Color_Red_New.CGColor;

    [self.btnLoginOut addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    _tbvSetting.tableFooterView = _footerView;
    _tbvSetting.tableHeaderView = _headerView;
    
    //    _tbvSetting.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
}

#pragma mark - 初始化数据源

- (void)setUpDataSource{
    [_arrayData removeAllObjects];
    _arrayData = [[NSMutableArray alloc]init];
    NSArray *array = @[
                       @{@"strIcon":@"more_AboutUs",@"strTitle":@"关于我们",@"strContent":@""},//版本号混淆被AppStore拒绝了
                       //@{@"strIcon":@"more_Opinion",@"strTitle":@"意见反馈"}
                       @{@"strIcon":@"more_ChangePassWord",@"strTitle":@"修改登录密码"},
                       @{@"strIcon":@"more_ChangePayPassWord",@"strTitle":[UserManager sharedUserManager].real_pay_pwd_status == 0 ? @"设置交易密码" : @"修改交易密码"}];
    [_arrayData addObjectsFromArray:array];
    [_tbvSetting reloadData];
}



#pragma mark - 按钮事件

- (void)login{
    
    __weak typeof(self) weakSelf = self;
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"" contentText:@"您确定要退出登录吗？" leftButtonTitle:@"取消" rightButtonTitle:@"确定" buttonType:LeftGray];
    alert.rightBlock = ^{
        
        [weakSelf.request LoginOutWihtDict:@{} onSuccess:^(NSDictionary *dictResult) {
            [[UserManager sharedUserManager] logout];
            [MobClick profileSignOff];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"logoutApp" object:nil];
            userOut = YES;
            [self popVC];
        } andFailed:^(NSInteger code, NSString *errorMsg) {
            
        }];
        
    };
    [alert show];
}



#pragma mark - Delegate

#pragma --mark tableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingCell *cell = [SettingCell homeCellWithTableView:tableView];
    if (indexPath.row < _arrayData.count) {
        [cell configCellWithDict:_arrayData[indexPath.row] indexPath:indexPath];
        //cell.separatorStyle =
    }
    return cell;
}

#pragma --mark tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55*WIDTHRADIUS;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChangePasswordVC *vcChangePassword = [[ChangePasswordVC alloc]init];
    if (indexPath.row==0) {
        CommonWebVC *web = [[CommonWebVC alloc]init];
        web.strTitle = @"关于我们";
        web.strAbsoluteUrl = [NSString stringWithFormat:@"%@%@",Url_Server,@"/page/detailAbout"];
        [self dsPushViewController:web animated:YES];
    }else if (indexPath.row == 1){//修改登录密码
        vcChangePassword.passwordType = loginChange;
        [self dsPushViewController:vcChangePassword animated:YES];
    }else if (indexPath.row==2){//设置交易密码
        if ([UserManager sharedUserManager].real_pay_pwd_status == 0) {
            if (self.real_verify_status == 0) {
                DXAlertView* alertView = [[DXAlertView alloc]initWithTitle:nil contentText:@"亲，请先填写个人信息哦～" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                __weak __typeof(self)weakSelf = self;
                alertView.rightBlock = ^{
                    
                    VerifyListVC *verify = [[VerifyListVC alloc]init];
                    [weakSelf dsPushViewController:verify animated:YES];
                };
                [alertView show];
                return;
                
            }
            SetTradingPasswordVC *vcSetTradingPassword = [[SetTradingPasswordVC alloc]init];
            vcSetTradingPassword.controllIndex = 1;
            [self dsPushViewController:vcSetTradingPassword animated:YES];
        }else
        {
            vcChangePassword.passwordType = payChange;
            [self dsPushViewController:vcChangePassword animated:YES];
            
        }
    }
}
#pragma mark - 请求数据

//-(void)refreshData{
//                [_tbvSetting.mj_header endRefreshing];
//}

#pragma mark - Other

-  (UIButton *)btnLoginOut {
    if (!_btnLoginOut) {
        _btnLoginOut = [[UIButton alloc]init];
    }
    return _btnLoginOut;
}

- (NSNumber *)switchNumberWithFloat:(float)floatValue {
    return [NSNumber numberWithFloat:floatValue];
}

@end
