//
//  SXSsCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXSsModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick;

@end

@interface SXSsCell : UITableViewCell

@property(nonatomic,strong) SXSsModel *NewsModel;


+ (NSString *)idForRow:(SXSsModel *)NewsModel;


+ (CGFloat)heightForRow:(SXSsModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@end
