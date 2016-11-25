//
//  DYFileManageHelp.h
//  iBooker2
//
//  Created by Yahui Duan on 16/11/23.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface DYFileManageHelp : NSObject
@property FMDatabase *dbData;

+(DYFileManageHelp *) shareFileManageHelp;

///
+(NSString *)getDocumentFilePathString:(NSString *)fileName;
///
+(NSString *)getCacheFilePathString:(NSString *)fileName;
///
+ (BOOL)isHaveFileAtPath:(NSString *)path;
/// 获取最新的阅读源
+(NSArray *)getBooksSourcePath;
/// 保存切换过的源
+(BOOL)changeBooksSourcePathData:(NSArray *)sources;

#pragma mark - Sql Manage
//初始化数据库
-(void)initDatabase;

-(BOOL)insertBooksToDB:(NSArray *)books;
-(BOOL)insertBookPageToDB:(NSArray *)pages withBookID:(NSInteger)bookID;

-(NSArray *)getDBCacheBooks;
-(NSArray *)getDBCacheBookPagesWithBookID:(NSInteger)bookID;
// 书
-(NSInteger)getDBCacheBookCount;
-(NSInteger)getDBCachePageCountWithBookID:(NSInteger)bookid;
/// 删除书，也删除了章节
-(BOOL)deleDBCacheBookWithBookID:(NSInteger)bookID;
/// 写在本地text。
-(BOOL)wirteTextToLocal:(NSInteger)bookID;
@end
