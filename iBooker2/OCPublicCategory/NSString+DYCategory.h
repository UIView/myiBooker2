//
//  NSString+DYCategory.h
//  iBooker2
//
//  Created by Yahui Duan on 16/11/25.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DYCategory)
/// 将编码（utf-8...）名字转为 NSStringEncoding
-(NSStringEncoding)stringToConvertIANACharSetName;

@end
