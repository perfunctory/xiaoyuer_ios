//
//  VerifyListVC.m
//  KDFDApp
//
//  Created by haoran on 16/9/19.
//  Copyright © 2016年 cailiang. All rights reserved.
//

#import "VerifyListVC.h"

#import "PersonalInformationVC.h"
#import "PersonalContactsVC.h"

#import "BaseVerifyListCell.h"
#import "VerifyListCell.h"
#import "BankDataEncryptionView.h"
#import "VerifyListRequest.h"
#import "BindBankVC.h"
#import "CommonWebVC.h"
#import "GDLocationManager.h"
#import "WorkInfoVC.h"
#import "PersonalContactsVC.h"
#import "AuthMoreVC.h"
#import "VerifyListBottomView.h"

#define Verify_Cell_Height 65

@interface VerifyListVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (strong, nonatomic) BaseVerifyListCell *baseVerifyCell;
//@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic, strong) VerifyListBottomView *bottomView;
@property (nonatomic, retain) VerifyListRequest *request;

@property (nonatomic, retain) NSArray<VerifyListModel *> *optionDataArray;
@property (nonatomic, assign) NSInteger         real_verify_status;
@property (nonatomic, assign) NSInteger         contacts_status;

@end

@implementation VerifyListVC

#pragma mark - Lify Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self umengEvent:UmengEvent_Ver];
    [self baseSetup:PageGobackTypePop];
    self.navigationItem.title = @"认证中心";
    [self.view addSubview:self.tableView];
    [self.view updateConstraintsIfNeeded];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.baseVerifyCell.dataArray.count) {
        return kPointToTheTop == self.bottomView.direction ? 2 : 1;
//        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0 == section ? 1 : self.optionDataArray.count;
//    return  1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return self.baseVerifyCell;
    
    if (0 == indexPath.section) {
        return self.baseVerifyCell;
    } else {
        VerifyListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VerifyListCell class]) forIndexPath:indexPath];
        [cell configureVerifyListCellWithModel:self.optionDataArray[indexPath.row]];
        return cell;
    }
}

//隐藏更多信息认证
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == indexPath.section) {
        [self intoNextViewController:self.optionDataArray[indexPath.row]];
    }
}

#pragma mark - Private
- (void)loadData {
    
    [self.request fetchUserVerifyListWithDictionary:nil success:^(NSDictionary *dictResult) {

        [self.tableView.mj_header endRefreshing];
        
        self.baseVerifyCell.progress = [dictResult[@"item"][@"mustBeCount"] integerValue]/100.0;
        self.baseVerifyCell.dataArray = [self createModelData:dictResult[@"item"][@"isMustBeList"]];
        self.optionDataArray = [self createModelData:dictResult[@"item"][@"noMustBeList"]];
        self.real_verify_status = [dictResult[@"item"][@"real_verify_status"] integerValue];
        self.contacts_status = [dictResult[@"item"][@"contacts_status"] integerValue];
        
        [self.tableView reloadData];
        self.tableView.tableFooterView.hidden = NO;
    
    } failed:^(NSInteger code, NSString *errorMsg) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSArray *)createModelData:(NSArray *)aArr {
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSInteger  i = 0; i < [aArr count]; ++i) {
        
        [result addObject:[VerifyListModel verifyListModelWithDictionary:aArr[i]]];
    }
    
    return result;
}

