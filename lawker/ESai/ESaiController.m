//
//  SXErviewController.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//


#import "SXDetailController.h"
#import "ESaiController.h"
#import "ESaiCell.h"
#import "SXNetworkTools.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"

@interface ESaiController ()

@property(nonatomic,strong) NSMutableArray *arrayList;

@property(nonatomic,assign)BOOL update;

@end

@implementation ESaiController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *url = [NSString stringWithFormat:@"http://localhost/erv/%@.html",self.newsModel.docid];    
    //[self.tableView addHeaderWithTarget:self action:@selector(loadData2)];
    self.update = YES;
    
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:28/255.0 green:77/255.0 blue:153/255.0 alpha:1.0]];
    self.navigationItem.title = @"筛选";
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(self.newsModel.docid){
        NSString *dev;
        dev = [NSString stringWithFormat:@"%@",self.newsModel.docid];
        app.docxid = dev;
    }

    //[self.tableView headerBeginRefreshing];
    
    //NSLog(@"%@",self.newsModel.title);
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(welcome) name:@"SXAdvertisementKey" object:nil];
    
//    [[SXHTTPManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        self.ertailModel = [SXErtailModel ertailWithDict:responseObject[self.newsModel.docid]];
//            
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"failure %@",error);
//    }];

}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)loadData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/erv/%@.html",self.newsModel.docid];
    if(self.newsModel.docid){
        allUrlstring = allUrlstring;
    }else{
        allUrlstring = app.allurl;
    }
    [self loadDataForType:1 withURL:allUrlstring];
}

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    NSLog(@"%@",allUrlstring);

    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        NSMutableArray *arrayM = [ESaiModel objectArrayWithKeyValuesArray:temArray];

        if (type == 1) {
            self.arrayList = arrayM;
            [self.tableView headerEndRefreshing];
            [self.tableView reloadData];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}

- (void)welcome
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"update"];
    [self.tableView headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"update"]) {
        return;
    }
        //NSLog(@"bbbb");
    if (self.update == YES) {
        [self.tableView headerBeginRefreshing];
        self.update = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESaiModel *newsModel = self.arrayList[indexPath.row];
    
    NSString *ID = [ESaiCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"NewsCell";
    }
    ESaiCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    return cell;
    
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESaiModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [ESaiCell heightForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        rowHeight = 50;
    }
    
    return rowHeight;
}

@end
