//
//  ViewController.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/2.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//
//  http://www.jianshu.com/p/4e6e42945f05 灵感来源

#import "ViewController.h"
#import "DYBookerListTableViewCell.h"
#import "DYFileManageHelp.h"
#import "DYBookPageModel.h"

@interface ViewController ()
@property NSMutableArray *readingBooks;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title= @"iBooker";
    self.tableView.tableFooterView=[[UIView alloc] init];
    NSArray *books=[[DYFileManageHelp shareFileManageHelp] getDBCacheBooks];
    self.readingBooks=[[NSMutableArray alloc] initWithArray:books];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.readingBooks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DYBookerListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BookerListCell" forIndexPath:indexPath];
    DYBookModel *model=self.readingBooks[indexPath.row];
    [cell setBookerListData:model];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DYBookModel *model=self.readingBooks[indexPath.row];
    [self pushToDetailVC:model];
}
@end
