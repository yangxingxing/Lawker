//
//  SXOreCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXOreModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick;

@end

@interface SXOreCell : UITableViewCell

@property(nonatomic,strong) SXOreModel *NewsModel;

+ (NSString *)idForRow:(SXOreModel *)NewsModel;

+ (CGFloat)heightForRow:(SXOreModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@end
