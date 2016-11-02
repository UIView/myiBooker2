//
//  DYBookerListTableViewCell.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/2.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYBookerListTableViewCell.h"

@implementation DYBookerListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setBookerListData:(id)model{
    self.leftImageView.image =[UIImage imageNamed:@"bookerNoImage"];
    self.titleLabel.text = @"测试数据01";
    self.subtitleLabel.text = @"测试数据详情0910";
}
@end
