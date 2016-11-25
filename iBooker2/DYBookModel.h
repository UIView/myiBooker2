//
//  DYBookModel.h
//  iBooker2
//
//  Created by Yahui Duan on 16/11/7.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYBookModel : NSObject
@property NSInteger bookID; //文章标示
@property NSString *title; //文章标题
@property NSString *bookDate; //文章发表时间
@property NSString *bookIamgeStr; //文章小图
@property NSString *bookDescription; //文章简介
@property NSString *bookAuthor; //文章作者
@property NSString *bookStates; //文章状态，是否完结
@property NSString *bookContentUrl; //文章内容路径
@property NSInteger readingPage; //文章读取页数
@property NSInteger cachegPage; // 缓存文章页数
@property NSString *readingContent; //读取文章内容
// create
+(NSString *)createDYBookModelSql;
@end
