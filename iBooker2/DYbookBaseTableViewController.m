//
//  DYbookBaseTableViewController.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/11.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYbookBaseTableViewController.h"
#import "DYBookDetailViewController.h"
#import "DYBookModel.h"

NSString *const kCellIdentifier = @"BookerListCell";
NSString *const kTableCellNibName = @"DYBookerListTableViewCell";

@interface DYbookBaseTableViewController ()

@end

@implementation DYbookBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.rowHeight=88.0;
    self.tableView.tableFooterView=[[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:kTableCellNibName bundle:nil] forCellReuseIdentifier:kCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)pushToDetailVC:(DYBookModel *)model{
    DYBookDetailViewController *detailVC=[[DYBookDetailViewController alloc] init];
    detailVC.title=model.title;
    detailVC.bookModel=model;
    detailVC.style=TDYReaderTransitionStyleScroll;
    [self.navigationController pushViewController:detailVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
