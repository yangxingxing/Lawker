//
//  SXHcCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXHcModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick;

@end

@interface SXHcCell : UITableViewCell

@property(nonatomic,strong) SXHcModel *NewsModel;

+ (NSString *)idForRow:(SXHcModel *)NewsModel;

+ (CGFloat)heightForRow:(SXHcModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;

@end
