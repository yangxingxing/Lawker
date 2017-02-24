//
//  SXJfCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXJfModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick;

@end

@interface SXJfCell : UITableViewCell

@property(nonatomic,strong) SXJfModel *NewsModel;

+ (NSString *)idForRow:(SXJfModel *)NewsModel;

+ (CGFloat)heightForRow:(SXJfModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@end
