//
//  DYFileManageHelp.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/23.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYFileManageHelp.h"

NSString *const DYReadTextResourcesPath = @"BooksSource/ReadTextResourcesList.plist";

@implementation DYFileManageHelp
+(DYFileManageHelp *) shareFileManageHelp
{
    static DYFileManageHelp *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[DYFileManageHelp alloc] init];
    });
    return _instance;
}

+(NSString *)getDocumentFilePathString:(NSString *)fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}
+(NSString *)getCacheFilePathString:(NSString *)fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}
+ (BOOL)isHaveFileAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

#pragma mark - Books Source Path

+(NSArray *)getBooksSourcePath{
    NSString * listPath=nil;
    if ([DYFileManageHelp isHaveFileAtPath:DYReadTextResourcesPath]) {
        listPath =[DYFileManageHelp getCacheFilePathString:DYReadTextResourcesPath];
    }else{
       listPath =[[NSBundle mainBundle] pathForResource:@"ReadTextResourcesList" ofType:@"plist"];
    }
    NSArray *matchLists =[NSArray arrayWithContentsOfFile:listPath];
    return matchLists;
}
+(BOOL)changeBooksSourcePathData:(NSArray *)sources{
    NSString *path=[DYFileManageHelp getCacheFilePathString:DYReadTextResourcesPath];
    return [sources writeToFile:path atomically:YES];
}

@end
