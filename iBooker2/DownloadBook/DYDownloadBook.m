//
//  DYDownloadBook.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/22.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYDownloadBook.h"
#import <AFNetworking/AFNetworking.h>

@implementation DYDownloadBook
-(void)downloadPageWithURL:(NSString *)urlString{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://httpbin.org/get"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
}
@end
