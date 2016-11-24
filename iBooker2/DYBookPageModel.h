//
//  DYBookPageModel.h
//  iBooker2
//
//  Created by Yahui Duan on 16/11/22.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYBookPageModel : NSObject
@property NSString *bookName; //书名
@property NSString *pageTitle; //文章章节标题
@property NSString *bookDate; //文章发表时间
@property NSString *bookContentURL; //文章章节地址
@property NSString *bookContent; //文章内容
@property NSString *sorting; // 排序

+(NSString *)createDYBookPageModelSql;

@end
