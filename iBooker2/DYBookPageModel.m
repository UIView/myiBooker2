//
//  DYBookPageModel.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/22.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYBookPageModel.h"

@implementation DYBookPageModel

+(NSString *)createDYBookPageModelSql{
    NSString * sql=@"CREATE TABLE IF NOT EXISTS t_pages_tab (page_id INTEGER PRIMARY KEY,book_id integer,page_title text,page_url text,sorting text,content text)";
    return sql;
}
@end
