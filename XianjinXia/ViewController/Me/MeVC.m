//
//  MeVC.m
//  XianjinXia
//
//  Created by lxw on 17/1/23.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "MeVC.h"

#import "VerifyListVC.h"
#import "UILabel+lyt.h"
#import "UIButton+lyt.h"
#import <Lyt.h>
#import "MeCell.h"
#import "SettingVC.h"
#import "UserManager.h"
#import "MeRequest.h"
#import "MeModel.h"
#import <YYModel/YYModel.h>
#import "CommonWebVC.h"
#import "BindBankVC.h"
#import "RepaymentRecordVC.h"
#import <UMMobClick/MobClick.h>
#import "KDShareManager.h"
#import "DXAlertView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "FeedBackVC.h"

//在线客服
#import "QYSessionViewController.h"
#import "QYSource.h"
#import "QYSDK.h"

@interface MeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UIView   *headerView;
@property (nonatomic, retain) UIImageView   *headerImvView;

@property (nonatomic, retain) UIView   *footerView;
@property (nonatomic, retain) UILabel  *lblHeader;
@property (nonatomic, retain) UILabel  *lblMoney;
@property (nonatomic, retain) UIButton *increaseMoney;
@property (nonatomic, retain) UILabel  *lblCanBorrow;
@property(nonatomic,  retain) UILabel  *lblLine;
@property (nonatomic, retain) UIButton *btnInfo;
@property (nonatomic, retain) UIView   *spliteView;
@property (nonatomic, retain) UIButton *btnRecommd;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray  *arrData;
@property (nonatomic,strong) MeRequest *request;
@property (nonatomic,strong) MeModel *meModel;
@property (nonatomic, strong)DXAlertView *alertView;

@end

@implementation MeVC

#pragma mark - 懒加载数据model -
- (MeRequest *)request{
    
    if (!_request) {
        _request = [[MeRequest alloc] init];
    }
    
    return _request;
}

- (MeModel *)meModel{
    
    if (!_meModel) {
        _meModel = [[MeModel alloc] init];
    }
    return _meModel;
}
#pragma mark  - 视图控制器生命周期 -
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    [super viewWillAppear:animated];
    [self loadData];

    if([UserManager sharedUserManager].userInfo.username && ![[UserManager sharedUserManager].userInfo.username isEqualToString:@""]) {
        self.navigationItem.title =  [UserManager sharedUserManager].userInfo.username.length > 7 ? [[UserManager sharedUserManager].userInfo.username stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"] : [UserManager sharedUserManager].userInfo.username;
    }else
    {
        self.navigationItem.title = @"我的";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加rightBarButtonItem
    [self umengEvent:UmengEvent_Me];
    self.navigationItem.title = @"我的";
    [self addRightTabbarBar];
    
    //布局UI
    [self  createUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - 数据请求和处理 -
- (void)loadData{
    [self showLoading:@""];
    
    [self.request getUserInfoWithDict:@{} onSuccess:^(NSDictionary *dictResult) {
        self.meModel = [MeModel yy_modelWithDictionary:dictResult[@"item"]];
        [self hideLoading];
        //刷新数据
        [self refreshUIWithEntity:self.meModel];
        
    } andFailed:^(NSInteger code, NSString *errorMsg) {
        [self hideLoading];
        if (code == -2) {
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"您的登录态已失效，请重新登录" leftButtonTitle:nil rightButtonTitle:@"确定"];
            alert.rightBlock = ^{
                
                [[UserManager sharedUserManager] checkLogin:self];
            };
            [alert show];
        }
    }];
}

/**
 赋值给header

 @param entity MeModel 对象
 */
- (void)refreshUIWithEntity:(MeModel *)entity{
    [self showData:entity];
    //更新状态
    [[UserManager sharedUserManager]updatePayPassWordtatus:[entity.verify_info.real_pay_pwd_status integerValue]];
    _lblMoney.text = [NSString stringWithFormat:@"%ld",[entity.credit_info.card_amount integerValue] / 100];
    //    [_redCicle showRedKeyWithPercent:[entity.credit_info.card_unused_amount floatValue]/[entity.credit_info.card_amount floatValue] centerLabelText:@"" status:@"" withMoney:entity.credit_info.card_amount];
    _lblCanBorrow.text = [NSString stringWithFormat:@"剩余可借：%ld元",[entity.credit_info.card_unused_amount integerValue]/100];
    
    if(entity.credit_info.risk_status &&[entity.credit_info.risk_status isEqualToString:@"1"]){// 0 不显示 1显示
        _increaseMoney.hidden = NO;
    }else {
        _increaseMoney.hidden = YES;
    }

    
    self.navigationItem.title =  entity.phone;
}

#pragma mark -- 跳转到设置页面
- (void)gotoSetting{
    [self umengEvent:UmengEvent_Me_Setting];
    SettingVC *vcSetting = [[SettingVC alloc]init];
    vcSetting.real_verify_status = [self.meModel.verify_info.real_verify_status integerValue];
    vcSetting.meModel = _meModel;
    [self dsPushViewController:vcSetting animated:YES];
}

#pragma mark -- UI
- (void)addRightTabbarBar{
    
    UIButton *button = [[UIButton alloc] init];
    
    [button setBackgroundImage:[UIImage imageNamed:@"more_Set"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoSetting) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}
- (void)createUI{
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 263.5*WIDTHRADIUS)];
//    _headerView.backgroundColor = Color_Red;

    _headerView.backgroundColor = Color_Background  ;
    
    _headerImvView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 153.5*WIDTHRADIUS)];
    _headerImvView.image = ImageNamed(@"my_head_bg");
