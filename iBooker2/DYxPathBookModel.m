//
//  DYxPathBookModel.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/11.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYxPathBookModel.h"

@implementation DYxPathBookModel
-(instancetype)initWithDic:(NSDictionary *)itemDic{
    self=[super init];
    if (self) {
        self.titlePath=@"";
        self.bookDatePath=@"";
        self.bookIamgeStrPath=@"";
        self.bookDescriptionPath=@"";
        self.bookAuthorPath=@"";
        self.bookStatesPath=@"";
    }
    return self;
}
@end

/*
 NSString *titlePath; //文章标题
 NSString *bookDatePath; //文章发表时间
 NSString *bookIamgeStrPath; //文章小图
 NSString *bookDescriptionPath; //文章简介
 NSString *bookAuthorPath; //文章作者
 NSString *bookStatesPath; //文章状态，是否完结
 */
