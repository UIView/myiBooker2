//
//  DYbookBaseTableViewController.h
//  iBooker2
//
//  Created by Yahui Duan on 16/11/11.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYBookerListTableViewCell.h"

extern NSString *const kCellIdentifier;

@class DYBookModel;
@interface DYbookBaseTableViewController : UITableViewController
-(void)pushToDetailVC:(DYBookModel *)model;
@end
