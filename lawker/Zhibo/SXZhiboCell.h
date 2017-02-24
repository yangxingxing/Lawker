//
//  SXZhiboCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXZhiboModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick;

@end

@interface SXZhiboCell : UITableViewCell

@property(nonatomic,strong) SXZhiboModel *NewsModel;

+ (NSString *)idForRow:(SXZhiboModel *)NewsModel;

+ (CGFloat)heightForRow:(SXZhiboModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@end
