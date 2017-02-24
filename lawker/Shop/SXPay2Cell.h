//
//  SXPay2Cell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXPay2Model.h"

@interface SXPay2Cell : UITableViewCell

@property(nonatomic,strong) SXPay2Model *NewsModel;

+ (NSString *)idForRow:(SXPay2Model *)NewsModel;

+ (CGFloat)heightForRow:(SXPay2Model *)NewsModel;

@end
