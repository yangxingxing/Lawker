//
//  SXAdvCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXAdvModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick:(NSInteger)txt;

@end

@protocol btnwidthDelegate <NSObject>

-(void)butwidth:(NSInteger)txt;

@end

@interface SXAdvCell : UITableViewCell

@property(nonatomic,strong) SXAdvModel *NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@property (nonatomic,weak) id<btnwidthDelegate>  btnwidth;

@end
