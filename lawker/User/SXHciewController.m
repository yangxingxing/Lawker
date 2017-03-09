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
#import "TYDownloadSessionManager.h"
#import "TYDownloadDelegate.h"
#import "AdvancedBarrageController.h"

@interface SXHciewController ()<ZFDownloadDelegate,UITableViewDataSource,UITableViewDelegate,TYDownloadDelegate,LongPressGestureDelegate>  {
    __weak TYDownloadSessionManager *_manager;
    __weak ZFDownloadManager *_downLoadManager;
}
@property (nonatomic, strong) NSMutableArray *downloadObjectArr;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SXHciewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    // 更新数据源
//    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"离线缓存";
//    [self.tableView registerClass:[SXHcCell class] forCellReuseIdentifier:@"downloadingCell"];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
//    self.tableView.rowHeight = 90.0f;
    [self initData];
    // NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES));
}

- (void)initData
{
    _downLoadManager = [ZFDownloadManager sharedInstance];
    NSMutableArray *downladModel = _downLoadManager.sessionModelsArray;
    [self.downloadObjectArr addObjectsFromArray:downladModel];
//    _manager = [TYDownloadSessionManager manager];
//    _manager.delegate = self;
//    NSDictionary *allDic = _manager.downloadingModelDic;
//    for (NSString *urlString in allDic) {
//        TYDownloadModel *downLoadModel = allDic[urlString];
//        [self.downloadObjectArr addObject:downLoadModel];
//    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)downloadObjectArr {
    if (!_downloadObjectArr) {
        _downloadObjectArr = [NSMutableArray array];
        return _downloadObjectArr;
    }
    return _downloadObjectArr;
}

#pragma mark - ZFDownloadDelegate
- (void)downloadResponse:(ZFSessionModel *)sessionModel
{
    if (self.downloadObjectArr) {
        // 取到对应的cell上的model
        if ([self.downloadObjectArr containsObject:sessionModel]) {
            NSInteger index = [self.downloadObjectArr indexOfObject:sessionModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            __block SXHcCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//            __weak typeof(self) wSelf = self;
            sessionModel.progressBlock = ^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.downLoadBtn.selected = NO;
                    cell.cashLabel.text   = [NSString stringWithFormat:@"缓存中:%@/%@",writtenSize,totalSize];
                });
            };
            
            sessionModel.stateBlock = ^(DownloadState state){
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新数据源
                    if (state == DownloadStateCompleted) {
//                        [wSelf initData];
                        cell.cashLabel.text =[NSString stringWithFormat:@"下载完成%@",cell.sessionModel.totalSize];
                        cell.cashLabel.textColor = GrayColor;
                        cell.downLoadBtn.hidden = YES;
                    }
                    // 暂停
                    if (state == DownloadStateSuspended) {
                        NSUInteger receivedSize = ZFDownloadLength(cell.sessionModel.url);
                        NSString *writtenSize = [NSString stringWithFormat:@"%.1f%@",
                                                 [cell.sessionModel calculateFileSizeInUnit:(unsigned long long)receivedSize],
                                                 [cell.sessionModel calculateUnit:(unsigned long long)receivedSize]];
                        cell.cashLabel.text =[NSString stringWithFormat:@"已缓存：%@",writtenSize];
                        cell.downLoadBtn.selected = YES;
                    }
                    if (state == DownloadStateFailed) {
                        cell.downLoadBtn.hidden = NO;
                        cell.downLoadBtn.selected = NO;
                        [cell.downLoadBtn setTitle:@"重新下载" forState:UIControlStateNormal];
                    }
                });
            };
        }
    }
}

