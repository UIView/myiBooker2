//
//  DYBookHomeWebViewController.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/22.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYBookHomeWebViewController.h"
#import <WebKit/WebKit.h>
#import "Ono.h"
#import "DYBookPageModel.h"
#import "DYFileManageHelp.h"


@interface DYBookHomeWebViewController ()<WKNavigationDelegate,NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pageUrlTextField;
@property WKWebView *webView;
@property NSMutableArray *textData;
@property NSMutableArray *pagesData;

@property NSMutableString *textString;

@end

@implementation DYBookHomeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textData=[NSMutableArray array];
    _textString=[[NSMutableString alloc] init];
    _pagesData=[NSMutableArray array];
    [self setLeftNavButtonAction];
//    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadWebView{
    NSString * listPath =[[NSBundle mainBundle] pathForResource:@"ReadTextResourcesList" ofType:@"plist"];
    NSArray *matchLists =[NSArray arrayWithContentsOfFile:listPath];
    NSDictionary *pagesDic = matchLists[0];
    NSString *pagesURL = pagesDic[@"book_pages_url"];
    NSLog(@"count = %@",pagesURL);
    WKWebViewConfiguration *bookConfig = [[WKWebViewConfiguration alloc] init];
    WKWebView *testWebView =[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:bookConfig];
    testWebView.navigationDelegate=self;
    [self.view addSubview:testWebView];
    NSString *urlString =@"";
    NSURLRequest *urlRequest =[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [testWebView loadRequest:urlRequest];
    self.webView=testWebView;
    
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
    NSURLRequest *testRequest = navigationAction.request;
    NSLog(@"NavigationAction =%@",testRequest.allHTTPHeaderFields);

}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"navigationResponse =%@",navigationResponse.response);
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"didStartProvisionalNavigation");
    self.pageUrlTextField.text = webView.URL.absoluteString;
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
     NSLog(@"didFinishNavigation");
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
     NSLog(@"webView load didFailNavigation");
}
#pragma mark - Download
-(void)downloadTempText{
    NSString * listPath =[[NSBundle mainBundle] pathForResource:@"ReadTextResourcesList" ofType:@"plist"];
    NSArray *matchLists =[NSArray arrayWithContentsOfFile:listPath];
    NSDictionary *pagesDic = matchLists[1];
    NSString *pagesURL = pagesDic[@"book_pages_url"];
    NSString *pagespath = pagesDic[@"book_pages_path"];
    NSString *book_content_base_path = [[pagesURL componentsSeparatedByString:pagesDic[@"book_pages_c_url"]] firstObject];

    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:pagesURL]]; //下载网页数据
    NSStringEncoding enc_gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSChineseSimplif);
    NSString *downString =[[NSString alloc] initWithData:data encoding:enc_gbk];
    downString=[downString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    downString=[downString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    downString=[downString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    downString=[downString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    data=[downString dataUsingEncoding:4];

    NSError *error;
    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:&error];
    ONOXMLElement *countElement= [doc firstChildWithXPath:pagespath]; //
    [countElement.children enumerateObjectsUsingBlock:^(ONOXMLElement *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *pages = pagesDic[@"book_pages"];
        NSDictionary *subPageDic=pages[0];
        ONOXMLElement *itemElement= [obj firstChildWithXPath:subPageDic[@"book_page_title"]];
        if (itemElement) {
            NSString *pageString = [itemElement valueForAttribute:subPageDic[@"book_page_url"]];
            DYBookPageModel *bookModel =[[DYBookPageModel alloc] init];
            bookModel.pageTitle= itemElement.stringValue;
            bookModel.bookContentURL=[NSString stringWithFormat:@"%@%@",book_content_base_path,pageString];
            NSArray *pageNumbers =[pageString componentsSeparatedByString:@"."];
            if (pageNumbers.count>0) {
                bookModel.sorting=pageNumbers[0];
            }
            [_pagesData addObject:bookModel];

//            [self downloadSubContent:bookModel withPathDic:subPageDic];
        }
   
    }];
    if ([pagesDic[@"book_need_sort"] boolValue]) {
        // 升序
        [_pagesData sortUsingComparator:^NSComparisonResult(DYBookPageModel * obj1, DYBookPageModel * obj2) {
            NSInteger value1=[obj1.sorting integerValue];
            NSInteger value2=[obj2.sorting integerValue];
            return value1>value2;
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            [_pagesData enumerateObjectsUsingBlock:^(DYBookPageModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *pages = pagesDic[@"book_pages"];
                NSDictionary *subPageDic=pages[0];
                [self downloadSubContent:obj withPathDic:subPageDic];
                
            }];
        });
        
        NSLog(@"book_content string＝%@",countElement.stringValue);
   
        if (_textString) {
            
            NSData *textData =[_textString dataUsingEncoding:4];
            NSString *textPath =[DYFileManageHelp getCacheFilePathString:@"吞雷天尸.text"];
            BOOL isSucess=[textData writeToFile:textPath atomically:YES];
            NSLog(@"isSucess =%@",@(isSucess));
        }
    }
//    pagesURL=@"http://www.baidu.com";
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:pagesURL]];
    NSURLSessionDataTask * testDataTask=[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *downString =[[NSString alloc] initWithData:data encoding:enc];
        NSLog(@"down string＝%@",downString);
        
        NSError *xmlError;
        ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithString:downString encoding:4 error:&xmlError];
        ONOXMLElement *countElement= [doc firstChildWithXPath:pagespath]; //
        NSLog(@"countElement.stringValue \n＝%@",countElement.stringValue);

    }];
    [testDataTask resume];
//

}
-(void)downloadSubContent:(DYBookPageModel *)model withPathDic:(NSDictionary *)pagesDic{
    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:model.bookContentURL]]; //下载网页数据
    NSString *downString =[[NSString alloc] initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    downString=[downString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    downString=[downString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    data=[downString dataUsingEncoding:4];
    NSError *error;
    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:&error];
    ONOXMLElement *countElement= [doc firstChildWithXPath:pagesDic[@"book_content"]]; //
    if (countElement) {
        NSString *bookContent =countElement.stringValue;
        model.bookContent=bookContent;
        
        [_textString appendString:model.pageTitle];
        [_textString appendString:@"\n"];
        [_textString appendString:model.bookContent];
        NSLog(@"\n $$$$$$ text content  $$$$$$$$ \n ");

    }
    NSLog(@"text content = %@ ",model.pageTitle);


}
#pragma mark - Navigation

-(void)setLeftNavButtonAction{
    UIButton *leftBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftBtn addTarget:self action:@selector(clickNavLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIBarButtonItem *leftFixItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    leftFixItem.width=-10;
    [self.navigationItem setLeftBarButtonItems:@[leftFixItem,leftBtnItem]];
 
}
-(void)clickNavLeftBtn:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
// right nav button
- (IBAction)rightButtonAction:(id)sender {
    [self downloadTempText];
}

@end
