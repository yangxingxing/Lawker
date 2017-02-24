//
//  SXHciewController.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXHciewController.h"
#import "SXHcCell.h"
#import "SXNetworkTools.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"

@interface SXHciewController ()<UITableViewDataSource,UITableViewDelegate,btnClickedDelegate>

@property(nonatomic,strong) NSMutableArray *arrayList;

@property(nonatomic,assign)BOOL update;

@end

@implementation SXHciewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadhc];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //[self.tableView addFooterWithTarget:self action:@selector(loadMoreData2)];
    self.navigationItem.title = @"离线下载";
    //[self.tableView setEditing:YES animated:YES];

    app.navid = 1;
    
}

-(void)loadhc{
    NSMutableArray *fileList = [NSMutableArray array];
    NSString *docdir = [NSString stringWithFormat:@"%@/Documents/hc",NSHomeDirectory()];
    
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docdir error:NULL];
    
    for (NSString *aPath in contentOfFolder) {
        NSString *suffix = [aPath pathExtension];
        if([suffix isEqualToString:@"mp4"]){
            NSString * fullPath = [docdir stringByAppendingPathComponent:aPath];
            BOOL isDir;
            if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)
            {
                [fileList  addObject:@{@"title" : [NSString stringWithFormat:@"%@",[aPath stringByDeletingPathExtension]]}];
            }
        }
    }
    
    NSMutableArray *arrayM = [SXHcModel objectArrayWithKeyValuesArray:fileList];
    
    self.arrayList = arrayM;
    [self.tableView headerEndRefreshing];
    [self.tableView reloadData];
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
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
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    SXHcModel *newsModel = self.arrayList[app.tid];
    
    app.title = newsModel.title;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"News" bundle:nil];
    UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"SXViewController"];
    [self.navigationController pushViewController:jview animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXHcModel *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SXHcCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"NewsCell";
    }
    SXHcCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    cell.btnDelegate =self;
    
    return cell;
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXHcModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [SXHcCell heightForRow:newsModel];
    
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

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (!self.tableView.isEditing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    SXHcModel *newsModel = self.arrayList[indexPath.row];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"hc/%@", newsModel.title]];
    //NSLog(@"%@",path);
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@.jpg", path] error:nil];
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@.mp4", path] error:nil];
    
    [self loadhc];
    
}

@end
