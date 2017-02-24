//
//  SXShoviewController.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights resShoved.
//


#import "SXShoviewController.h"
#import "SXShovCell.h"
#import "SXNetworkTools.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "JSDropDownMenu.h"
#import "SXBuviewController.h"

@interface SXShoviewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate,btnClickedDelegate>
{
    NSArray *temArray;
}
@property(nonatomic,strong) NSMutableArray *arrayList;

@property(nonatomic,strong) NSMutableArray *data1;
@property(nonatomic,strong) NSMutableArray *data2;
@property(nonatomic,strong) NSMutableArray *data3;
@property(nonatomic,strong) NSMutableArray *data4;

@property(nonatomic,assign) NSInteger currentData1Index;
@property(nonatomic,assign) NSInteger currentData2Index;
@property(nonatomic,assign) NSInteger currentData3Index;
@property(nonatomic,assign) NSInteger currentData4Index;

@property(nonatomic,assign)BOOL update;

@end

@implementation SXShoviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView addHeaderWithTarget:self action:@selector(loadData2)];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData2)];
    
    self.update = YES;
    
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:28/255.0 green:77/255.0 blue:153/255.0 alpha:1.0]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    self.navigationItem.title = @"商城";
    
    app.navid = 1;
    
    [[[SXNetworkTools sharedNetworkTools]GET:@"/list2.html" parameters:nil progress:nil success:^(NSURLSessionDataTask * task,NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        temArray = responseObject[key];
        
        JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 50) andHeight:49];
        
        if(temArray.count>0){
            NSMutableArray *dtile = temArray[0][@"extra"];
            _data1 = [NSMutableArray arrayWithObjects:temArray[0][@"title"], nil];
            int row;
            for(row=0;row<dtile.count;row++){
                [_data1 addObject:dtile[row][@"title"]];
            }
            
            if(temArray.count>1){
                NSMutableArray *dtile2 = temArray[1][@"extra"];
                _data2 = [NSMutableArray arrayWithObjects:temArray[1][@"title"], nil];
                int row2;
                for(row2=0;row2<dtile2.count;row2++){
                    [_data2 addObject:dtile2[row2][@"title"]];
                }
                
                if(temArray.count>2){
                    NSMutableArray *dtile3 = temArray[2][@"extra"];
                    _data3 = [NSMutableArray arrayWithObjects:temArray[2][@"title"], nil];
                    int row3;
                    for(row3=0;row3<dtile3.count;row3++){
                        [_data3 addObject:dtile3[row3][@"title"]];
                    }
                    
                    if(temArray.count>3){
                        NSMutableArray *dtile4 = temArray[3][@"extra"];
                        _data4 = [NSMutableArray arrayWithObjects:temArray[3][@"title"], nil];
                        int row4;
                        for(row4=0;row4<dtile4.count;row4++){
                            [_data4 addObject:dtile4[row4][@"title"]];
                        }
                    }
                }
            }
        }
        
        
        menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
        //menu.separatorColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        menu.textColor = [UIColor colorWithRed:85.f/255.0f green:85.f/255.0f blue:85.f/255.0f alpha:1.0f];
        
        menu.dataSource = self;
        menu.delegate = self;
        
        
        [self.view addSubview:menu];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
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
    NSString *allUrlstring = @"/shov.html";
    [self loadDataForType:1 withURL:allUrlstring];
}

