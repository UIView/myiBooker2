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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title= @"iBooker";
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.rowHeight=88.0;
    UINib *nib =[UINib nibWithNibName:@"" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:<#(nonnull NSString *)#>];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DYBookerListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BookerListCell" forIndexPath:indexPath];
    [cell setBookerListData:nil];
    return cell;
}

@end
