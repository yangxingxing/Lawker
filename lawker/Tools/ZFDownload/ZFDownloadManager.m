//
//  ZFDownloadManager.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFDownloadManager.h"

@interface ZFDownloadManager()<NSCopying, NSURLSessionDelegate>

/** 保存所有任务(注：用下载地址/后作为key) */
//@property (nonatomic, strong) NSMutableDictionary *tasks;
/** 保存所有下载相关信息字典 */
@property (nonatomic, strong) NSMutableDictionary *sessionModels;
/** 所有本地存储的所有下载信息数据数组 */
@property (nonatomic, strong) NSMutableArray *sessionModelsArray;
/** 下载完成的模型数组*/
@property (nonatomic, strong) NSMutableArray *downloadedArray;
/** 下载中的模型数组*/
@property (nonatomic, strong) NSMutableArray *downloadingArray;
// 下载seesion会话
@property (nonatomic, strong) NSURLSession *session;


@end

@implementation ZFDownloadManager

//- (NSMutableDictionary *)tasks
//{
//    if (!_tasks) {
//        _tasks = [NSMutableDictionary dictionary];
//    }
//    return _tasks;
//}

- (NSMutableDictionary *)sessionModels
{
    if (!_sessionModels) {
        _sessionModels = @{}.mutableCopy;
    }
    return _sessionModels;
}


- (NSMutableArray *)sessionModelsArray
{
    if (!_sessionModelsArray) {
        _sessionModelsArray = @[].mutableCopy;
        [_sessionModelsArray addObjectsFromArray:[self getSessionModels]];
    }
    return _sessionModelsArray;
}

- (NSMutableArray *)downloadingArray
{
    if (!_downloadingArray) {
        _downloadingArray = @[].mutableCopy;
        for (ZFSessionModel *obj in self.sessionModelsArray) {
            if (![self isCompletion:obj.url]) {
                [_downloadingArray addObject:obj];
            }
        }
    }
    return _downloadingArray;
}

- (NSMutableArray *)downloadedArray
{
    if (!_downloadedArray) {
        _downloadedArray = @[].mutableCopy;
        for (ZFSessionModel *obj in self.sessionModelsArray) {
            if ([self isCompletion:obj.url]) {
                [_downloadedArray addObject:obj];
            }
        }
    }
    return _downloadedArray;
}

static ZFDownloadManager *_downloadManager;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _downloadManager = [super allocWithZone:zone];
    });
    
    return _downloadManager;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return _downloadManager;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadManager = [[self alloc] init];
        _downloadManager.backgroundConfigure = @"DownloadSessionManager.backgroundConfigure";
    });
    
    return _downloadManager;
}

- (void)configureBackroundSession
{
    if (!_backgroundConfigure) {
        return;
    }
    [self session];
}

- (NSURLSession *)session
{
    if (!_session) {
        if (_backgroundConfigure) {
            if (iOS8) {
                _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:_backgroundConfigure]delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
            }else{
                _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfiguration:_backgroundConfigure]delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
            }
        }else {
            _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
        }
    }
    return _session;
}


/**
 * 归档
 */
- (void)save:(NSArray *)sessionModels
{
    [NSKeyedArchiver archiveRootObject:sessionModels toFile:ZFDownloadDetailPath];
}

/**
 * 读取model
 */
- (NSArray *)getSessionModels
{
    // 文件信息
    NSArray *sessionModels = [NSKeyedUnarchiver unarchiveObjectWithFile:ZFDownloadDetailPath];
    return sessionModels;
}


/**
 *  创建缓存目录文件
 */
