//
//  SetServerVC.m
//  XianjinXia
//
//  Created by 童欣凯 on 2018/3/12.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "SetServerVC.h"
#import "SetServerCell.h"

static NSString * const keyServerUrl = @"keyServerUrl";

@interface SetServerVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray            *arrayData;
@property (nonatomic, strong) UITableView               *tbvSetting;
@property (nonatomic, retain) UIView                    *footerView;
@property (nonatomic, retain) UIView                    *headerView;
@property (nonatomic, retain) UIView                    *bottomView;
@property (nonatomic, retain) UIButton                  *btnToMain;
@property (strong, nonatomic, readwrite) UITextField    *inputTextField;

@end

@implementation SetServerVC

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
}

#pragma mark - View创建与设置
- (void)setUpView {
    self.title = @"服务器地址";
    [self baseSetup:PageGobackTypeNone];
    
    //创建视图等
    //创建tableview
    _tbvSetting = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tbvSetting.delegate = self;
    _tbvSetting.dataSource = self;
    _tbvSetting.backgroundColor = [UIColor clearColor];
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12*WIDTHRADIUS)];
    _headerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1*WIDTHRADIUS)];
    _footerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    _tbvSetting.tableFooterView = _footerView;
    _tbvSetting.tableHeaderView = _headerView;
    
    [self.view addSubview:_tbvSetting];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160*WIDTHRADIUS)];
    _bottomView.backgroundColor = [UIColor clearColor];
    
    [_bottomView addSubview:self.inputTextField];
    [_bottomView addSubview:self.btnToMain];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomView.mas_top).offset(20);
        make.centerX.equalTo(_bottomView.mas_centerX);
        make.width.equalTo(_bottomView.mas_width);
        make.height.equalTo([self switchNumberWithFloat:46*WIDTHRADIUS]);
    }];
    self.inputTextField.text = [UserDefaults objectForKey:keyServerUrl];
    
    [self.btnToMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom).offset(16);
        make.centerX.equalTo(self.inputTextField.mas_centerX);
        make.width.equalTo([self switchNumberWithFloat:SCREEN_WIDTH-40]);
        make.height.equalTo([self switchNumberWithFloat:46*WIDTHRADIUS]);
    }];
    
    [self.btnToMain setTitleColor:Color_Red_New forState:UIControlStateNormal];
    self.btnToMain.backgroundColor = UIColorFromRGB(0xffffff);
    [self.btnToMain setTitle:@"进入应用" forState:UIControlStateNormal];
    self.btnToMain.layer.cornerRadius = 46*WIDTHRADIUS/2;
    self.btnToMain.layer.masksToBounds = YES;
    self.btnToMain.layer.borderWidth = 0.5;
    self.btnToMain.layer.borderColor = Color_Red_New.CGColor;
    [self.btnToMain addTarget:self action:@selector(gotoMain) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo([self switchNumberWithFloat:160*WIDTHRADIUS]);
    }];
    
    [self.view updateConstraintsIfNeeded];
}

#pragma mark - 更新UI约束  懒加载
- (void)updateViewConstraints {
    [super updateViewConstraints];
}

#pragma mark - 初始化数据源
- (void)setUpDataSource{
    [_arrayData removeAllObjects];
    _arrayData = [[NSMutableArray alloc]init];
    NSArray *array = @[
//                       @"http://api.jx-money.com/",//正式
//                       @"http://apitest.jx-money.com/",//预发布
//                       @"http://47.98.200.113:8081/",//测试
//                       @"http://47.99.203.25:8081/",//测试
                       @"http://47.97.97.48:8081/"//java测试
                       ];
    [_arrayData addObjectsFromArray:array];
    [_tbvSetting reloadData];
}

#pragma mark - Delegate

#pragma --mark tableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SetServerCell *cell = [SetServerCell homeCellWithTableView:tableView];
    if (indexPath.row < _arrayData.count) {
        [cell configCellWithStr:_arrayData[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55*WIDTHRADIUS;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Url_Server = [_arrayData objectAtIndex:indexPath.row];
    [UserDefaults setObject:Url_Server forKey:keyServerUrl];
    [self gotoTabbarController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoMain {
    if ([self stringIsNilOrEmpty:self.inputTextField.text]) {
        [[[DXAlertView alloc]initWithTitle:nil contentText:@"服务器地址为空" leftButtonTitle:nil rightButtonTitle:@"确定"] show];
    } else {
        Url_Server = self.inputTextField.text;
        [UserDefaults setObject:Url_Server forKey:keyServerUrl];
        [self gotoTabbarController];
    }
}

- (BOOL)stringIsNilOrEmpty:(NSString*)aString {
    if (!aString)
        return YES;
    return [aString isEqualToString:@""];
}

- (void)gotoTabbarController {
    if (self.start) {
        self.start();
    }
}

#pragma mark - Other
-  (UIButton *)btnToMain {
    if (!_btnToMain) {
        _btnToMain = [[UIButton alloc]init];
    }
    return _btnToMain;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.font = Font_Text_Label;
        _inputTextField.textColor = Color_SubTitle;
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        _inputTextField.backgroundColor = Color_White;
        _inputTextField.placeholder = @"请输入服务器地址";
        _inputTextField.delegate = self;
    }
    return _inputTextField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (NSNumber *)switchNumberWithFloat:(float)floatValue {
    return [NSNumber numberWithFloat:floatValue];
}

@end
