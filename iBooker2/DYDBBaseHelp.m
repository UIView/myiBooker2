//
//  DYDBBaseHelp.m
//  iBooker2
//
//  Created by 段亚辉 on 16/11/25.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYDBBaseHelp.h"
#import "DYFileManageHelp.h"
#import "DYBookModel.h"
#import "DYBookPageModel.h"

static NSString *const DYReadDBPath = @"cacheBookdata.db";
NSString *const DYDBBaseBookNumberDidChange = @"DY_DBBaseBookNumberDidChange";

@implementation DYDBBaseHelp
+(DYDBBaseHelp *) shareDBBaseHelp
{
    static DYDBBaseHelp *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DYDBBaseHelp alloc] init];
    });
    return _instance;
}
//初始化数据库
-(void)initDatabase{
    NSString * dataPath=[DYFileManageHelp getDocumentFilePathString:DYReadDBPath];
    FMDatabase *dbData=[[FMDatabase alloc] initWithPath:dataPath];
    self.dbData=dbData;
    if ([DYFileManageHelp isHaveFileAtPath:dataPath]) {
        NSLog(@" db file is create: %@",dataPath);
        return;
    }
    if (![dbData open]) {
        NSLog(@"OPEN db failure");
    }
    
    [self.dbData beginTransaction];
    @try {
        NSString *booksTable=[DYBookModel createDYBookModelSql];
        NSString *bookPagesTable=[DYBookPageModel createDYBookPageModelSql];
        [self.dbData executeUpdate:booksTable];
        [self.dbData executeUpdate:bookPagesTable];
    } @catch (NSException *exception) {
        [self.dbData rollback];
        
    } @finally {
        [self.dbData commit];
    }
    [dbData close];
    NSLog(@"create db path:  %@",dataPath);
    
}
// 处理
-(BOOL)updateSqlArray:(NSMutableArray *)ary
{
    if (![self.dbData open]) {
        NSLog(@"打开数据库失败！");
        [self.dbData close];
        return NO;
    }
    @try {
        for (NSString * sqlStr in ary) {
            BOOL isSucess=[self.dbData executeUpdate:sqlStr];
            //            NSLog(@"%@",[NSString stringWithFormat:@"[SQL] %@",sqlStr]);
            NSLog(@"[sql]  db update %@",@(isSucess));
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"初始化数据库失败！");
        [self.dbData close];
        return NO;
    }
    @finally {
        [self.dbData close];
        return YES;
    }
}

// 这种写法默认格式化特殊字符
-(BOOL)insertBooksToDB:(NSArray *)books{
    if (books.count>0) {
        NSMutableArray *bookItems=[NSMutableArray array];
        for (DYBookModel *bookItem in books) {
            NSString *sql=[NSString stringWithFormat:@"replace into 'main'.'t_books_tab' ('title','book_date','book_image','book_descrip','book_state','author','content_url','reading_page','cache_page','reading_content') VALUES ('%@','%@','%@','%@','%@','%@','%@',%@,%@,'%@')",bookItem.title,bookItem.bookDate,bookItem.bookIamgeStr,bookItem.bookDescription,bookItem.bookStates,bookItem.bookAuthor,bookItem.bookContentUrl,@(bookItem.readingPage),@(bookItem.cachegPage),bookItem.readingContent];
            [bookItems addObject:sql];
        }
        BOOL isSucess=[self updateSqlArray:bookItems];
        NSDictionary *addDic = @{@"book":@"",@"isAdd":@YES};
        [[NSNotificationCenter defaultCenter] postNotificationName:DYDBBaseBookNumberDidChange object:addDic];
        return isSucess;
    }
    return NO;
}

-(BOOL)insertBookPageToDB:(NSArray *)pages withBookID:(NSInteger)bookID{
    
    if (bookID==0) {
        return NO;
    }
    if (pages.count>0) {
        NSMutableArray *bookItems=[NSMutableArray array];
        for (DYBookPageModel *pageItem in pages) {
            NSString *sql=[NSString stringWithFormat:@"replace into 'main'.'t_pages_tab' ('book_id','page_title','page_url','sorting','content') VALUES (%@,'%@','%@','%@','%@')",@(bookID),pageItem.pageTitle,pageItem.bookContentURL,pageItem.sorting,pageItem.bookContent];
            [bookItems addObject:sql];
        }
        return [self updateSqlArray:bookItems];
    }
    return NO;
}

