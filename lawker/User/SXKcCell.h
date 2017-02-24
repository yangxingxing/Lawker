//
//  SXKcCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXKcModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick;

@end

@interface SXKcCell : UITableViewCell

@property(nonatomic,strong) SXKcModel *NewsModel;

+ (NSString *)idForRow:(SXKcModel *)NewsModel;

+ (CGFloat)heightForRow:(SXKcModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@end
