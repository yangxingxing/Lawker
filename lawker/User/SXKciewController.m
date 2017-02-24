//
//  SXKciewController.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//


#import "SXKciewController.h"
#import "SXKcCell.h"
#import "SXNetworkTools.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"

@interface SXKciewController ()<UITableViewDataSource,UITableViewDelegate,btnClickedDelegate>

@property(nonatomic,strong) NSMutableArray *arrayList;
@property(nonatomic,assign) NSInteger kc2;
@property(nonatomic,assign)BOOL update;
@property (weak, nonatomic) IBOutlet UITableView *t3;
@property (weak, nonatomic) IBOutlet UIButton *b11;
@property (weak, nonatomic) IBOutlet UIButton *b22;
@property (weak, nonatomic) IBOutlet UIButton *b33;
@property (weak, nonatomic) IBOutlet UIImageView *noimg;

@end

@implementation SXKciewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.t3.delegate = self;
    self.t3.dataSource = self;
    self.t3.separatorStyle = NO;
    
    [self.t3 addHeaderWithTarget:self action:@selector(loadData2)];
    
    [self.t3 addFooterWithTarget:self action:@selector(loadMoreData2)];
    
    self.update = YES;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.navigationItem.title = @"我的课程";
    
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
- (IBAction)b1:(id)sender {
    _kc2 = 0;
    [_b11 setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:77.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [_b22 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b33 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self loadData2];
}

- (IBAction)b2:(id)sender {
    _kc2 = 1;
    [_b11 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b22 setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:77.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [_b33 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self loadData2];
}

- (IBAction)b3:(id)sender {
    _kc2 = 2;
    [_b11 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b22 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b33 setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:77.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [self loadData2];
}

- (void)loadData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/kc/%ld/%ld/%@.html",(long)app.uid,(long)_kc2,app.pass];
    [self loadDataForType:1 withURL:allUrlstring];
}

- (void)loadMoreData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/kc/%ld/%ld/%@/%ld-20.html",(long)app.uid,(long)_kc2,app.pass,(long)(20 * app.navid)];
   
    [self loadDataForType:2 withURL:allUrlstring];
}

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        //[self.tableView headerBeginRefreshing];
        NSMutableArray *arrayM = [SXKcModel objectArrayWithKeyValuesArray:temArray];

        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (type == 1) {
            self.arrayList = arrayM;
            [self.t3 headerEndRefreshing];
            [self.t3 reloadData];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            
            [self.t3 footerEndRefreshing];
            [self.t3 reloadData];
            app.navid = app.navid +1;
        }else{
            self.arrayList = arrayM;
            [self.t3 headerEndRefreshing];
            [self.t3 reloadData];
            //[self viewDidLoad];
            
            //SXKciewController *load2 =[[SXKciewController alloc]init];
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
    [self.t3 headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"update"]) {
        return;
    }
        //NSLog(@"bbbb");
    if (self.update == YES) {
        [self.t3 headerBeginRefreshing];
        self.update = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}

-(void)buttonClick{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"News" bundle:nil];
    UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"AdvancedBarrageController"];
    //[self performSegueWithIdentifier:@"toReply" sender:self];
    //jview.dataSource = self;
    //jview.delegate = self;
    [self.navigationController pushViewController:jview animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.arrayList.count==0){_noimg.hidden = NO;}else{_noimg.hidden = YES;}
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXKcModel *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SXKcCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"Kc";
    }
    SXKcCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    cell.btnDelegate =self;
    
    return cell;
    
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXKcModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [SXKcCell heightForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        rowHeight = 200;
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
