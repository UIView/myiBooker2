//
//  DYBookModel.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/7.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYBookModel.h"

@implementation DYBookModel

+(NSString *)createDYBookModelSql{
    NSString * sql=@"CREATE TABLE IF NOT EXISTS t_books_tab (book_id INTEGER PRIMARY KEY,title text,book_date text,book_image text,book_descrip text,book_state text,author text,content_url text,reading_page integer,cache_page integer,reading_content text)";
    return sql;
}
@end