- (void)createCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:ZFCachesDirectory]) {
        [fileManager createDirectoryAtPath:ZFCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

/**
 *  开启任务下载资源
 */
- (void)download:(NSString *)url progress:(ZFDownloadProgressBlock)progressBlock state:(ZFDownloadStateBlock)stateBlock  newsModel:(SXHcModel *)newsModel isSuspend:(BOOL)Suspend
{
    if (!url) return;
    if ([self isCompletion:url]) {
        stateBlock(DownloadStateCompleted);
        NSLog(@"----该资源已下载完成");
        return;
    }
    ZFSessionModel *model = [self getSessionModelUrl:url];
    // 暂停
    if (model.task) {
        [self handle:url isSuspend:(BOOL)Suspend sessionModel:(ZFSessionModel *)model];
        return;
    }

    // 创建缓存目录文件
    [self createCacheDirectory];
    
    // 创建流
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:ZFFileFullpath(url) append:YES];
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // 设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", ZFDownloadLength(url)];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    // 创建一个Data任务
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request];
    NSUInteger taskIdentifier = arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
    [task setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];
    // 保存任务
//    [self.tasks setValue:task forKey:ZFFileName(url)];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:ZFFileFullpath(url)]) {
        ZFSessionModel *sessionModel = [[ZFSessionModel alloc] init];
        sessionModel.url = url;
        sessionModel.state = DownloadStateStart;
        sessionModel.progressBlock = progressBlock;
        sessionModel.stateBlock = stateBlock;
        sessionModel.stream = stream;
        sessionModel.startTime = [NSDate date];
        sessionModel.fileName = ZFFileName(url);
        sessionModel.hcModel = newsModel;
        sessionModel.task = task;
        [self.sessionModels setValue:sessionModel forKey:@(task.taskIdentifier).stringValue];
        [self.sessionModelsArray addObject:sessionModel];
        [self.downloadingArray addObject:sessionModel];
        // 保存
        [self save:self.sessionModelsArray];
        [self startSessionModel:sessionModel];
    }else {
        for (ZFSessionModel *sessionModel in self.sessionModelsArray) {
            if ([sessionModel.url isEqualToString:url]) {
                sessionModel.url = url;
                sessionModel.state = DownloadStateStart;
                sessionModel.progressBlock = progressBlock;
                sessionModel.stateBlock = stateBlock;
                sessionModel.stream = stream;
                sessionModel.task = task;
                sessionModel.startTime = [NSDate date];
                sessionModel.fileName = ZFFileName(url);
                sessionModel.hcModel = newsModel;
                [self.sessionModels setValue:sessionModel forKey:@(task.taskIdentifier).stringValue];
                [self startSessionModel:sessionModel];
                break;
            }
        }
    }
}


- (void)handle:(NSString *)url isSuspend:(BOOL)Suspend sessionModel:(ZFSessionModel *)sessionModel
{
//    NSURLSessionTask *task = [self getTask:url];
//    if (Suspend) {
//        if (sessionModel.state == DownloadStateSuspended) {
//            [self startSessionModel:sessionModel];
//        } else {
//            [self pauseSessionModel:sessionModel];
//        }
//    } else {
        if (sessionModel.state == DownloadStateStart) {
            [self startSessionModel:sessionModel];
        } else {
            [self pauseSessionModel:sessionModel];
        }
//    }
    
}

/**
 *  开始下载
 */
- (void)startSessionModel:(ZFSessionModel *)sessionModel
{
    [sessionModel.task resume];
    NSLog(@"---开始下载");
    sessionModel.state = DownloadStateStart;
    sessionModel.stateBlock(DownloadStateStart);
}

/**
 *  暂停下载
 */
- (void)pauseSessionModel:(ZFSessionModel *)sessionModel
{
    [sessionModel.task suspend];
    NSLog(@"---暂停下载");
    sessionModel.state = DownloadStateSuspended;
    sessionModel.stateBlock(DownloadStateSuspended);
}

/**
 *  根据url获得对应的下载任务
 */
- (NSURLSessionTask *)getTask:(NSString *)url
{
    for (ZFSessionModel *sessionModel in self.sessionModelsArray) {
        // 暂停
        if ([sessionModel.url isEqualToString:url]) {
            return sessionModel.task;
        }
    }
    return nil;
}

/**
 *  根据url获取对应的下载信息模型
 */
- (ZFSessionModel *)getSessionModelUrl:(NSString *)url
{
    for (ZFSessionModel *sessionModel in self.sessionModelsArray) {
        if ([sessionModel.url isEqualToString:url]) {
            return sessionModel;
        }
    }
    return nil;
}

