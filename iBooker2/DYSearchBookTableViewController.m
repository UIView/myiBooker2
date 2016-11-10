//
//  DYSearchBookTableViewController.m
//  iBooker2
//
//  Created by Yahui Duan on 16/11/7.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "DYSearchBookTableViewController.h"
#import "DYBookModel.h"
#import "DYBookerListTableViewCell.h"
#import "Ono.h"

@interface DYSearchBookTableViewController ()<UISearchResultsUpdating,UISearchBarDelegate,UISearchControllerDelegate>
@property UISearchController *searchController;
@property UISearchBar *tempSearchBar;

@end

@implementation DYSearchBookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.tableView.rowHeight=88.0;
    _searchbooks=[[NSMutableArray alloc] init];
    self.title=@"";
    [self initSearchController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSearchController{
    DYSearchBookTableViewController *resultTVC = [[DYSearchBookTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *resultVC = [[UINavigationController alloc] initWithRootViewController:resultTVC];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:resultVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate=self;
    [self.searchController.searchBar sizeToFit];
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed

}
#pragma mark - searchResultsUpdater
// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}
#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length>0) {
        UINavigationController *nav= (UINavigationController *)self.searchController.searchResultsController;
        DYSearchBookTableViewController *resultTVC=(DYSearchBookTableViewController *)nav.viewControllers[0];
        resultTVC.tableView.tableHeaderView=nil;
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self loadSearchData:searchBar.text];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchbooks.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DYBookerListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BookerListCell" forIndexPath:indexPath];
    DYBookModel *model=_searchbooks[indexPath.row];
    [cell setBookerListData:model];
    return cell;
}

#pragma mark - data
-(void)loadSearchData:(NSString *)text{
    NSString *urlString= @"http://so.ybdu.com/cse/search?";
    text=[text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
    NSString *kUrlStr=[NSString stringWithFormat:@"%@q=%@&p=13&s=6637491585052650179&nsid=&entry=1",urlString,text];
    NSData *data= [NSData dataWithContentsOfURL:[NSURL URLWithString:kUrlStr]]; //下载网页数据
    
    NSError *error;
    ONOXMLDocument *doc=[ONOXMLDocument HTMLDocumentWithData:data error:&error];
//    ONOXMLElement *postsParentElement= [doc firstChildWithXPath:@"//*[@id='results']"]; //寻找该 XPath 代表的 HTML 节点,
    ONOXMLElement *countElement= [doc firstChildWithXPath:@"/html/body/div[1]/div[2]/div[2]/div/span"]; //
    NSLog(@"count = %@",[countElement stringValue]);
    
    //遍历其子节点,
    ONOXMLElement *element= [doc firstChildWithXPath:@"/html/body/div[1]/div[2]/div[2]/div/div[3]"]; //寻找该 XPath 代表的 HTML 节点,
    [element.children enumerateObjectsUsingBlock:^(ONOXMLElement *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj =%@",obj);
        DYBookModel *bookModel =[[DYBookModel alloc] init];
        ONOXMLElement *titleElement= [obj firstChildWithXPath:@"div[2]/h3/a"]; // 根据 XPath 获取含有文章标题的 a 标签
        bookModel.title=[titleElement valueForAttribute:@"title"];
        titleElement= [obj firstChildWithXPath:@"div[2]/div/p[4]/span[2]"];
        bookModel.bookStates=[titleElement stringValue];
        titleElement= [obj firstChildWithXPath:@"div[1]/a/img"];
        bookModel.bookIamgeStr=[titleElement valueForAttribute:@"src"];
        titleElement= [obj firstChildWithXPath:@"div[2]/p"];
        bookModel.bookDescription=[titleElement stringValue];
        titleElement= [obj firstChildWithXPath:@"div[2]/div/p[1]/span[2]"];
        bookModel.bookAuthor=[titleElement stringValue];
        [_searchbooks addObject:bookModel];
    }];
    
    [self.tableView reloadData];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
