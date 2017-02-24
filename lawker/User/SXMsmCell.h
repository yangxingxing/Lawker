//
//  SXMsmCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXMsmModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick;

@end

@interface SXMsmCell : UITableViewCell

@property(nonatomic,strong) SXMsmModel *NewsModel;

+ (NSString *)idForRow:(SXMsmModel *)NewsModel;

+ (CGFloat)heightForRow:(SXMsmModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@end