/**
 *  根据taskIdentifier获取对应的下载信息模型
 */
- (ZFSessionModel *)getSessionModel:(NSUInteger)taskIdentifier
{
    for (ZFSessionModel *sessionModel in self.sessionModelsArray) {
        if (sessionModel.task.taskIdentifier == taskIdentifier) {
            return sessionModel;
        }
    }
    return nil;
}

/**
 *  判断该文件是否下载完成
 */
- (BOOL)isCompletion:(NSString *)url
{
    if ([self fileTotalLength:url] && ZFDownloadLength(url) == [self fileTotalLength:url]) {
        return YES;
    }
    return NO;
}

/**
 *  查询该资源的下载进度值
 */
- (CGFloat)progress:(NSString *)url
{
    return [self fileTotalLength:url] == 0 ? 0.0 : 1.0 * ZFDownloadLength(url) /  [self fileTotalLength:url];
}

/**
 *  获取该资源总大小
 */
- (NSInteger)fileTotalLength:(NSString *)url
{
    for (ZFSessionModel *model in self.sessionModelsArray) {
        if ([model.url isEqualToString:url]) {
            return model.totalLength;
        }
    }
    return 0;
}

#pragma mark - 删除
/**
 *  删除该资源
 */
- (void)deleteFile:(NSString *)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:ZFFileFullpath(url)]) {
        // 删除沙盒中的资源
        [fileManager removeItemAtPath:ZFFileFullpath(url) error:nil];
        // 删除资源总长度
    }
    ZFSessionModel *sessionModel;
    if ([fileManager fileExistsAtPath:ZFDownloadDetailPath]) {
        // 从沙盒中移除该条模型的信息
        for (ZFSessionModel *model in self.sessionModelsArray) {
            if ([model.url isEqualToString:url]) {
                //                    NSURLSessionTask *task = [self getTask:url];
                if (model.task) {
                    // 取消下载
                    [model.task cancel];
                }
                // 关闭流
                model.isDelete = YES;
                [model.stream close];
                sessionModel = model;
                break;
            }
        }
    }
    if (sessionModel) {
        [self.sessionModelsArray removeObject:sessionModel];
    }
    // 删除任务
    //        [self.tasks removeObjectForKey:ZFFileName(url)];
    [self.sessionModels removeObjectForKey:@([self getTask:url].taskIdentifier).stringValue];
    // 保存归档信息
    [self save:self.sessionModelsArray];

}

/**
 *  清空所有下载资源
 */
- (void)deleteAllFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:ZFCachesDirectory]) {
        
        // 删除沙盒中所有资源
        [fileManager removeItemAtPath:ZFCachesDirectory error:nil];
        // 删除任务
        for (ZFSessionModel *sessionModel in self.sessionModelsArray) {
            [sessionModel.task cancel];
        }
//        [[self.tasks allValues] makeObjectsPerformSelector:@selector(cancel)];
//        [self.tasks removeAllObjects];
        
        for (ZFSessionModel *sessionModel in [self.sessionModels allValues]) {
            [sessionModel.stream close];
        }
        [self.sessionModels removeAllObjects];
        
        // 删除资源总长度
        if ([fileManager fileExistsAtPath:ZFDownloadDetailPath]) {
            [fileManager removeItemAtPath:ZFDownloadDetailPath error:nil];
            [self.sessionModelsArray removeAllObjects];
            self.sessionModelsArray = nil;
            [self.downloadedArray removeAllObjects];
            [self.downloadingArray removeAllObjects];
        }
    }
}

- (BOOL)isFileDownloadingForUrl:(NSString *)url withProgressBlock:(ZFDownloadProgressBlock)progressBlock
{
    BOOL retValue = NO;
//    NSURLSessionTask *task = [self getTask:url];
    ZFSessionModel *session = [self getSessionModelUrl:url];
    if (session) {
        if (progressBlock) {
            session.progressBlock = progressBlock;
        }
        retValue = YES;
    }
    return retValue;
}

