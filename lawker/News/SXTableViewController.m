//
//  SXTableViewController.m
//  lawker
//
//  Created by 董 尚先 on 15-1-22.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import "SXTableViewController.h"
#import "AdvancedBarrageController.h"
#import "SXErviewController.h"
#import "SXNewsCell.h"
#import "SXUrl.h"
#import "SXNetworkTools.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

@interface SXTableViewController ()<UIScrollViewDelegate>//,UITableViewDataSource,UITableViewDelegate>,banner2>


@property(nonatomic,strong) NSMutableArray *arrayList;

@property(nonatomic,strong) NSMutableArray *array2;

@property(nonatomic,assign)BOOL update;
@property(nonatomic,assign) int sender;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@end

@implementation SXTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadData)];
    
    self.update = YES;
    
    //NSInteger now = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *path = [NSString stringWithFormat:@"/banner.html"];
    
    __weak typeof(self) wSelf = self;
    [[[SXNetworkTools sharedNetworkTools]GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
            NSArray *adArray = [responseObject valueForKey:@"T1"];
        
            _array2 = adArray[0][@"imgextra"];
        
            [self banner:(NSArray *)adArray[0][@"imgextra"]];
        
        
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          [wSelf.tableView headerEndRefreshing];
                //NSLog(@"%@",error);
      }] resume];
}


- (void) banner:(NSArray *)Nayy{
    if([self.urlString isEqualToString:@"list/T1"]) {
        
        self.sender = (int)Nayy.count;
        
        for (int i = 0; i < self.sender; i++) {
            NSString *imageName = Nayy[i][@"imgsrc"];
            //NSLog(@"%@",imageName);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"302"]];
            //imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress)];
            [imageView addGestureRecognizer:singleTap1];
            
            [self.scrollView addSubview:imageView];
        }
        
        //计算imageView的位置
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
            
            //调整x ＝》 origin ＝》frame
            
            CGRect frame = imageView.frame;
            frame.origin.x = idx * ScreenWidth;
            imageView.frame = frame;
        }];
        //初始页数为0
        self.pageControl = 0;
        
        //启动时钟
        [self startTimer];
    }
}

-(void)buttonpress
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *nayy2 = _array2[self.pageControl.currentPage][@"url"];
    app.docurl = nayy2;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"News" bundle:nil];
    UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"webview"];    
    [self.navigationController pushViewController:jview animated:YES];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
}

- (void)welcome
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"update"];
    [self.tableView headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.allurl = @"";
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"update"]) {
        return;
    }
//    NSLog(@"bbbb");
    if (self.update == YES) {
        [self.tableView headerBeginRefreshing];
        self.update = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}

//- (void)num:(NSArray *)Nayy{
//    [self banner:Nayy];
//}

#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    NSString *allUrlstring = [NSString stringWithFormat:@"/%@/0-20.html",self.urlString];
    [self loadDataForType:1 withURL:allUrlstring];
}

// ------上拉加载
- (void)loadMoreData
{
    NSString *allUrlstring = [NSString stringWithFormat:@"/%@/%ld-20.html",self.urlString,(long)(self.arrayList.count - self.arrayList.count%10)];
//    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/%ld-20.html",self.urlString,self.arrayList.count];
    [self loadDataForType:2 withURL:allUrlstring];
}

// ------公共方法
- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        NSMutableArray *arrayM = [SXNewsModel objectArrayWithKeyValuesArray:temArray];
        
