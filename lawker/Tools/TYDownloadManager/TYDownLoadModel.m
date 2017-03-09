//
//  TYDownloadModel.m
//  TYDownloadManagerDemo
//
//  Created by tany on 16/6/1.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYDownloadModel.h"

@interface TYDownloadProgress ()

@end

@interface TYDownloadModel ()

// >>>>>>>>>>>>>>>>>>>>>>>>>>  download info
// 下载地址
@property (nonatomic, strong) NSString *downloadURL;
// 文件名 默认nil 则为下载URL中的文件名
@property (nonatomic, strong) NSString *fileName;
// 缓存文件目录 默认nil 则为manger缓存目录
@property (nonatomic, strong) NSString *downloadDirectory;

// >>>>>>>>>>>>>>>>>>>>>>>>>>  task info
// 下载状态
@property (nonatomic, assign) TYDownloadState state;
// 下载任务
@property (nonatomic, strong) NSURLSessionTask *task;
// 文件流
@property (nonatomic, strong) NSOutputStream *stream;
// 下载文件路径,下载完成后有值,把它移动到你的目录
@property (nonatomic, strong) NSString *filePath;
// 下载时间
@property (nonatomic, strong) NSDate *downloadDate;
// 断点续传需要设置这个数据 
@property (nonatomic, strong) NSData *resumeData;
// 手动取消当做暂停
@property (nonatomic, assign) BOOL manualCancle;

@end

@implementation TYDownloadModel

- (instancetype)init
{
    if (self = [super init]) {
        _progress = [[TYDownloadProgress alloc]init];
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *)URLString
{
    _downloadURL = URLString;
    return [self initWithURLString:URLString filePath:self.filePath];
}

- (instancetype)initWithURLString:(NSString *)URLString filePath:(NSString *)filePath
{
    if (self = [self init]) {
//        _fileName = filePath.lastPathComponent;
//        _downloadDirectory = filePath.stringByDeletingLastPathComponent;
        _filePath = filePath;
    }
    return self;
}

-(NSString *)fileName
{
    if (!_fileName) {
        _fileName = TYFileName(_downloadURL);
    }
    return _fileName;
}

- (NSString *)downloadDirectory
{
    if (!_downloadDirectory) {
        _downloadDirectory = TYCachesDirectory;
    }
    return _downloadDirectory;
}

- (NSString *)filePath
{
    if (!_filePath) {
        _filePath = [NSString stringWithFormat:@"%@/%@",self.downloadDirectory,TYFileFullpath(_downloadURL)]; // 拼接Url
    }
    return _filePath;
}

- (void)encodeWithCoder:(NSCoder *)aCoder //将属性进行编码
{
    [aCoder encodeObject:self.downloadURL forKey:@"downloadURL"];
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeObject:self.hcModel forKey:@"hcModel"];
    [aCoder encodeObject:self.progress forKey:@"progress"];
    [aCoder encodeInteger:self.state forKey:@"state"];
}

- (id)initWithCoder:(NSCoder *)aDecoder //将属性进行解码
{
    self = [super init];
    if (self) {
        self.downloadURL = [aDecoder decodeObjectForKey:@"downloadURL"];
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.hcModel = [aDecoder decodeObjectForKey:@"hcModel"];
        self.progress = [aDecoder decodeObjectForKey:@"progress"];
        self.state = [aDecoder decodeIntegerForKey:@"state"];
    }
    return self;
}

@end

@implementation TYDownloadProgress

- (void)encodeWithCoder:(NSCoder *)aCoder //将属性进行编码
{
    [aCoder encodeInt64:self.resumeBytesWritten forKey:@"resumeBytesWritten"];
    [aCoder encodeInt64:self.bytesWritten forKey:@"bytesWritten"];
    [aCoder encodeInt64:self.totalBytesWritten forKey:@"totalBytesWritten"];
    [aCoder encodeInt64:self.totalBytesExpectedToWrite forKey:@"totalBytesExpectedToWrite"];
    [aCoder encodeFloat:self.progress forKey:@"progress"];
    [aCoder encodeFloat:self.speed forKey:@"speed"];
    [aCoder encodeInt:self.remainingTime forKey:@"remainingTime"];
}

- (id)initWithCoder:(NSCoder *)aDecoder //将属性进行解码
{
    self = [super init];
    if (self) {
        self.resumeBytesWritten = [aDecoder decodeInt64ForKey:@"resumeBytesWritten"];
        self.bytesWritten = [aDecoder decodeInt64ForKey:@"bytesWritten"];
        self.totalBytesWritten = [aDecoder decodeInt64ForKey:@"totalBytesWritten"];
        self.totalBytesExpectedToWrite = [aDecoder decodeInt64ForKey:@"totalBytesExpectedToWrite"];
        
        self.progress = [aDecoder decodeFloatForKey:@"progress"];
        self.speed = [aDecoder decodeFloatForKey:@"speed"];
        self.remainingTime = [aDecoder decodeIntForKey:@"remainingTime"];
        
    }
    return self;
}

@end
