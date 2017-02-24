//
//  SXShovCell.h
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights resShoved.
//

#import <UIKit/UIKit.h>
#import "SXShovModel.h"

@protocol btnClickedDelegate <NSObject>

-(void)buttonClick:(long)sender;

@end

@interface SXShovCell : UITableViewCell

@property(nonatomic,strong) SXShovModel *NewsModel;


+ (NSString *)idForRow:(SXShovModel *)NewsModel;


+ (CGFloat)heightForRow:(SXShovModel *)NewsModel;

@property (nonatomic,weak) id<btnClickedDelegate>  btnDelegate;


@end
