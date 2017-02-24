//
//  SXErvCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXErtailModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick:(long)sender;

@end

@interface SXErvCell : UITableViewCell

@property(nonatomic,strong) SXErtailModel *NewsModel;


+ (NSString *)idForRow:(SXErtailModel *)NewsModel;


+ (CGFloat)heightForRow:(SXErtailModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;


@end