- (NSArray *)currentDownloads {
    NSMutableArray *currentDownloads = [NSMutableArray new];
    [self.sessionModels enumerateKeysAndObjectsUsingBlock:^(id key, ZFSessionModel *download, BOOL *stop) {
        [currentDownloads addObject:download.url];
    }];
    return currentDownloads;
}

- (NSArray *)currentDownloadsModel {
    NSMutableArray *currentDownloads = [NSMutableArray new];
    [self.sessionModels enumerateKeysAndObjectsUsingBlock:^(id key, ZFSessionModel *download, BOOL *stop) {
        [currentDownloads addObject:download];
    }];
    return currentDownloads;
}

#pragma mark NSURLSessionDataDelegate

/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
    ZFSessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 打开流
    [sessionModel.stream open];
    
    // 获得服务器这次请求 返回数据的总长度
    NSInteger totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + ZFDownloadLength(sessionModel.url);
    sessionModel.totalLength = totalLength;
    
    // 总文件大小
    NSString *fileSizeInUnits = [NSString stringWithFormat:@"%.2f %@",
                                 [sessionModel calculateFileSizeInUnit:(unsigned long long)totalLength],
                                 [sessionModel calculateUnit:(unsigned long long)totalLength]];
    sessionModel.totalSize = fileSizeInUnits;
    // 更新数据(文件总长度)
    [self save:self.sessionModelsArray];
    
    // 添加下载中数组
    if (![self.downloadingArray containsObject:sessionModel]) {
        [self.downloadingArray addObject:sessionModel];
    }
    
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

// 监听文件下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    ZFSessionModel *sessionModel = [self getSessionModel:downloadTask.taskIdentifier];
    
    // 写入数据
//    [sessionModel.stream write:data.bytes maxLength:data.length];
    
    // 下载进度
//    NSUInteger totalBytesWritten = ZFDownloadLength(sessionModel.url);
//    NSUInteger expectedSize = sessionModel.totalLength;
    CGFloat progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    
    // 每秒下载速度
    NSTimeInterval downloadTime = -1 * [sessionModel.startTime timeIntervalSinceNow];
    NSUInteger speed = totalBytesWritten / downloadTime;
    if (speed == 0) { return; }
    float speedSec = [sessionModel calculateFileSizeInUnit:(unsigned long long) speed];
    NSString *unit = [sessionModel calculateUnit:(unsigned long long) speed];
    NSString *speedStr = [NSString stringWithFormat:@"%.2f%@/s",speedSec,unit];
    
    // 剩余下载时间
    NSMutableString *remainingTimeStr = [[NSMutableString alloc] init];
    unsigned long long remainingContentLength = totalBytesExpectedToWrite - totalBytesWritten;
    int remainingTime = (int)(remainingContentLength / speed);
    int hours = remainingTime / 3600;
    int minutes = (remainingTime - hours * 3600) / 60;
    int seconds = remainingTime - hours * 3600 - minutes * 60;
    
    if(hours>0) {[remainingTimeStr appendFormat:@"%d 小时 ",hours];}
    if(minutes>0) {[remainingTimeStr appendFormat:@"%d 分 ",minutes];}
    if(seconds>0) {[remainingTimeStr appendFormat:@"%d 秒",seconds];}
    
    NSString *writtenSize = [NSString stringWithFormat:@"%.1f%@",
                             [sessionModel calculateFileSizeInUnit:(unsigned long long)totalBytesWritten],
                             [sessionModel calculateUnit:(unsigned long long)totalBytesWritten]];
    
    if (sessionModel.stateBlock) {
        sessionModel.state = DownloadStateStart;
        sessionModel.stateBlock(DownloadStateStart);
    }
    if (sessionModel.progressBlock) {
        sessionModel.progressBlock(progress, speedStr, remainingTimeStr,writtenSize, sessionModel.totalSize);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(downloadResponse:)]) {
            [self.delegate downloadResponse:sessionModel];
        }
    });
}
/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionTask *)dataTask didReceiveData:(NSData *)data
{
    ZFSessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 写入数据
    [sessionModel.stream write:data.bytes maxLength:data.length];
    
    // 下载进度
    NSUInteger receivedSize = ZFDownloadLength(sessionModel.url);
    NSUInteger expectedSize = sessionModel.totalLength;
    CGFloat progress = 1.0 * receivedSize / expectedSize;
    
    // 每秒下载速度
    NSTimeInterval downloadTime = -1 * [sessionModel.startTime timeIntervalSinceNow];
    NSUInteger speed = receivedSize / downloadTime;
    if (speed == 0) { return; }
    float speedSec = [sessionModel calculateFileSizeInUnit:(unsigned long long) speed];
    NSString *unit = [sessionModel calculateUnit:(unsigned long long) speed];
    NSString *speedStr = [NSString stringWithFormat:@"%.2f%@/s",speedSec,unit];
    
    // 剩余下载时间
    NSMutableString *remainingTimeStr = [[NSMutableString alloc] init];
    unsigned long long remainingContentLength = expectedSize - receivedSize;
    int remainingTime = (int)(remainingContentLength / speed);
    int hours = remainingTime / 3600;
    int minutes = (remainingTime - hours * 3600) / 60;
    int seconds = remainingTime - hours * 3600 - minutes * 60;
    
    if(hours>0) {[remainingTimeStr appendFormat:@"%d 小时 ",hours];}
    if(minutes>0) {[remainingTimeStr appendFormat:@"%d 分 ",minutes];}
    if(seconds>0) {[remainingTimeStr appendFormat:@"%d 秒",seconds];}
    
    NSString *writtenSize = [NSString stringWithFormat:@"%.1f%@",
                             [sessionModel calculateFileSizeInUnit:(unsigned long long)receivedSize],
                             [sessionModel calculateUnit:(unsigned long long)receivedSize]];
    
    if (sessionModel.stateBlock) {
        sessionModel.state = DownloadStateStart;
        sessionModel.stateBlock(DownloadStateStart);
    }
    if (sessionModel.progressBlock) {
        sessionModel.progressBlock(progress, speedStr, remainingTimeStr,writtenSize, sessionModel.totalSize);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(downloadResponse:)]) {
            [self.delegate downloadResponse:sessionModel];
        }
    });
}