-(NSArray *)getDBCacheBooks{
    
    if (![self.dbData open]) {
        NSLog(@"打开数据库失败！");
        [self.dbData close];
        return @[];
    }
    NSMutableArray *bookItems=[NSMutableArray array];
    NSString * sqlStr=@"select * from t_books_tab";
    NSLog(@"%@",[NSString stringWithFormat:@"[SQL] %@",sqlStr]);
    FMResultSet *resultSet = [self.dbData executeQuery:sqlStr];
    while ([resultSet next]) {
        DYBookModel *bookItem=[[DYBookModel alloc] init];
        bookItem.bookID=[resultSet longForColumn:@"book_id"]; //文章标题
        bookItem.title=[resultSet stringForColumn:@"title"]; //文章标题
        bookItem.bookDate=[resultSet stringForColumn:@"book_date"]; //文章发表时间
        bookItem.bookIamgeStr=[resultSet stringForColumn:@"book_image"]; //文章小图
        bookItem.bookDescription=[resultSet stringForColumn:@"book_descrip"]; //文章简介
        bookItem.bookAuthor=[resultSet stringForColumn:@"author"]; //文章作者
        bookItem.bookStates=[resultSet stringForColumn:@"book_state"]; //文章状态，是否完结
        bookItem.bookContentUrl=[resultSet stringForColumn:@"content_url"]; //文章内容路径
        bookItem.readingPage=[resultSet longForColumn:@"reading_page"]; //文章读取页数
        bookItem.cachegPage=[resultSet longForColumn:@"cache_page"]; // 缓存文章页数
        bookItem.readingContent=[resultSet stringForColumn:@"reading_content"]; //读取文章内容
        [bookItems addObject:bookItem];
    }
    
    [self.dbData close];
    return bookItems;
}
-(NSArray *)getDBCacheBookPagesWithBookID:(NSInteger)bookID{
    
    if (![self.dbData open]) {
        NSLog(@"打开数据库失败！");
        [self.dbData close];
        return @[];
    }
    if (bookID==0) {
        return @[];
    }
    NSMutableArray *bookItems=[NSMutableArray array];
    NSString * sqlStr=[NSString stringWithFormat:@"select * from t_pages_tab where book_id=%@",@(bookID)];
    NSLog(@"%@",[NSString stringWithFormat:@"[SQL] %@",sqlStr]);
    FMResultSet *resultSet = [self.dbData executeQuery:sqlStr];
    while ([resultSet next]) {
        DYBookPageModel *bookItem=[[DYBookPageModel alloc] init];
        bookItem.pageTitle=[resultSet stringForColumn:@"page_title"]; //文章章节标题
        bookItem.bookContentURL=[resultSet stringForColumn:@"page_url"]; //文章章节地址
        bookItem.bookContent=[resultSet stringForColumn:@"content"]; //文章内容
        bookItem.sorting=[resultSet stringForColumn:@"sorting"]; // 排序
        [bookItems addObject:bookItem];
    }
    [self.dbData close];
    return bookItems;
}
-(NSInteger)getDBCacheBookCount{
    if (![self.dbData open]) {
        NSLog(@"打开数据库失败！");
        [self.dbData close];
        return 0;
    }
    NSString * sqlStr=[NSString stringWithFormat:@"SELECT COUNT(*) FROM t_books_tab"];
    NSInteger count = [self.dbData intForQuery:sqlStr];
    [self.dbData close];
    return count;
}
-(NSInteger)getDBCachePageCountWithBookID:(NSInteger)bookid{
    if (![self.dbData open]) {
        NSLog(@"打开数据库失败！");
        [self.dbData close];
        return 0;
    }
    NSString * sqlStr=[NSString stringWithFormat:@"SELECT COUNT(book_id) AS CustomerNilsen FROM t_pages_tab WHERE book_id=%@",@(bookid)];
    NSInteger count = [self.dbData intForQuery:sqlStr];
    [self.dbData close];
    return count;
}
-(BOOL)deleDBCacheBookWithBookID:(NSInteger)bookID{
    if (![self.dbData open]) {
        NSLog(@"打开数据库失败！");
        [self.dbData close];
        return NO;
    }
    
    NSString * sqlStr=[NSString stringWithFormat:@"DELETE FROM t_books_tab WHERE book_id = %@",@(bookID)];
    BOOL isScuess=[self.dbData executeUpdate:sqlStr];
    sqlStr=[NSString stringWithFormat:@"DELETE FROM t_pages_tab WHERE book_id = %@",@(bookID)];
    isScuess=[self.dbData executeUpdate:sqlStr];
    [self.dbData close];
    NSDictionary *addDic = @{@"book":@[@(bookID)],@"isAdd":@NO};
    [[NSNotificationCenter defaultCenter] postNotificationName:DYDBBaseBookNumberDidChange object:addDic];
    NSLog(@"[sql] DELETE is %@",@(isScuess));
    return isScuess;
}
//
-(BOOL)wirteTextToLocal:(NSInteger)bookID{
    NSMutableString * _textString=[[NSMutableString alloc] init];
    NSArray *bookPages=[self getDBCacheBookPagesWithBookID:bookID];
    [bookPages enumerateObjectsUsingBlock:^(DYBookPageModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_textString appendString:obj.bookContent];
        [_textString appendString:@"\n"];
    }];
    
    if (_textString) {
        NSString *saveText=[_textString stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        saveText=[saveText stringByReplacingOccurrencesOfString:@"<div class=\"txt\" id=\"txt\">" withString:@"      "];
        saveText=[saveText stringByReplacingOccurrencesOfString:@"</div>" withString:@"      "];
        NSData *textData =[saveText dataUsingEncoding:4];
        NSString *sharePath=[NSString stringWithFormat:@"book%@.txt",@(bookID)];
        NSString *textPath =[DYFileManageHelp getDocumentFilePathString:sharePath];
        BOOL isSucess=[textData writeToFile:textPath atomically:YES];
        NSLog(@"path=\n %@ \nisSucess =%@",textPath,@(isSucess));
        return isSucess;
    }
    
    return NO;
}

@end
