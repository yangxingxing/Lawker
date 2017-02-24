//
//  SXNewsCell.h
//  lawker
//
//  Created by 董 尚先 on 15-1-22.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXNewsModel.h"

@interface SXNewsCell : UITableViewCell

@property(nonatomic,strong) SXNewsModel *NewsModel;

+ (NSString *)idForRow:(SXNewsModel *)NewsModel;

+ (CGFloat)heightForRow:(SXNewsModel *)NewsModel;

@end