#pragma mark - TYDownloadDelegate
// 更新下载进度
- (void)downloadModel:(TYDownloadModel *)downloadModel didUpdateProgress:(TYDownloadProgress *)progress {
    if (self.downloadObjectArr) {
        // 取到对应的cell上的model
        if ([self.downloadObjectArr containsObject:downloadModel]) {
            NSInteger index = [self.downloadObjectArr indexOfObject:downloadModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            SXHcCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            //            __weak typeof(self) wSelf = self;
            
            NSString *writtenSize = [NSString stringWithFormat:@"%.1f%@",
                                     [TYDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesWritten],
                                     [TYDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesWritten]];
            NSString *totalSize = [NSString stringWithFormat:@"%.1f%@",
                                     [TYDownloadUtility calculateFileSizeInUnit:(unsigned long long)progress.totalBytesExpectedToWrite],
                                     [TYDownloadUtility calculateUnit:(unsigned long long)progress.totalBytesExpectedToWrite]];

            cell.downLoadBtn.selected = NO;
            cell.downLoadBtn.hidden = NO;
            cell.cashLabel.text   = [NSString stringWithFormat:@"缓存中:%@/%@",writtenSize,totalSize];
        }
    }

}

// 更新下载状态
- (void)downloadModel:(TYDownloadModel *)downloadModel didChangeState:(TYDownloadState)state filePath:(NSString *)filePath error:(NSError *)error {
    if (self.downloadObjectArr) {
        NSInteger index = [self.downloadObjectArr indexOfObject:downloadModel];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        SXHcCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        // 更新数据源
        if (state == TYDownloadStateCompleted) {
            //                        [wSelf initData];
            NSString *totalSize = [NSString stringWithFormat:@"%.1f%@",
                                   [TYDownloadUtility calculateFileSizeInUnit:(unsigned long long)cell.downLoadModel.progress.totalBytesExpectedToWrite],
                                   [TYDownloadUtility calculateUnit:(unsigned long long)cell.downLoadModel.progress.totalBytesExpectedToWrite]];
            cell.cashLabel.text =[NSString stringWithFormat:@"下载完成%@",totalSize];
            cell.cashLabel.textColor = GrayColor;
            cell.downLoadBtn.hidden = YES;
        }
        // 暂停
        if (state == TYDownloadStateSuspended) {
            NSString *totalWriteSize = [NSString stringWithFormat:@"%.1f%@",
                                   [TYDownloadUtility calculateFileSizeInUnit:(unsigned long long)cell.downLoadModel.progress.totalBytesWritten],
                                   [TYDownloadUtility calculateUnit:(unsigned long long)cell.downLoadModel.progress.totalBytesWritten]];
            cell.cashLabel.text =[NSString stringWithFormat:@"已缓存：%@",totalWriteSize];
            cell.downLoadBtn.selected = YES;
        }
        if (state == TYDownloadStateFailed) {
            cell.downLoadBtn.hidden = YES;
            cell.cashLabel.text = @"下载失败";
            cell.cashLabel.textColor = GrayColor;
        }
        if (state == TYDownloadStateReadying) {
            cell.downLoadBtn.selected = YES;
            cell.cashLabel.text = @"等待下载";
            cell.cashLabel.textColor = GrayColor;
        }

    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.downloadObjectArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    __block TYDownloadModel *downloadObject = self.downloadObjectArr[indexPath.row];
    __block ZFSessionModel *downloadObject = self.downloadObjectArr[indexPath.row];
    SXHcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadingCell"];
    if (!cell) {
        cell = [[SXHcCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"downloadingCell"];
    }
    cell.downLoadBtn.hidden = YES;
//    cell.downLoadModel = downloadObject;
    cell.sessionModel = downloadObject;
    cell.delegate = self;
    _downLoadManager.delegate = self;
    __weak typeof(cell) weakCell = cell;
    cell.downloadBlock = ^(UIButton *sender) {
//        [_downLoadManager download:weakCell.sessionModel.url progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {} state:^(DownloadState state) {} newsModel:weakCell.sessionModel.hcModel isSuspend:YES];
        if (weakCell.sessionModel.state == DownloadStateStart) {
            [_downLoadManager pauseSessionModel:weakCell.sessionModel];
        } else {
            [_downLoadManager startSessionModel:weakCell.sessionModel];
        }
        //        __weak typeof(self) weakSelf = self;
//        if (weakCell.downLoadModel.state == TYDownloadStateSuspended) {
//            [_manager startWithDownloadModel:weakCell.downLoadModel progress:^(TYDownloadProgress *progress) {
//                
//            } state:^(TYDownloadState state, NSString *filePath, NSError *error) {
//            }];
//            return;
//        }
////        if (weakCell.downLoadModel.state == TYDownloadStateReadying) {
////            [_manager cancleWithDownloadModel:weakCell.downLoadModel];
////            return;
////        }
//        if (weakCell.downLoadModel.state == TYDownloadStateRunning) {
//            [_manager suspendWithDownloadModel:weakCell.downLoadModel];
//            return;
//        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SXHcCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.sessionModel.state != DownloadStateCompleted) return;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"News" bundle:nil];
    AdvancedBarrageController *advanceBCV = (AdvancedBarrageController *)[storyboard instantiateViewControllerWithIdentifier:@"AdvancedBarrageController"];
    
    advanceBCV.from = FromCash;
//    advanceBCV.newsModel = cell.downLoadModel.hcModel;
//    advanceBCV.docp = cell.downLoadModel.hcModel.docid;
//    advanceBCV.skip = cell.downLoadModel.hcModel.skipID;
//    advanceBCV.index = [cell.downLoadModel.hcModel.cout integerValue];
//    advanceBCV.video = cell.downLoadModel.hcModel.videoId;
    advanceBCV.docp = cell.sessionModel.hcModel.docid;
    advanceBCV.skip = cell.sessionModel.hcModel.skipID;
    advanceBCV.index = [cell.sessionModel.hcModel.cout integerValue];
    advanceBCV.video = cell.sessionModel.hcModel.videoId;
    
    [self.navigationController pushViewController:advanceBCV animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110 * ScreenRate;
}

#pragma - LongPressGestureDelegate
- (void)longPressGestureClick:(SXHcCell *)cell {
//    [[ZFDownloadManager sharedInstance] deleteFile:cell.sessionModel.url];
//    [self.downloadObjectArr removeObject:cell.downLoadModel];
//    NSInteger index = [self.downloadObjectArr indexOfObject:cell.sessionModel];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //    TYDownloadModel * downloadObject = self.downloadObjectArr[indexPath.row];
        // 根据url删除该条数据
        SXHcCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [_downLoadManager deleteFile:cell.sessionModel.url];
        [self.downloadObjectArr removeObject:cell.sessionModel];
        [self.tableView reloadData];
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @[@"下载完成",@"下载中"][section];
//}

@end
