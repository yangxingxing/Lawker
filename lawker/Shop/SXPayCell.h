//
//  SXPayCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXPayModel.h"

@interface SXPayCell : UITableViewCell

@property(nonatomic,strong) SXPayModel *NewsModel;

+ (NSString *)idForRow:(SXPayModel *)NewsModel;

+ (CGFloat)heightForRow:(SXPayModel *)NewsModel;

@end
