//
//  SXAddresCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXAddresModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick:(int)tag;

@end

@interface SXAddresCell : UITableViewCell

@property(nonatomic,strong) SXAddresModel *NewsModel;

+ (NSString *)idForRow:(SXAddresModel *)NewsModel;

+ (CGFloat)heightForRow:(SXAddresModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@end
