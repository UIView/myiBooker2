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
#import "DYBookModel.h"
#import "DYDBBaseHelp.h"
#import "NSString+HTML.h"
#import "GTMNSString+HTML.h"
#import "NSString+DYCategory.h"

@interface DYBookHomeWebViewController ()<WKNavigationDelegate,NSURLSessionDelegate,WKScriptMessageHandler>
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
    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadWebView{
    NSString * listPath =[[NSBundle mainBundle] pathForResource:@"ReadTextResourcesList" ofType:@"plist"];
    NSArray *matchLists =[NSArray arrayWithContentsOfFile:listPath];
    NSDictionary *pagesDic = matchLists[1];
    NSString *pagesURL = pagesDic[@"book_home_url"];
    NSLog(@"count = %@",pagesURL);
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
//    WKUserContentController *userController = [[WKUserContentController alloc] init];
//    NSString * adPath =[[NSBundle mainBundle] pathForResource:@"Adblock" ofType:@"js"];
//    
//    NSString *javascriptString = [NSString stringWithContentsOfFile:adPath encoding:NSUTF8StringEncoding error:nil];
//    WKUserScript *javascrip =[[WKUserScript alloc] initWithSource:javascriptString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
//    [userController addUserScript:javascrip];
//    
//    [userController addScriptMessageHandler:self name:@"didFinishLoading"];
//    
//    config.userContentController = userController;
    
    WKWebView *testWebView =[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:config];
    testWebView.navigationDelegate=self;
    testWebView.customUserAgent=@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:50.0) Gecko/20100101 Firefox/50.0";
    [self.view addSubview:testWebView];
    NSString *urlString =pagesURL;
    NSURLRequest *urlRequest =[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [testWebView loadRequest:urlRequest];
    self.webView=testWebView;
//    [self testDB];
}
-(void)testDB{
//
    DYBookModel *bookItem=[[DYBookModel alloc] init];
    bookItem.title=@"吞雷天尸";
    bookItem.bookDate=@"2014-09-08";
    bookItem.bookIamgeStr=@"http://www.23wx.com/files/article/image/25/25863/25863min.jpg";
    bookItem.bookDescription=@"华国F市，爆发的流星雨在星空之中纵横。某座居民楼天台上，沈从抱着陪伴自己多年的笔记本电脑，目光没有焦距的盯着夜空。没有亲人，朋友寥寥，一个人孤独的在这个城市中残喘着。流星的光芒在沈从的眼眸中闪烁，“如有可能，哪怕只是闪耀一时，也当无憾…”……………….";
    bookItem.bookAuthor=@"阳光男孩";
    bookItem.bookStates=@"完结";
    bookItem.bookContentUrl=@"";
    bookItem.readingPage=1;
    bookItem.cachegPage=0;
    bookItem.readingContent=@"dfdf";
    
    [[DYDBBaseHelp shareDBBaseHelp] insertBooksToDB:@[bookItem]];
    NSArray *bookPages=[[DYDBBaseHelp shareDBBaseHelp] getDBCacheBookPagesWithBookID:1];



}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURLRequest *testRequest = navigationAction.request;
//    if ([testRequest.URL.absoluteString hasPrefix:@"http://m.bxwx8.org"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
//    }else{
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }
    NSLog(@"NavigationAction =%@",testRequest);

}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    if (![navigationResponse.response.URL.absoluteString hasPrefix:@"http://m.bxwx8.org"]) {
        decisionHandler(WKNavigationResponsePolicyCancel);
        return;
    }
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
    NSStringEncoding enc_gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *downString =[[NSString alloc] initWithData:data encoding:enc_gbk];
    downString=[downString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    downString=[downString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    downString=[downString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    downString=[downString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

//    data=[downString dataUsingEncoding:4];

    NSError *error;
//    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:&error];
    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithString:downString encoding:enc_gbk error:&error];
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
            NSInteger bookID =[[DYDBBaseHelp shareDBBaseHelp] getDBCacheBookCount];
            [[DYDBBaseHelp shareDBBaseHelp] insertBookPageToDB:_pagesData withBookID:bookID];
        });
        
        NSLog(@"book_content string＝%@",countElement.stringValue);
        
    }

    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:pagesURL]];
    NSURLSessionDataTask * testDataTask=[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    }];
    [testDataTask resume];


}
-(void)downloadSubContent:(DYBookPageModel *)model withPathDic:(NSDictionary *)pagesDic{
    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:model.bookContentURL]]; //下载网页数据
    NSStringEncoding enc_gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *downString =[[NSString alloc] initWithData:data encoding:enc_gbk];
//    downString=[downString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    downString=[downString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    downString=[downString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    downString=[downString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *tempdata=[downString dataUsingEncoding:4];
    NSError *xmlError;
//    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:tempdata error:&xmlError];
    ONOXMLDocument *doc=[ONOXMLDocument XMLDocumentWithString:downString encoding:4 error:&xmlError];
    ONOXMLElement *countElement= [doc firstChildWithXPath:pagesDic[@"book_content"]]; //
    if (countElement.stringValue) {
        NSString *bookContent =[NSString stringWithFormat:@"%@\n%@",model.pageTitle,countElement.description];
         model.bookContent=bookContent;
        [_textString appendString:model.bookContent];
        [_textString appendString:@"\n"];
        NSLog(@"\n $$$$$$ text content  $$$$$$$$ \n ");
    }
    NSLog(@"text content = %@ ",model.pageTitle);
}
//-(void)downloadTextBeginPage:(NSInteger)beginPage toEndPage:(NSInteger)endPage{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        // 耗时的操作
//        NSArray *matchLists=[DYFileManageHelp getBooksSourcePath];
//        NSDictionary *pagesDic = matchLists[1];
//
//        [_pagesData enumerateObjectsUsingBlock:^(DYBookPageModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSArray *pages = pagesDic[@"book_pages"];
//            NSDictionary *subPageDic=pages[0];
//            [self downloadSubContent:obj withPathDic:subPageDic];
//        }];
//        NSInteger bookID =[[DYDBBaseHelp shareDBBaseHelp] getDBCacheBookCount];
//        [[DYDBBaseHelp shareDBBaseHelp] insertBookPageToDB:_pagesData withBookID:bookID];
//    });
//
//}

#pragma mark - Navigation

-(void)setLeftNavButtonAction{
    UIButton *leftBtn = [[UIButton alloc ]initWithFrame:CGRectMake(0, 0, 40, 35)];
    [leftBtn addTarget:self action:@selector(clickNavLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"btn_back_red"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIBarButtonItem *leftFixItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    leftFixItem.width=-10;
    [self.navigationItem setLeftBarButtonItems:@[leftFixItem,leftBtnItem]];
 
}
-(void)clickNavLeftBtn:(id)sender{
    [[DYDBBaseHelp shareDBBaseHelp] getDBCacheBooks];
    [self.navigationController popViewControllerAnimated:YES];
}
// right nav button
- (IBAction)rightButtonAction:(id)sender {
    [self downloadTempText];
}

@end