/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    ZFSessionModel *sessionModel = [self getSessionModel:task.taskIdentifier];
    if (!sessionModel) return;
    
    if ([self isCompletion:sessionModel.url]) {
        // 下载完成
        sessionModel.state = DownloadStateCompleted;
        sessionModel.stateBlock(DownloadStateCompleted);
    } else if (error){
        // 下载失败，删除也时关闭stream也会走这边
        if (sessionModel.downLoadCount < 10 && !sessionModel.isDelete) {  // 可以分用户退到后台前是暂停还是下载中
            sessionModel.downLoadCount++;
            sessionModel.task = nil;
           [self download:sessionModel.url progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {} state:^(DownloadState state) {} newsModel:sessionModel.hcModel isSuspend:NO];
            return;
        } else {
            sessionModel.state = DownloadStateFailed;
            sessionModel.stateBlock(DownloadStateFailed);
        }
    }
    // 关闭流
    sessionModel.stream = nil;
    [sessionModel.stream close];
    
    [self save:self.sessionModelsArray];
    // 清除任务
    sessionModel.task = nil;
    [self.sessionModels setValue:sessionModel forKey:@(task.taskIdentifier).stringValue];
    
    [self.downloadingArray removeObject:sessionModel];
    
    // 清除任务
//    [self.tasks removeObjectForKey:ZFFileName(sessionModel.url)];
//    [self.sessionModels removeObjectForKey:@(task.taskIdentifier).stringValue];
    
    [self.downloadingArray removeObject:sessionModel];
    
    if (error.code == -999)    return;   // cancel
    
    if (![self.downloadedArray containsObject:sessionModel]) {
        [self.downloadedArray addObject:sessionModel];
    }
}

// 获取所以的后台下载session
- (NSArray *)sessionDownloadTasks
{
    __block NSArray *tasks = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        tasks = downloadTasks;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return tasks;
}

@end
