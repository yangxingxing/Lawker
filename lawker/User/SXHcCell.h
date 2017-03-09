//
//  SXHcCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXHcModel.h"
#import "ZFDownloadManager.h"
#import "TYDownLoadModel.h"
@class SXHcCell;

@protocol LongPressGestureDelegate <NSObject>

- (void)longPressGestureClick:(SXHcCell *)cell;

@end

@interface SXHcCell : UITableViewCell

typedef void(^ZFDownloadBlock)(UIButton *);

@property (strong, nonatomic) UILabel *titleLabel;// 标题
@property (strong, nonatomic) UIButton *downLoadBtn;// 是否继续下载
@property (strong, nonatomic) UIImageView *iconImg; // 头像
@property (strong, nonatomic) UILabel *cashLabel;  // 缓存进度

@property(nonatomic,strong) SXHcModel *NewsModel;
@property (nonatomic, strong) ZFSessionModel  *sessionModel;
@property (nonatomic, copy  ) ZFDownloadBlock downloadBlock;
@property (nonatomic, strong) TYDownloadModel  *downLoadModel;

@property (nonatomic, weak) id<LongPressGestureDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
