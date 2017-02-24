//
//  SXVideoCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXVideoModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick;

@end

@interface SXVideoCell : UITableViewCell

@property(nonatomic,strong) SXVideoModel *NewsModel;

+ (NSString *)idForRow:(SXVideoModel *)NewsModel;

+ (CGFloat)heightForRow:(SXVideoModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@end
