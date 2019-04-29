//
//  VerifyListViewCell.m
//  XianjinXia
//
//  Created by 童欣凯 on 2018/2/25.
//  Copyright © 2018年 lxw. All rights reserved.
//

#import "VerifyListViewCell.h"
#import "VerifyListViewItem.h"

@interface VerifyListViewCell ()

@property (strong, nonatomic) NSArray<VerifyListViewItem *> *items;
@property (strong, nonatomic) VerifyListViewItem *personalItem;
@property (strong, nonatomic) VerifyListViewItem *contactsItem;
@property (strong, nonatomic) VerifyListViewItem *operatorItem;

@end

@implementation VerifyListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initializeCell];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializeCell];
}

- (void)initializeCell {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    
    self.items = @[self.personalItem, self.contactsItem, self.operatorItem];
    [self.contentView addSubview:self.personalItem];
    [self.contentView addSubview:self.contactsItem];
    [self.contentView addSubview:self.operatorItem];
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    NSInteger padding = 10;
    [self.items mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
    [self.items mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(self.operatorItem.mas_width);
        make.bottom.equalTo(self.contentView.mas_bottom).priorityMedium();
    }];
}

#pragma mark - Private Method
- (void)selectItem:(UIView *)sender {
    
    !self.selectedIndex ? : self.selectedIndex(0 == sender.tag ? nil : self.dataArray[sender.tag - 1], self.dataArray[sender.tag]);
}

#pragma mark - Setter
- (void)setDataArray:(NSArray<VerifyListModel *> *)dataArray {
    NSMutableArray<VerifyListModel *> *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < dataArray.count; ++i) {
        if ([dataArray[i].tag isEqualToString:@"8"]) {
            continue;
        }
        [array addObject:dataArray[i]];
    }
    
    _dataArray = array;
    if (self.items.count <= _dataArray.count) {
        for (NSInteger i = 0; i < self.items.count; ++i) {
            [self.items[i] configureBaseVerifyItemWithModel:_dataArray[i]];
        }
    }
}

#pragma mark - Getter
- (VerifyListViewItem *)personalItem {
    
    if (!_personalItem) {
        _personalItem = [VerifyListViewItem baseVerifyItemWithTarget:self action:@selector(selectItem:)];
        _personalItem.backgroundColor = Color_White;
        _personalItem.layer.cornerRadius = 5;
        _personalItem.tag = 0;
    }
    return _personalItem;
}

- (VerifyListViewItem *)contactsItem {
    
    if (!_contactsItem) {
        _contactsItem = [VerifyListViewItem baseVerifyItemWithTarget:self action:@selector(selectItem:)];
        _contactsItem.backgroundColor = Color_White;
        _contactsItem.layer.cornerRadius = 5;
        _contactsItem.tag = 1;
    }
    return _contactsItem;
}

- (VerifyListViewItem *)operatorItem {
    
    if (!_operatorItem) {
        _operatorItem = [VerifyListViewItem baseVerifyItemWithTarget:self action:@selector(selectItem:)];
        _operatorItem.backgroundColor = Color_White;
        _operatorItem.layer.cornerRadius = 5;
        _operatorItem.tag = 2;
    }
    return _operatorItem;
}

@end
