//
//  TYDownloadModel.h
//  TYDownloadManagerDemo
//
//  Created by tany on 16/6/1.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXHcModel.h"
#import "TYDownloadUtility.h"
//#import "ZFDownloadManager.h"

// 下载状态
typedef NS_ENUM(NSUInteger, TYDownloadState) {
    TYDownloadStateNone,        // 未下载
    TYDownloadStateReadying,    // 等待下载
    TYDownloadStateRunning,     // 正在下载
    TYDownloadStateSuspended,   // 下载暂停
    TYDownloadStateCompleted,   // 下载完成
    TYDownloadStateFailed       // 下载失败
};

@class TYDownloadProgress;
@class TYDownloadModel;

// 缓存主目录
#define TYCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"ZFCache"]

// 保存文件名
#define TYFileName(url)  [[url componentsSeparatedByString:@"/"] lastObject]

// 文件的存放路径（caches）
#define TYFileFullpath(url) [TYCachesDirectory stringByAppendingPathComponent:TYFileName(url)]

// 文件的已下载长度
#define TYDownloadLength(url) [[[NSFileManager defaultManager] attributesOfItemAtPath:TYFileFullpath(url) error:nil][NSFileSize] integerValue]

// 存储文件信息的路径（caches）
#define TYDownloadDetailPath [TYCachesDirectory stringByAppendingPathComponent:@"downloadDetail.db"]

// 进度更新block
typedef void (^TYDownloadProgressBlock)(TYDownloadProgress *progress);
// 状态更新block
typedef void (^TYDownloadStateBlock)(TYDownloadState state,NSString *filePath, NSError *error);

/**
 *  下载模型
 */
@interface TYDownloadModel : NSObject

// >>>>>>>>>>>>>>>>>>>>>>>>>>  download info
// 下载地址
@property (nonatomic, strong, readonly) NSString *downloadURL;
// 文件名 默认nil 则为下载URL中的文件名
@property (nonatomic, strong, readonly) NSString *fileName;
// 缓存文件目录 默认nil 则为manger缓存目录
@property (nonatomic, strong, readonly) NSString *downloadDirectory;

// >>>>>>>>>>>>>>>>>>>>>>>>>>  task info
// 下载状态
@property (nonatomic, assign, readonly) TYDownloadState state;
// 下载任务
@property (nonatomic, strong, readonly) NSURLSessionTask *task;
// 文件流
@property (nonatomic, strong, readonly) NSOutputStream *stream;
// 下载进度
@property (nonatomic, strong) TYDownloadProgress *progress;
// 下载路径 如果设置了downloadDirectory，文件下载完成后会移动到这个目录，否则，在manager默认cache目录里
@property (nonatomic, strong, readonly) NSString *filePath;

// >>>>>>>>>>>>>>>>>>>>>>>>>>  download block
// 下载进度更新block
@property (nonatomic, copy) TYDownloadProgressBlock progressBlock;
// 下载状态更新block
@property (nonatomic, copy) TYDownloadStateBlock stateBlock;

@property(nonatomic,strong) SXHcModel *hcModel;


- (instancetype)initWithURLString:(NSString *)URLString;
/**
 *  初始化方法
 *
 *  @param URLString 下载地址
 *  @param filePath  缓存地址 当为nil 默认缓存到cache
 */
- (instancetype)initWithURLString:(NSString *)URLString filePath:(NSString *)filePath;

@end

/**
 *  下载进度
 */
@interface TYDownloadProgress : NSObject

// 续传大小
@property (nonatomic, assign) int64_t resumeBytesWritten;
// 这次写入的数量
@property (nonatomic, assign) int64_t bytesWritten;
// 已下载的数量
@property (nonatomic, assign) int64_t totalBytesWritten;
// 文件的总大小
@property (nonatomic, assign) int64_t totalBytesExpectedToWrite;
// 下载进度
@property (nonatomic, assign) float progress;
// 下载速度
@property (nonatomic, assign) float speed;
// 下载剩余时间
@property (nonatomic, assign) int remainingTime;


@end
