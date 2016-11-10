//
//  DYBookerListTableViewCell.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/2.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYBookerListTableViewCell.h"
#import "DYBookModel.h"
#import <UIImageView+AFNetworking.h>

@implementation DYBookerListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.subtitleLabel.font=[UIFont systemFontOfSize:14.0];
    self.subtitleLabel.textColor =[UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setBookerListData:(DYBookModel *)model{
    
    [self.leftImageView setImageWithURL:[NSURL URLWithString:model.bookIamgeStr] placeholderImage:[UIImage imageNamed:@"bookerNoImage"]];
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.bookDescription;
}
@end
