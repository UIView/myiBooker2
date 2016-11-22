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


@interface DYBookHomeWebViewController ()<WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pageUrlTextField;
@property WKWebView *webView;
@property NSMutableArray *textData;
@property NSMutableString *textString;

@end

@implementation DYBookHomeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textData=[NSMutableArray array];
    _textString=[[NSMutableString alloc] init];
    [self setLeftNavButtonAction];
    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadWebView{
    WKWebViewConfiguration *bookConfig = [[WKWebViewConfiguration alloc] init];
    WKWebView *testWebView =[[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:bookConfig];
    testWebView.navigationDelegate=self;
    [self.view addSubview:testWebView];
    NSString *urlString =@"http://m.baidu.com";
    NSURLRequest *urlRequest =[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [testWebView loadRequest:urlRequest];
    self.webView=testWebView;
}
#pragma mark - WKNavigationDelegate
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
    NSDictionary *pagesDic = matchLists[0];
    NSString *pagesURL = pagesDic[@"book_pages_url"];
    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:pagesURL]]; //下载网页数据
    NSError *error;
    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:&error];
    ONOXMLElement *countElement= [doc firstChildWithXPath:pagesDic[@"book_pages_path"]]; //
    NSLog(@"count = %@",[countElement stringValue]);
//    [countElement.children enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        DYBookPageModel *bookModel =[[DYBookPageModel alloc] init];
//        NSArray *pages = pagesDic[@"book_pages"];
//        NSDictionary *pageDic=pages[0];
//        ONOXMLElement *titleElement= [obj firstChildWithXPath:pageDic[@"book_page_title"]]; // 根据 XPath 获取含有文章标题的 a 标签
//        bookModel.pageTitle= titleElement.stringValue;
//        NSString *pageString = [titleElement valueForAttribute:pageDic[@"book_page_url"]];
//        bookModel.bookContentURL=[NSString stringWithFormat:@"http://www.bxwx8.org/b/58/58148/%@",pageString];
////        [self downloadSubContent:bookModel withPathDic:pageDic];
//        
//    }];

}
-(void)downloadSubContent:(DYBookPageModel *)model withPathDic:(NSDictionary *)pagesDic{
    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:model.bookContentURL]]; //下载网页数据
    NSError *error;
    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:&error];
    ONOXMLElement *countElement= [doc firstChildWithXPath:pagesDic[@"book_content"]]; //
    NSString *bookContent =countElement.stringValue;
    NSLog(@"text content = %@",bookContent);
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
