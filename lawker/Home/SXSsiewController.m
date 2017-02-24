//
//  SXSsiewController.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//


#import "SXSsiewController.h"
#import "SXSsCell.h"
#import "SXNetworkTools.h"
#import "UIView+Frame.h"
#import "NSString+Base64.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"


@interface SXSsiewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,btnClickedDelegate>

@property(nonatomic,strong) NSMutableArray *arrayList;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *table2;

@property(nonatomic,assign)BOOL update;

@property(nonatomic,strong)NSArray<SXSsModel *> *searchListArray;

@end

@implementation SXSsiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.table2.delegate = self;
    self.table2.dataSource = self;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    app.navid = 1;    
    
}
- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
}

- (void)loadData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/ss/%@.html",app.title];
    [self loadDataForType:1 withURL:allUrlstring];
}

- (void)loadMoreData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/ss/%@/%ld-20.html",app.title,(long)(20 * app.navid)];
   
    [self loadDataForType:2 withURL:allUrlstring];
}

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{

    //NSLog(@"%@",allUrlstring);
    [self.table2 addHeaderWithTarget:self action:@selector(loadData2)];
    [self.table2 addFooterWithTarget:self action:@selector(loadMoreData2)];
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        NSMutableArray *arrayM = [SXSsModel objectArrayWithKeyValuesArray:temArray];
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (type == 1) {
            self.arrayList = arrayM;
            [self.table2 headerEndRefreshing];
            [self.table2 reloadData];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            
            [self.table2 footerEndRefreshing];
            [self.table2 reloadData];
            app.navid = app.navid + 1;
        }else{
            self.arrayList = arrayM;
            [self.table2 headerEndRefreshing];
            [self.table2 reloadData];
            //[self viewDidLoad];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:28.f/255.0f green:77.f/255.0f blue:153.f/255.0f alpha:1.0f];;
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"update"]) {
        return;
    }
        //NSLog(@"bbbb");
    if (self.update == YES) {
        [self.table2 headerBeginRefreshing];
        self.update = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}

- (IBAction)canBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    SXSsModel *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SXSsCell idForRow:newsModel];
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"NewsCell";
    }
    SXSsCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    cell.btnDelegate =self;
    
    return cell;
    
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXSsModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [SXSsCell heightForRow:newsModel];
    
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [searchBar resignFirstResponder];
    
    NSString *searchKeyWord = [searchBar.text base64encode];
    NSString *url = [NSString stringWithFormat:@"/ss/%@.html",searchKeyWord];
    NSLog(@"%@",url);
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.title = searchKeyWord;
                              
    [self loadDataForType:1 withURL:url];
}

@end
