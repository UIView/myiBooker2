//
//  DYBookDetailViewController.h
//  iBooker2
//
//  Created by Yahui Duan on 16/11/11.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, TDYReaderTransitionStyle) {
    TDYReaderTransitionStylePageCur,
    TDYReaderTransitionStyleScroll,
};

@class DYBookModel;
@interface DYBookDetailViewController : UIViewController
@property DYBookModel *bookModel;
@property (nonatomic,strong) NSURL *resourceURL;
@property (nonatomic, assign) TDYReaderTransitionStyle style;// 翻页样式

@end
