//
//  DYSearchResultsTableController.h
//  iBooker2
//
//  Created by Yahui Duan on 16/11/11.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYbookBaseTableViewController.h"
@protocol DYSearchResultsTableControllerDelegate;
@interface DYSearchResultsTableController : DYbookBaseTableViewController
@property (nonatomic, strong) NSArray *filteredProducts;
@property id <DYSearchResultsTableControllerDelegate>delegate;
@end

@protocol DYSearchResultsTableControllerDelegate <NSObject>

-(void)loadMoreSearchResults:(DYSearchResultsTableController *)resultController;

@end