//    _headerImvView.contentMode = UIViewContentModeScaleAspectFill;
    [_headerView addSubview:_headerImvView];
    
    _lblHeader = [UILabel getLabelWithFontSize:15 textColor:Color_White superView:_headerView lytSet:^(UILabel *label) {
        
        [label lyt_alignRightToParentWithMargin:15.f*WIDTHRADIUS];
        [label lyt_alignTopToParentWithMargin:30.f*WIDTHRADIUS];
        [label lyt_alignLeftToParentWithMargin:15.f * WIDTHRADIUS];
        [label lyt_setHeight:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"总额度(元)";
        label.alpha = 0.6;
    }];
    _lblMoney = [UILabel getLabelWithFontSize:50.f textColor:Color_White superView:_headerView lytSet:^(UILabel *label) {
        [label lyt_placeBelowView:_lblHeader margin:15];
        [label lyt_centerXInParent];
        [label lyt_setHeight:50];
        [label lyt_setWidth:155];
        label.text = @"0";
        label.textAlignment = NSTextAlignmentCenter;
    }];
    

    _increaseMoney = [UIButton getButtonWithFontSize:13 TextColorHex:nil backGroundColor:nil superView:_headerView lytSet:^(UIButton *button) {
        [button lyt_alignTopToView:_lblMoney margin:-3];
        [button lyt_alignRightToView:_lblMoney margin:-15];
        [button lyt_setWidth:30];
        [button lyt_setHeight:30];
        [button setImage:[UIImage imageNamed:@"help-button"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(goIncreaseMoney) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    _lblCanBorrow = [UILabel getLabelWithFontSize:15 textColor:Color_White superView:_headerView lytSet:^(UILabel *label) {
        label.textAlignment = NSTextAlignmentCenter;
        [label lyt_centerXInParent];
        label.text = @"剩余可借: 0元";
        [label lyt_placeBelowView:_lblMoney margin:10];
    }];
    
    
    
    self.btnInfo = [UIButton getButtonWithFontSize:13 TextColorHex:Color_Title backGroundColor:Color_White superView:_headerView lytSet:^(UIButton *button) {
        [button lyt_alignLeftToParent];
        [button lyt_placeBelowView:_headerView margin:-100*WIDTHRADIUS];
        [button lyt_setWidth:SCREEN_WIDTH / 2];
        [button lyt_setHeight:100*WIDTHRADIUS];
        [button setTitle:@"完善资料" forState:normal];
        [button setImage:[UIImage imageNamed:@"more_Perfect"] forState:normal];
        button.contentMode = UIViewContentModeCenter;
        button.imageEdgeInsets = UIEdgeInsetsMake(-5, 40, 10, -5);
        button.titleEdgeInsets = UIEdgeInsetsMake(40, -5, -5, 40);
        button.tag = 200;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    self.btnRecommd = [UIButton getButtonWithFontSize:13 TextColorHex:Color_Title backGroundColor:[UIColor colorWithHex:0xFFFFFF] superView:_headerView lytSet:^(UIButton *button) {
        [button lyt_alignRightToParent];
        [button lyt_placeBelowView:_headerView margin:-100*WIDTHRADIUS];
        [button lyt_setWidth:SCREEN_WIDTH / 2];
        [button lyt_setHeight:100*WIDTHRADIUS];
        [button setTitle:@"借款记录" forState:normal];
        [button setImage:[UIImage imageNamed:@"more_Record"] forState:normal];
        button.imageEdgeInsets = UIEdgeInsetsMake(-5, 40, 10, -5);
        button.titleEdgeInsets = UIEdgeInsetsMake(40, -5, -5, 40);
        button.tag = 201;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    _spliteView = [UIView getViewWithColor:Color_GRAY superView:_headerView masonrySet:^(UIView *view, MASConstraintMaker *make) {
        [view lyt_centerXInParent];
        [view lyt_alignTopToView:_btnInfo margin:15];
        [view lyt_alignBottomToView:_btnRecommd margin:15];
        [view lyt_setWidth:1];
        
    }];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50);
    _tableView.tableHeaderView = _headerView;
    _tableView.backgroundColor = Color_TABBG;
    _tableView.delegate = self;
    _tableView.dataSource  = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //footerView
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10*WIDTHRADIUS)];
    _footerView.backgroundColor =  Color_TABBG;
    
    _tableView.tableFooterView = _footerView;
    
    [self.view addSubview:_tableView];
    
}

-(void)showData:(MeModel *)entity{
    [_arrData removeAllObjects];
    NSArray *array;
    if ([entity.card_info.bank_name isEqual:@""] && [entity.card_info.card_no_end isEqualToString:@""]) {
//        NSLog(@"%d",entity.service.qq_group);
        array = @[
                      @{@"strIcon":@"",@"strTitle":@""},
                      @{@"strIcon":@"more_Card",@"strTitle":@"收款银行卡",@"strContent":@""},
                      @{@"strIcon":@"more_Share",@"strTitle":@"推荐给好友"},
                      @{@"strIcon":@"more_MsgCenter",@"strTitle":@"消息中心",@"strContent":@""},
                      @{@"strIcon":@"more_QQ",@"strTitle":@"联系客服",@"strContent":@""},
                      @{@"strIcon":@"more_advice",@"strTitle":@"意见反馈",@"strContent":@""},
                      @{@"strIcon":@"more_HelpCenter",@"strTitle":@"帮助中心",@"strContent":@""}];//@"2152872885"
        
    }else{
        
        array = @[
                      @{@"strIcon":@"",@"strTitle":@""},
                      @{@"strIcon":@"more_Card",@"strTitle":@"收款银行卡",@"strContent":[NSString stringWithFormat:@"%@(%@)",entity.card_info.bank_name ? entity.card_info.bank_name : @"",entity.card_info.card_no_end ? entity.card_info.card_no_end : @""]},
                      @{@"strIcon":@"more_Share",@"strTitle":@"推荐给好友"},
                      @{@"strIcon":@"more_MsgCenter",@"strTitle":@"消息中心",@"strContent":@""},
                      @{@"strIcon":@"more_QQ",@"strTitle":@"联系客服",@"strContent":@""},
                      @{@"strIcon":@"more_advice",@"strTitle":@"意见反馈",@"strContent":@""},
                      @{@"strIcon":@"more_HelpCenter",@"strTitle":@"帮助中心",@"strContent":@""}];
        
        
    }
    
    _arrData = [NSMutableArray arrayWithArray:array];
    
    [_tableView reloadData];
}

- (NSMutableArray *)arrData
{
    
    if (_arrData == nil) {
        NSArray *tempArr = @[
                             @{@"strIcon":@"",@"strTitle":@""},
                             @{@"strIcon":@"more_Card",@"strTitle":@"收款银行卡",@"strContent":@""},
                             @{@"strIcon":@"more_MyInvite",@"strTitle":@"推荐给好友",@"strContent": @""},
                             @{@"strIcon":@"more_MsgCenter",@"strTitle":@"消息中心",@"strContent":@""},
                             @{@"strIcon":@"more_QQ",@"strTitle":@"联系客服",@"strContent":@""},
                             @{@"strIcon":@"more_advice",@"strTitle":@"意见反馈",@"strContent":@""},
                             @{@"strIcon":@"more_HelpCenter",@"strTitle":@"帮助中心",@"strContent":@""}
                             ];//2152872885

        _arrData = [NSMutableArray arrayWithArray:tempArr];
    }
    return _arrData;
}
#pragma mark -- 提额
- (void)goIncreaseMoney{
    __weak typeof(self) Weakself = self;
    [self umengEvent:UmengEvent_Me_MoneyHelp];
    
        _alertView = [[DXAlertView alloc] initWithTitle:nil contentText:@"额度不够？赶紧提额吧！" leftButtonTitle:@"取消" rightButtonTitle:@"去提额"];
        _alertView.rightBlock = ^{
        
        CommonWebVC * vc = [[CommonWebVC alloc] init];
        vc.strAbsoluteUrl = Weakself.meModel.credit_info.shop_url ? Weakself.meModel.credit_info.shop_url : kSouyijieURL;
        //[Weakself dsPushViewController:vc animated:YES];
        [Weakself.navigationController pushViewController:vc animated:YES];

    };
    [_alertView show];
}

#pragma mark --  完善资料和借款记录跳转
- (void )btnClick:(UIButton *)sender {
    
    if ( 200 == sender.tag) {//完善资料
        [self umengEvent:UmengEvent_Me_material];
        [self.navigationController pushViewController:[[VerifyListVC alloc] init] animated:YES];
    } else if (201 == sender.tag) {//借款记录
        [self umengEvent:UmengEvent_Me_Record];
        RepaymentRecordVC * vc = [[RepaymentRecordVC alloc] init];
        [self dsPushViewController:vc animated:YES];
    }
    
}

#pragma mark --UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 15;
    }
    return 55 * WIDTHRADIUS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    if (cell == nil) {
        cell = [[MeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell updateTableViewCellWithdata:self.arrData index:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        //未实名认证不能点进去
        [self umengEvent:UmengEvent_Me_Bank];
        if ([self.meModel.verify_info.real_verify_status integerValue] == 0) {
            DXAlertView* alertView = [[DXAlertView alloc]initWithTitle:nil contentText:@"亲，请先填写个人信息哦～" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
            __weak __typeof(self)weakSelf = self;
            alertView.rightBlock = ^{
                VerifyListVC *verify = [[VerifyListVC alloc]init];
                [weakSelf dsPushViewController:verify animated:YES];
            };
            [alertView show];
            return;
        }
        //已经添加过卡的
        if ([self.meModel.verify_info.real_bind_bank_card_status integerValue]==1) {
            [self umengEvent:UmengEvent_Proceeds_Bank];
            CommonWebVC *web = [[CommonWebVC alloc]init];
            web.strAbsoluteUrl = self.meModel.card_url;
            [self dsPushViewController:web animated:YES];
            return;
        }
            CommonWebVC * vc = [[CommonWebVC alloc] init];
            vc.strAbsoluteUrl = self.meModel.card_url;
            [self dsPushViewController:vc animated:YES];
    }
//    else if(indexPath.row == 2){
//    
//        CommonWebVC *web = [[CommonWebVC alloc]init];
////        web.strTitle = @"我的邀请码";
//        web.strAbsoluteUrl = [NSString stringWithFormat:@"%@%@",Url_Server,@"/page/detail"];
//        [self dsPushViewController:web animated:YES];
//    }
    else if(indexPath.row == 2){//推荐给好友
        [self umengEvent:UmengEvent_Me_Share];
        __weak typeof(self) weakSelf = self;
        KDShareEntity *entitys = [KDShareEntity yy_modelWithDictionary:@{
                                                                         @"shareBtnTitle":@"分享",
                                                                         @"isShare":@"1",
                                                                         @"share_title":weakSelf.meModel.share_title ? weakSelf.meModel.share_title : @"",
                                                                         @"share_body":weakSelf.meModel.share_body ? weakSelf.meModel.share_body :@"",
                                                                         @"share_logo":weakSelf.meModel.share_logo ? weakSelf.meModel.share_logo :@"",
                                                                         @"sharePlatform":@[@"wx",@"wechatf",@"qq",@"qqzone"],
                                                                         @"share_url":weakSelf.meModel.share_url ? weakSelf.meModel.share_url : @""}];
        
        [[KDShareManager shareManager]showWithShareEntity:entitys];
        return;
        
    }else if (indexPath.row == 3){//消息中心
        [self umengEvent:UmengEvent_Me_Message];
        CommonWebVC *web = [[CommonWebVC alloc]init];
        web.strAbsoluteUrl = [NSString stringWithFormat:@"%@%@",Url_Server,@"/content/activity"];
        [self dsPushViewController:web animated:YES];
        
    }else if (indexPath.row == 4){//联系客服
        //初始化信息
        [self umengEvent:UmengEvent_Me_Contacts];
        
        //弹框提示通过QQ还是通过电话
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil  preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * cancelAC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * QQ = [UIAlertAction actionWithTitle:@"在线客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self contactQQ];
            
        }];
        UIAlertAction * phone = [UIAlertAction actionWithTitle:@"客服电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self contectByPhone];
            
        }];
        
        [alertVC addAction:cancelAC];
        [alertVC  addAction:QQ];
        [alertVC  addAction:phone];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else if (indexPath.row == 5){//意见反馈
        [self umengEvent:UmengEvent_Me_FeedBack];
        FeedBackVC *vcFeedBack = [[FeedBackVC alloc]init];
        vcFeedBack.meModel = _meModel;
        [self dsPushViewController:vcFeedBack animated:YES];
        
    }else if (indexPath.row == 6) {//帮助中心
        CommonWebVC *web = [[CommonWebVC alloc]init];
        web.strTitle = @"帮助中心";
        [self umengEvent:UmengEvent_Me_Help];
        web.strAbsoluteUrl = [NSString stringWithFormat:@"%@%@",Url_Server,@"/help"];
//        web.strAbsoluteUrl = @"www.registerQimo.com";
        [self dsPushViewController:web animated:YES];
    }
}

-(void)contectByPhone{
    NSMutableString * str = [NSMutableString stringWithFormat:@"tel:%@",self.meModel.service.service_phone];
    UIWebView * callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)contactQQ
{
//    if ( ![QQApiInterface isQQInstalled]) {
//        //没有安装QQ
//        [[[DXAlertView alloc] initWithTitle:@"" contentText:@"跳转异常，请确认是否安装过qq" leftButtonTitle:nil rightButtonTitle:@"确认"] show];
//    }
//
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    // 提供uin, 你所要联系人的QQ号码
//    NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", DSStringValue(self.meModel.service.qq_group) ];
//    NSURL *url = [NSURL URLWithString:qqstr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
//    [self.view addSubview:webView];
    self.title = @"返回";
    
    QYSource *source = [[QYSource alloc] init];
    source.title = @"小鱼儿";
    source.urlString = @"https://8.163.com/";
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"小鱼儿客服";
    sessionViewController.source = source;
    sessionViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sessionViewController animated:YES];
    
    //            UserModel *userModel =  [[KDCacheManager sharedCacheManager] getCacheObjectWithKey:LoginUser];
    //            if (userModel.username.length==11) {
    //                QYUserInfo *userInfo = [[QYUserInfo alloc]init];
    //                userInfo.userId = userModel.username;
    //                userInfo.data = [NSString stringWithFormat:@"[{\"key\":\"real_name\", \"value\":\"%@\"}]",userModel.username];
    //                [[QYSDK sharedSDK] setUserInfo:userInfo];
    //            }

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"registerQimo" object:nil];
}

    // Do any additional setup after loading the view.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
