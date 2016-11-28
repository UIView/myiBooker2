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
#import "DYDBBaseHelp.h"
#import "DYBookPageModel.h"
#import "DYBookModel.h"

@interface ViewController ()
@property NSMutableArray *readingBooks;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title= @"iBooker";
    self.tableView.tableFooterView=[[UIView alloc] init];
    NSArray *books=[[DYDBBaseHelp shareDBBaseHelp] getDBCacheBooks];
    self.readingBooks=[[NSMutableArray alloc] initWithArray:books];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBooksNotificationAction:) name:DYDBBaseBookNumberDidChange object:nil];
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

#pragma mark - Notification Action

-(void)addBooksNotificationAction:(NSNotification *)notifica{
    // 数据库处理
    NSDictionary *subDic = notifica.object;
    BOOL isAdd = [subDic[@"isAdd"] boolValue];
    if (isAdd) {
        [self.readingBooks removeAllObjects];
        NSArray *books=[[DYDBBaseHelp shareDBBaseHelp] getDBCacheBooks];
        self.readingBooks=[[NSMutableArray alloc] initWithArray:books];
        
    }else{
        for (int i=0; i<self.readingBooks.count; i++) {
            DYBookModel *itemModel=self.readingBooks[i];
            if (itemModel.bookID==[subDic[@"book"] integerValue]) {
                [self.readingBooks removeObject:itemModel];
                break;
            }
        }
    }
    [self.tableView reloadData];
}
@end