- (void)loadMoreData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/shov/o%ld/%ld-%ld-%ld-%ld/%ld-20.html",(long)app.docimg,(long)_currentData1Index,(long)_currentData2Index,(long)_currentData3Index,(long)_currentData4Index,(long)(20 * app.navid)];
    //    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/%ld-20.html",self.urlString,self.arrayList.count];
    [self loadDataForType:2 withURL:allUrlstring];
}

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    //NSLog(@"%@",allUrlstring);

    //[[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask * task,NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray2 = responseObject[key];
        //[self.tableView headerBeginRefreshing];
        NSMutableArray *arrayM = [SXShovModel objectArrayWithKeyValuesArray:temArray2];
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (type == 1) {
            self.arrayList = arrayM;
            [self.tableView headerEndRefreshing];
            [self.tableView reloadData];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
            app.navid = app.navid+ 1;
        }else{
            self.arrayList = arrayM;
            [self.tableView headerEndRefreshing];
            [self.tableView reloadData];
            //[self viewDidLoad];
            
            //SXShoviewController *load2 =[[SXShoviewController alloc]init];
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    
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

-(void)buttonClick:(long)sender{
    NSString *allUrlstring = [NSString stringWithFormat:@"/shov/o%ld/%ld-%ld-%ld-%ld/0-20.html",sender,(long)_currentData1Index,(long)_currentData2Index,(long)_currentData3Index,(long)_currentData4Index];
    [self loadDataForType:1 withURL:allUrlstring];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXShovModel *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SXShovCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"NewsCell";
    }
    SXShovCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    cell.btnDelegate =self;
    
    return cell;
    
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXShovModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [SXShovCell heightForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        rowHeight = 50;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SXBuviewController *bu = segue.destinationViewController;
    bu.newsModel = self.arrayList[2];
    bu.index = self.tableView.indexPathForSelectedRow.row;
}

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return temArray.count;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }else if (column==1) {
        
        return _currentData2Index;
    }else if (column==2) {
        
        return _currentData3Index;
    }else{
        
        return _currentData4Index;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        return _data1.count;
        
    } else if (column==1){
        
        return _data2.count;
        
    } else if (column==2){
        
        return _data3.count;
    }else {
        
        return _data4.count;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return _data1[0];
            break;
        case 1: return _data2[0];
            break;
        case 2: return _data3[0];
            break;
        default:
            return _data4[0];
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        return _data1[indexPath.row];
    } else if (indexPath.column==1) {
        
        return _data2[indexPath.row];
        
    } else if (indexPath.column==2) {
        
        return _data3[indexPath.row];
        
    } else {
        
        return _data4[indexPath.row];
    }
}

-(void)alert:(NSString *)txt{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"lawker提示" message:txt preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"购物车" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"SXBuyiewController"];
        [self.navigationController pushViewController:jview animated:YES];
    }];
    
    UIAlertAction *Action2 = [UIAlertAction actionWithTitle:@"继续购买" style: UIAlertActionStyleDefault handler:nil];
    
    [alertCtrl addAction:Action];
    
    [alertCtrl addAction:Action2];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (IBAction)shop:(UIButton *)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.uid > 0){
        SXShovModel *arry = self.arrayList[2];
        [[[SXNetworkTools sharedNetworkTools]GET:[NSString stringWithFormat:@"/buy/%ld/%@/%@.html",(long)app.uid,app.pass,arry.listextra[sender.tag][@"docid"]] parameters:nil progress:nil success:^(NSURLSessionDataTask * task,NSDictionary* responseObject) {
            
            if([responseObject[@"null"] isEqualToString:@"ok"]){
                [self alert:@"添加成功"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //NSLog(@"%@",error);
        }] resume];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"FLO"];
        app.reh = @"1";
        [self.navigationController pushViewController:jview animated:YES];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        _currentData1Index = indexPath.row;
        
    } else if(indexPath.column == 1){
        
        _currentData2Index = indexPath.row;
        
    }  else if(indexPath.column == 2){
        
        _currentData3Index = indexPath.row;
        
    } else{
        
        _currentData4Index = indexPath.row;
    }
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/shov/o%ld/%ld-%ld-%ld-%ld/0-20.html",(long)app.docimg,(long)_currentData1Index,(long)_currentData2Index,(long)_currentData3Index,(long)_currentData4Index];
    [self loadDataForType:1 withURL:allUrlstring];
    [self.tableView reloadData];
}

@end
