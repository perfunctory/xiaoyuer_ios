//
//  PickerCell.m
//  MaYiYiDai
//
//  Created by sword on 2017/1/13.
//  Copyright © 2017年 innex. All rights reserved.
//

#import "PickerCell.h"

#import "TextFieldToolbar.h"

@interface PickerCell () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic, readwrite) UITextField *selectedItem;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (assign, nonatomic, readwrite) NSInteger selectedRow;

@end

@implementation PickerCell
@synthesize selectDes = _selectDes;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle selectDes:(NSString *)selectDes {
    
    if (self = [super initWithTitle:title subTitle:subTitle]) {
        
        _selectedRow = -1;
        self.selectedItem.text = selectDes;
        [self.contentView addSubview:self.selectedItem];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.selectedItem.translatesAutoresizingMaskIntoConstraints) {
        
        [self.selectedItem mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.rightIndicate.mas_left).with.offset(-kPaddingLeft);
//            make.left.equalTo(self.title.mas_right).with.offset(20);
            make.top.equalTo(self.contentView.mas_top).with.offset(kPaddingTop);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-kPaddingTop);
//            make.left.equalTo(self.contentView.mas_left).with.offset(90);
            
            
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.right.equalTo(self.contentView.mas_right).with.offset(-38);
        }];
        
        [self.selectedItem setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    }
}

- (NSInteger)selectedRow {
    
    return [self.pickerView selectedRowInComponent:0];
}
- (void)reloadPickerView {
    
    [self.pickerView reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return !self.numberOfRow ? : self.numberOfRow();
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return !self.stringOfRow ? @"" : self.stringOfRow(row);
}

- (void)setNumberOfRow:(NSInteger (^)())numberOfRow {
    _numberOfRow = [numberOfRow copy];
    
    [self.pickerView reloadAllComponents];
}
- (void)setStringOfRow:(NSString *(^)(NSInteger))stringOfRow {
    _stringOfRow = [stringOfRow copy];
    
    [self.pickerView reloadAllComponents];
}
- (void)setSelectDes:(NSString *)selectDes {
    self.selectedItem.text = selectDes;
}

- (NSString *)selectDes {
    return self.selectedItem.text;
}

- (UITextField *)selectedItem {
    
    if (!_selectedItem) {
        _selectedItem = [[UITextField alloc] init];
        
        _selectedItem.font = Font_Text_Label;
        _selectedItem.textColor = Color_SubTitle;
        _selectedItem.textAlignment = NSTextAlignmentRight;
        _selectedItem.tintColor = [UIColor clearColor];
        _selectedItem.inputView = self.pickerView;
        @Weak(self)
        _selectedItem.inputAccessoryView = [TextFieldToolbar textFieldToolbarWithConfirm:^{
            @Strong(self)
            
            [self.selectedItem endEditing:YES];
            self.selectedRow = [self.pickerView selectedRowInComponent:0];
            !self.didSelectBlock ? : self.didSelectBlock(self.selectedRow);
        } cancel:^{
            @Strong(self)
            
            [self.selectedItem endEditing:YES];
        }];
    }
    return _selectedItem;
}
- (UIPickerView *)pickerView {
    
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        
        _pickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];//[UIColor colorWithRed:0.412 green:0.412 blue:0.412 alpha:0.7];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

@end
