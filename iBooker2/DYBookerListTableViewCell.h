//
//  DYBookerListTableViewCell.h
//  iBooker2
//
//  Created by Yahui Duan on 16/11/2.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYBookerListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

-(void)setBookerListData:(id)model;
@end
