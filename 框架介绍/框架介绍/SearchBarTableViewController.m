//
//  SearchBarTableViewController.m
//  框架介绍
//
//  Created by WinterChen on 16/3/3.
//  Copyright © 2016年 WinterChen. All rights reserved.
//

#import "SearchBarTableViewController.h"

@interface SearchBarTableViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    BOOL _editing;
    BOOL _moving;
    UITableViewCell *_insertCell;
    UIBarButtonItem *_DoneItem;
    NSArray *_editItems;
}

/**  输入框 */
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *listTeams;

@end

@implementation SearchBarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    self.navigationItem.rightBarButtonItems =
    _editItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editItemClick:)], [[UIBarButtonItem alloc] initWithTitle:@"Move" style:UIBarButtonItemStyleDone target:self action:@selector(editItemClick:)]];
    _DoneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(editItemClick:)];
    self.navigationItem.title = @"cell的插入、删除、移动";
    
    self.listTeams = [[NSMutableArray alloc] initWithObjects:@"黑龙江",
                      @"吉林", @"辽宁", nil];
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 300, 44)];
    self.textField.placeholder = @"添加";
    self.textField.delegate = self;
    
}

- (void)editItemClick:(UIBarButtonItem *)item
{
    _editing = !_editing;
    _moving = item.title ? YES : NO;
    _insertCell.contentView.hidden = _moving;
    [self.tableView setEditing:_editing animated:YES];
    if (_editing) {
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = _DoneItem;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = _editItems;
    }
}

#pragma mark --UITableViewDataSource协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listTeams count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row != self.listTeams.count) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.listTeams[indexPath.row];
    } else {
        [cell.contentView addSubview:self.textField];
        cell.contentView.hidden = !_editing;
        _insertCell = cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.listTeams removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self.listTeams insertObject:self.textField.text atIndex:[self.listTeams count]];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.textField.text = nil;
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.listTeams exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

#pragma mark --UITableViewDelegate协议方法
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == self.listTeams.count ? NO : YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _moving ? UITableViewCellEditingStyleNone : indexPath.row == self.listTeams.count ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _moving && indexPath.row != self.listTeams.count ?: NO;
}

#pragma mark -- UITextFieldDelegate委托方法，关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    [self.tableView setContentOffset:CGPointMake(0.0,cell.frame.origin.y) animated:YES];
}

@end
