//
//  SXScCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXScModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick;

@end

@interface SXScCell : UITableViewCell

@property(nonatomic,strong) SXScModel *NewsModel;

+ (NSString *)idForRow:(SXScModel *)NewsModel;

+ (CGFloat)heightForRow:(SXScModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@end
