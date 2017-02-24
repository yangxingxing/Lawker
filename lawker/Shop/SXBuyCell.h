//
//  SXBuyCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXBuyModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick;

@end

@interface SXBuyCell : UITableViewCell

@property(nonatomic,strong) SXBuyModel *NewsModel;

+ (NSString *)idForRow:(SXBuyModel *)NewsModel;

+ (CGFloat)heightForRow:(SXBuyModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@end
