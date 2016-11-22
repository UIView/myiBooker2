//
//  DYBookDetailViewController.h
//  iBooker2
//
//  Created by Yahui Duan on 16/11/11.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DYBookModel;

@interface DYBookDetailViewController : UIViewController
@property DYBookModel *bookModel;
@property (nonatomic,strong) NSURL *resourceURL;
@end
