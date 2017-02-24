//
//  SXZhiboiewController.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//


#import "SXZhiboiewController.h"
#import "SXZhiboCell.h"
#import "SXNetworkTools.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"

@interface SXZhiboiewController ()<UITableViewDataSource,UITableViewDelegate,btnClickedDelegate>

@property(nonatomic,strong) NSMutableArray *arrayList;

@property(nonatomic,assign)BOOL update;

@end

@implementation SXZhiboiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadData2)];
    
    self.update = YES;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(app.ztitle){
        self.navigationItem.title = app.ztitle;
        [self.tableView addFooterWithTarget:self action:@selector(loadMoreData2)];
    }else{
        self.navigationItem.title = @"精选直播课";
    }
    
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
    NSString *allUrlstring = [NSString stringWithFormat:@"/zhibo/%ld.html",(long)(long)app.navcid];
    NSLog(@"%@",allUrlstring);
    [self loadDataForType:1 withURL:allUrlstring];
}

- (void)loadMoreData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/zhibo/%ld/%ld-20.html",(long)(long)app.navcid,(long)(20 * app.navid)];
   
    [self loadDataForType:2 withURL:allUrlstring];
}

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        //[self.tableView headerBeginRefreshing];
        NSMutableArray *arrayM = [SXZhiboModel objectArrayWithKeyValuesArray:temArray];

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
            
            //SXZhiboiewController *load2 =[[SXZhiboiewController alloc]init];
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"News" bundle:nil];
        UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"AdvancedBarrageController"];
        [self.navigationController pushViewController:jview animated:YES];    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXZhiboModel *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SXZhiboCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"NewsCell";
    }
    SXZhiboCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    cell.btnDelegate =self;
    
    return cell;
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXZhiboModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [SXZhiboCell heightForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        rowHeight = 90;
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

//- (BOOL)shouldAutorotate {
//    return NO;
//}

@end