//        NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:temArray.count];
//        [temArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            
//            SXNewsModel *news = [SXNewsModel newsModelWithDict:obj];
//            [arrayM addObject:news];
//        }];
        if (type == 1) {
            self.arrayList = arrayM;
            [self.tableView headerEndRefreshing];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            
            [self.tableView footerEndRefreshing];
        }
        if (![UserComm showReleaseFunction]) {
            NSInteger loc = 0;
            NSInteger len = 0;
            for (SXNewsModel *model in self.arrayList) {
                if ([model.moreTitle isEqualToString:@"洛客直播"]) {
                    loc = [self.arrayList indexOfObject:model];
                } else if ([model.moreTitle isEqualToString:@"法律教育"]) {
                    len = [self.arrayList indexOfObject:model] - loc;
                }
            }
            [self.arrayList removeObjectsInRange:NSMakeRange(loc, len)];
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
        if (type == 1) {
            [self.tableView headerEndRefreshing];
        }else if(type == 2){
            [self.tableView footerEndRefreshing];
        }
    }] resume];
}// ------想把这里改成block来着

#pragma mark - /************************* tbv数据源方法 ***************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SXNewsModel *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SXNewsCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"NewsXian";
    }
    SXNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    //cell.btnDelegate2 = self;
    
    return cell;
    
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXNewsModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [SXNewsCell heightForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        rowHeight = 20;
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
    if ([segue.destinationViewController isKindOfClass:[AdvancedBarrageController class]]) {
        
        NSInteger x = self.tableView.indexPathForSelectedRow.row;
        AdvancedBarrageController *dc = segue.destinationViewController;
        dc.newsModel = self.arrayList[x];        
        
        //AppDelegate *app = [[UIApplication sharedApplication] delegate];        
        //NSString *displayCount;
        //displayCount = [NSString stringWithFormat:@"%@",app.docxid];
        //dc.strTtile = displayCount;
        
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
//    else if ([segue.destinationViewController isKindOfClass:[SXPhotoSetController class]]) {
//        NSInteger x = self.tableView.indexPathForSelectedRow.row;
//        SXPhotoSetController *pc = segue.destinationViewController;
//        pc.newsModel = self.arrayList[x];
//    }
    else if ([segue.destinationViewController isKindOfClass:[SXErviewController class]]) {
        NSInteger x = self.tableView.indexPathForSelectedRow.row;
     
        //UITableViewCell *er = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellIdentifier"];
        SXErviewController *er = segue.destinationViewController;
        er.newsModel = self.arrayList[x];
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        app.newsx = (long)x;
    }else{
        //UITableViewCell *er = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellIdentifier"];
        SXUrl *su = segue.destinationViewController;
        su.sewsModel = self.arrayList[0];
    }
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        
        //分页控件
        _pageControl = [[UIPageControl alloc] init];
        //总页数
        _pageControl.numberOfPages = self.sender;
        //控件尺寸
        CGSize size = [_pageControl sizeForNumberOfPages:self.sender];
        
        _pageControl.bounds = CGRectMake(0,0, size.width,size.height);
        _pageControl.center = CGPointMake(self.view.center.x, 205);
        //设置颜色
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        
        [self.view addSubview:_pageControl];
        
        //添加监听方法
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

//分页控件的监听方法
-(void)pageChanged:(UIPageControl *)page
{
    //NSLog(@"%ld",page.currentPage);
    
    CGFloat x = page.currentPage * self.scrollView.bounds.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (UIScrollView *)scrollView
{
    
    if (_scrollView == nil && self.urlString == [NSString stringWithFormat:@"list/T1"]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 215)];
        [self.view addSubview:_scrollView];
        //取消弹簧
        _scrollView.bounces = NO;
        
        //取消水平滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        //分页
        _scrollView.pagingEnabled = YES;
        
        //设置contentsize
        _scrollView.contentSize = CGSizeMake(self.sender * _scrollView.bounds.size.width, 0);
        //设置代理
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [self pageChanged:self.pageControl];
}

- (void)updateTimer
{
    //让当前页号发生变化
    int page = (self.pageControl.currentPage + 1) % self.sender;
    self.pageControl.currentPage = page;
    
    //调用监听方法，让滚动时图滚动
    [self pageChanged:self.pageControl];
}

#pragma mark —— Scrollview代理方法
//滚动视图停下来
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //NSLog(@"%s",__func__);
    //NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    //计算页数
    int page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    self.pageControl.currentPage = page;
}

@end
