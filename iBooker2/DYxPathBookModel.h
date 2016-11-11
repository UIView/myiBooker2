//
//  DYxPathBookModel.h
//  iBooker2
//
//  Created by Yahui Duan on 16/11/11.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//
//  读取文章 xPath 路径

#import <Foundation/Foundation.h>

@interface DYxPathBookModel : NSObject
@property NSString *titlePath; //文章标题
@property NSString *bookDatePath; //文章发表时间
@property NSString *bookIamgeStrPath; //文章小图
@property NSString *bookDescriptionPath; //文章简介
@property NSString *bookAuthorPath; //文章作者
@property NSString *bookStatesPath; //文章状态，是否完结
-(instancetype)initWithDic:(NSDictionary *)itemDic;
@end
