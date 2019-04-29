//
//  SelectContactsBookVC.m
//  XianjinXia
//
//  Created by XianJinXia on 2017/2/16.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SelectContactsBookVC.h"
#import "GetContactsBook.h"
#import "ContactsCell.h"

@implementation SelectContactsModel
@end

@interface SelectContactsBookVC ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchBar           * searchBar;
@property (nonatomic, strong) UITableView           * tbvMain;
@property (nonatomic, strong) NSMutableDictionary   * dictData;//原始数据 字典格式
@property (nonatomic, strong) NSArray               * arrTitle;
@property (nonatomic, strong) NSMutableArray        * arrDataSource;

@end

@implementation SelectContactsBookVC
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
    //创建视图等
    self.navigationItem.title = @"联系人";
    [self baseSetup:PageGobackTypePop];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tbvMain];
    [self.view updateConstraintsIfNeeded];
}

#pragma mark - 初始化数据源
- (void)setUpDataSource {
}

#pragma mark - 按钮事件

#pragma mark - Delegate
#pragma mark - UITableView DataSource
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _arrTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arrTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrDataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self getSectionHeaderWithSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsCell * cell = [ContactsCell contactsCellWithtableView:tableView];
    [cell configCellWithName:self.arrDataSource[indexPath.section][indexPath.row][@"name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBlock) {
        NSDictionary * dict = self.arrDataSource[indexPath.section][indexPath.row];
        NSString * name = dict[@"name"];
        NSString * phone = dict[@"mobile"];
        if ([phone rangeOfString:@":"].location != NSNotFound) {
            NSArray * arrTemp = [phone componentsSeparatedByString:@":"];
            phone = arrTemp.firstObject;
        }
        phone = [self phoneNumClear:phone];
        if (phone.length == 11) {
            if ([[phone substringToIndex:1] isEqualToString:@"1"]) {
                SelectContactsModel * model = [[SelectContactsModel alloc] init];
                model.name = name;
                model.phone = phone;
                self.selectBlock(model);
            }else {
                [self showMessage:@"选择手机号码有误，请重新选择!"];
                return;
            }
        }else {
            [self showMessage:@"选择手机号码有误，请重新选择!"];
            return;
        }
    }
    [self popVC];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - searchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self doSearchWith:searchBar.text];
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self doSearchWith:searchBar.text];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)doSearchWith:(NSString *)searchText {
    __weak typeof(self)weakself = self;
    self.arrTitle = [self.arrTitle mutableCopy];
    self.arrDataSource = [self.arrDataSource mutableCopy];
    if ([searchText isEqualToString:@""]) {
        self.arrTitle = [self.arrTitle mutableCopy];
        self.arrDataSource = [self.arrDataSource mutableCopy];
    }else
    {
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *indexArray = [NSMutableArray array];
        
        [self.arrTitle enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@",searchText];
            NSString *title = weakself.arrTitle[idx];
            NSArray *tempArr = [weakself.arrDataSource[idx] filteredArrayUsingPredicate:predicate];
            if (tempArr&&tempArr.count>0) {
                [array addObject:tempArr];
                if (![indexArray containsObject:title]) {
                    [indexArray addObject:title];
                }
            }
        }];
        self.arrTitle = indexArray;
        self.arrDataSource = array;
    }
    [self.tbvMain reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text = @"";
    self.arrTitle = [self.arrTitle mutableCopy];
    self.arrDataSource = [self.arrDataSource mutableCopy];
    [self.tbvMain reloadData];
    [searchBar resignFirstResponder];
}

//过滤手机号
- (NSString *)phoneNumClear:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}

#pragma mark - 请求数据
- (void)getDataSource {
    if ([[GetContactsBook shareControl] getPersonInfo] && [[GetContactsBook shareControl] sortMethod]) {
        _dictData = [[GetContactsBook shareControl] getPersonInfo];
        _titleArr = [[GetContactsBook shareControl] sortMethod];
        _cellData = [NSMutableArray arrayWithCapacity:0];
        
        __weak __typeof(self)weakSelf = self;
        [_titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * indexString = obj;
            NSInteger index = idx;
            [weakSelf.cellData addObject:[@[] mutableCopy]];
            NSArray * arrTemp = weakSelf.dictData[indexString];
            [arrTemp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf.cellData[index] addObject:obj];
            }];
        }];
    }
    
    _arrTitle = [_titleArr mutableCopy];
    _arrDataSource = [_cellData mutableCopy];
    [UserDefaults setObject:_arrDataSource.count ? _arrDataSource : @[] forKey:@"contacts"];
    [self.tbvMain reloadData];
}

#pragma mark - Other
- (void)updateViewConstraints {
    [super updateViewConstraints];
    if (self.tbvMain.translatesAutoresizingMaskIntoConstraints) {
        __weak __typeof(self)weakSelf = self;
        [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left);
            make.right.equalTo(weakSelf.view.mas_right);
            make.top.equalTo(weakSelf.view.mas_top);
            make.height.equalTo(@40);
        }];
        [self.tbvMain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.searchBar.mas_bottom);
            make.left.equalTo(weakSelf.view.mas_left);
            make.right.equalTo(weakSelf.view.mas_right);
            make.bottom.equalTo(weakSelf.view.mas_bottom);
        }];
    }
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
    }
    return _searchBar;
}

- (UITableView *)tbvMain {
    if (!_tbvMain) {
        _tbvMain = [[UITableView alloc] init];
        _tbvMain.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbvMain.delegate = self;
        _tbvMain.dataSource = self;
    }
    return _tbvMain;
}

- (UIView *)getSectionHeaderWithSection:(NSInteger)section {
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = Color_TABBG;
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    lbl.textColor = Color_Title;
    lbl.font = Font_SubTitle;
    lbl.text = _arrTitle[section];
    [view addSubview:lbl];
    return view;
}

@end
