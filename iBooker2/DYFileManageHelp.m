//
//  DYFileManageHelp.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/23.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYFileManageHelp.h"

@implementation DYFileManageHelp
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
@end
