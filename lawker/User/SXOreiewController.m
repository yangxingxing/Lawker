//
//  SXOreiewController.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//


#import "SXOreiewController.h"
#import "SXOreCell.h"
#import "SXNetworkTools.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"

@interface SXOreiewController ()<UITableViewDataSource,UITableViewDelegate,btnClickedDelegate>

@property(nonatomic,strong) NSMutableArray *arrayList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign)BOOL update;
@property (weak, nonatomic) IBOutlet UIImageView *noimg;

@end

@implementation SXOreiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadData2)];
    
    self.update = YES;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData2)];
    self.navigationItem.title = @"我的订单";
    //[self.tableView setEditing:YES animated:YES];

    app.navid = 1;
    
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
    NSString *allUrlstring = [NSString stringWithFormat:@"/ore/%ld/%@.html",(long)app.uid,app.pass];
    [self loadDataForType:1 withURL:allUrlstring];
}

- (void)loadMoreData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/ore/%ld/%@/%ld-20.html",(long)app.uid,app.pass,(long)(20 * app.navid)];
   
    [self loadDataForType:2 withURL:allUrlstring];
}

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        //[self.tableView headerBeginRefreshing];
        NSMutableArray *arrayM = [SXOreModel objectArrayWithKeyValuesArray:temArray];

        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (type == 1) {
            self.arrayList = arrayM;
            [self.tableView headerEndRefreshing];
            [self.tableView reloadData];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
            app.navid = app.navid +1;
        }else{
            self.arrayList = arrayM;
            [self.tableView headerEndRefreshing];
            [self.tableView reloadData];
            //[self viewDidLoad];
            
            //SXOreiewController *load2 =[[SXOreiewController alloc]init];
            //load2.self.arrayList = arrayM;
            //[load2.self.tableView reloadData];
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

-(void)buttonClick{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.arrayList.count==0){_noimg.hidden = NO;}else{_noimg.hidden = YES;}
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXOreModel *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SXOreCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"NewsCell";
    }
    SXOreCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    cell.btnDelegate =self;
    
    return cell;
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXOreModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [SXOreCell heightForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        rowHeight = 115;
    }
    
    return rowHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor yellowColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXOreModel *newsModel = self.arrayList[indexPath.row];
    if([newsModel.tai isEqualToString:@"未支付"]){
    if (!self.tableView.isEditing)
    {
        return UITableViewCellEditingStyleDelete;
    }    
    }
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SXOreModel *newsModel = self.arrayList[indexPath.row];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/dore/%ld/%@/%@.html",(long)app.uid,app.pass,newsModel.docid];
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        if([temArray[0][@"null"] isEqualToString:@"ok"]){
            [self loadData2];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
    
}

@end
