//
//  ESaiCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESaiModel.h"

@interface ESaiCell : UITableViewCell

@property(nonatomic,strong) ESaiModel *NewsModel;



/**
 *  类方法返回可重用的id
 */
+ (NSString *)idForRow:(ESaiModel *)NewsModel;

/**
 *  类方法返回行高
 */
+ (CGFloat)heightForRow:(ESaiModel *)NewsModel;
@end
