//
//  DYSearchResultsTableController.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/11.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYSearchResultsTableController.h"
#import "DYBookModel.h"
#import <MJRefresh/MJRefreshAutoFooter.h>

@interface DYSearchResultsTableController ()

@end

@implementation DYSearchResultsTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        // 自动加载
        if (self.delegate&&[self.delegate respondsToSelector:@selector(loadMoreSearchResults:)]) {
            [self.delegate loadMoreSearchResults:self];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFilteredProducts:(NSArray *)filteredProducts{
    _filteredProducts=filteredProducts;
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DYBookerListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BookerListCell" forIndexPath:indexPath];
    DYBookModel *model=self.filteredProducts[indexPath.row];
    [cell setBookerListData:model];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSelectIndex:)]) {
        [self.delegate didSelectIndex:indexPath];
    }
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
