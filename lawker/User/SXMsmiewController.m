//
//  SXMsmiewController.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//


#import "SXMsmiewController.h"
#import "SXMsmCell.h"
#import "SXNetworkTools.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"

@interface SXMsmiewController ()<UITableViewDataSource,UITableViewDelegate,btnClickedDelegate>

@property(nonatomic,strong) NSMutableArray *arrayList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *noimg;
@property(nonatomic,assign)BOOL update;

@end

@implementation SXMsmiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadData2)];
    
    self.update = YES;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData2)];
    self.navigationItem.title = @"消息中心";
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
    NSString *allUrlstring = [NSString stringWithFormat:@"/msm/%ld/%@.html",(long)app.uid,app.pass];
    [self loadDataForType:1 withURL:allUrlstring];
}

- (void)loadMoreData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/msm/%ld/%@/%ld-20.html",(long)app.uid,app.pass,(long)(20 * app.navid)];
   
    [self loadDataForType:2 withURL:allUrlstring];
}

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        //[self.tableView headerBeginRefreshing];
        NSMutableArray *arrayM = [SXMsmModel objectArrayWithKeyValuesArray:temArray];

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
            
            //SXMsmiewController *load2 =[[SXMsmiewController alloc]init];
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
    if(self.arrayList.count==0){_noimg.hidden = NO;}else{_noimg.hidden = YES;}
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXMsmModel *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SXMsmCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"NewsCell";
    }
    SXMsmCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    cell.btnDelegate =self;
    
    return cell;
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXMsmModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [SXMsmCell heightForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        rowHeight = 110;
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

@end
