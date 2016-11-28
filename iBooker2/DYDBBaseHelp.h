//
//  DYDBBaseHelp.h
//  iBooker2
//
//  Created by 段亚辉 on 16/11/25.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

extern NSString *const DYDBBaseBookNumberDidChange;

@interface DYDBBaseHelp : NSObject
@property FMDatabase *dbData;

+(DYDBBaseHelp *) shareDBBaseHelp;

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