- (void)intoNextViewController:(VerifyListModel *)model {
    
//tag=1 个人信息 tag=2 工作信息 tag=3 紧急联系人 tag=4收款信息 tag=5 手机运营商 tag=6 卡片等级 tag＝7 更多信息 tag=8 芝麻授信 tag=9 支付宝认证
    switch ([model.tag integerValue]) {
        case 1: {
                [self umengEvent:UmengEvent_Ver_PersonInfo];
                if ([GDLocationManager shareInstance].isOpenLocationServices == YES) {
                    [self.navigationController pushViewController:[[PersonalInformationVC alloc] init] animated:YES];
                } else {
                    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"请先打开您的定位权限！" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                    alert.rightBlock = ^{
                        [[ApplicationUtil sharedApplicationUtil] gotoSettings];
                    };
                    [alert show];
                }
            }
            break;
            
        case 2: {
                [self umengEvent:UmengEvent_Ver_WorkInfo];
                if ([GDLocationManager shareInstance].isOpenLocationServices == YES) {
                    WorkInfoVC *workInfoVC = [[WorkInfoVC alloc] init];
                    [self dsPushViewController:workInfoVC animated:YES];
                } else {
                    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:@"请先打开您的定位权限！" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                    alert.rightBlock = ^{
                        [[ApplicationUtil sharedApplicationUtil] gotoSettings];
                    };
                    [alert show];
                }
            }
            break;
            
        case 3:{
                [self umengEvent:UmengEvent_Ver_Contacts];
            
                if (self.real_verify_status != 1) {
                    [[[DXAlertView alloc] initWithTitle:nil contentText:@"亲，请先填写个人信息哦~" leftButtonTitle:nil rightButtonTitle:@"确定"] show];
                    return;
                }
            
                [self dsPushViewController:[[PersonalContactsVC alloc] init] animated:YES];
            }
            break;
            
        case 5: {
                [self umengEvent:UmengEvent_Ver_mobile];
                [self umengEvent:UmengEvent_Phone];
            
                if (self.real_verify_status != 1) {
                    [[[DXAlertView alloc] initWithTitle:nil contentText:@"亲，请先填写个人信息哦~" leftButtonTitle:nil rightButtonTitle:@"确定"] show];
                    return;
                }
            
                if (self.contacts_status != 1) {
                    [[[DXAlertView alloc] initWithTitle:nil contentText:@"亲，请完善写紧急联系人哦~" leftButtonTitle:nil rightButtonTitle:@"确定"] show];
                    return;
                }
            
                CommonWebVC *vc = [[CommonWebVC alloc]init];
                if (1 == model.status.integerValue) {
                    vc.strAbsoluteUrl = [NSString stringWithFormat:@"%@?recode=2",model.url];
                }else{
                    vc.strAbsoluteUrl = model.url;
                }
                [self dsPushViewController:vc animated:YES];
            }
            break;
            
        case 6:
            [self.navigationController pushViewController:[[AuthMoreVC alloc] init] animated:YES];
            break;
            
        case 7: {
                [self umengEvent:UmengEvent_Ver_Other];
                CommonWebVC * vc = [[CommonWebVC alloc] init];
                vc.strAbsoluteUrl = model.url;
                [self dsPushViewController:vc animated:YES];
            }
            break;
            
        case 8:{
                [self umengEvent:UmengEvent_Ver_ZM];
                [self umengEvent:UmengEvent_Auth_Taobao];
            
                if (self.real_verify_status != 1) {
                    [[[DXAlertView alloc] initWithTitle:nil contentText:@"亲，请先填写个人信息哦~" leftButtonTitle:nil rightButtonTitle:@"确定"] show];
                    return;
                }
            
                if (self.contacts_status != 1) {
                    [[[DXAlertView alloc] initWithTitle:nil contentText:@"亲，请完善写紧急联系人哦~" leftButtonTitle:nil rightButtonTitle:@"确定"] show];
                    return;
                }
            
                CommonWebVC * vc = [[CommonWebVC alloc] init];
                vc.strAbsoluteUrl = model.url;
                [self dsPushViewController:vc animated:YES];
            }
            break;
            
        case 9: {
                [self umengEvent:UmengEvent_Ver_Zfb];
                CommonWebVC * vc = [[CommonWebVC alloc] init];
                vc.strAbsoluteUrl = model.url;
                vc.strType = @"ZFB";
                [self dsPushViewController:vc animated:YES];
            }
            break;
    }
}

#pragma mark - Getter
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        
        [_tableView registerClass:[VerifyListCell class] forCellReuseIdentifier:NSStringFromClass([VerifyListCell class]) ];
        [_tableView registerClass:[BaseVerifyListCell class] forCellReuseIdentifier:NSStringFromClass([BaseVerifyListCell class])];
        _tableView.backgroundColor = Color_Background;
        _tableView.separatorColor = Color_LineColor;
//        _tableView.separatorColor = Color_Background;
        _tableView.sectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 65.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        _tableView.tableFooterView = self.bottomView;
        
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    return _tableView;
}

- (VerifyListRequest *)request {
    
    if (!_request) {
        _request = [[VerifyListRequest alloc] init];
    }
    return _request;
}

- (BaseVerifyListCell *)baseVerifyCell {
    
    if (!_baseVerifyCell) {
        _baseVerifyCell = [[BaseVerifyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([BaseVerifyListCell class])];
//        _baseVerifyCell.backgroundColor = Color_Background;
        
        @Weak(self)
        _baseVerifyCell.selectedIndex = ^(VerifyListModel *model) {
            @Strong(self)
            [self intoNextViewController:model];
        };
    }
    return _baseVerifyCell;
}

//查看更多信息完善项目按钮
//-(UIView *)bottomView{
//
//    if (!_bottomView) {
//
//        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//        _bottomView.hidden = YES;
//        UILabel * textL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, 10,150, 30)];
//        textL.textColor = Color_Red_New;
//        textL.text = @"银行级数据加密保护";
//        textL.font = FontSystem(12);
//        UIImageView * bankV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 75, 16, 14, 17)];
//        bankV.image = ImageNamed(@"KDVerify");
//
//        [_bottomView addSubview:textL];
//        [_bottomView addSubview:bankV];
//
//    }
//
//    return _bottomView ;
//
//}

//原来的按钮点击展开可收缩，目前注释 暂时不用
- (VerifyListBottomView *)bottomView {

    if (!_bottomView) {
        _bottomView = [VerifyListBottomView verifyListBottomView];
        _bottomView.hidden = YES;

        @Weak(self)
        _bottomView.directionButtonClicked = ^(kPointToThe currentDirection) {
            @Strong(self)

            if (kPointToTheTop == currentDirection) {
                [self umengEvent:UmengEvent_Ver_Less];
                self.bottomView.direction = kPointToTheBottom;
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
            } else {
                [self umengEvent:UmengEvent_Ver_More];
                self.bottomView.direction = kPointToTheTop;
                [self.tableView reloadData];
            }
        };
    }
    return _bottomView;
}

@end
