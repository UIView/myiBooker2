//
//  DYSearchResultsTableController.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/11.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYSearchResultsTableController.h"
#import "DYBookModel.h"

@interface DYSearchResultsTableController ()

@end

@implementation DYSearchResultsTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DYBookerListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BookerListCell" forIndexPath:indexPath];
    DYBookModel *model=self.filteredProducts[indexPath.row];
    [cell setBookerListData:model];
    NSInteger proCount = self.filteredProducts.count;
    
    if (indexPath.row+1==proCount) {
        // 自动加载
        if (self.delegate&&[self.delegate respondsToSelector:@selector(loadMoreSearchResults:)]) {
            [self.delegate loadMoreSearchResults:self];
        }
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DYBookModel *model=self.filteredProducts[indexPath.row];
    [self pushToDetailVC:model];
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
