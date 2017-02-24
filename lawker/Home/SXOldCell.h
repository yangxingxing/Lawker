//
//  SXOldCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXOldModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick;

@end

@interface SXOldCell : UITableViewCell

@property(nonatomic,strong) SXOldModel *NewsModel;

+ (NSString *)idForRow:(SXOldModel *)NewsModel;

+ (CGFloat)heightForRow:(SXOldModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@end
