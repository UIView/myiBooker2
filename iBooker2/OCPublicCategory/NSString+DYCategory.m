//
//  NSString+DYCategory.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/25.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "NSString+DYCategory.h"

@implementation NSString (DYCategory)

-(NSStringEncoding)stringToConvertIANACharSetName{
    CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)self);
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
    return encoding;
}
@end
