//
//  AdvancedBarrageController.h
//  lawker
//
//  Created by UnAsh on 15/11/18.
//  Copyright (c) 2015年 ExBye Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXNewsModel.h"

@interface AdvancedBarrageController : UIViewController

@property(nonatomic,strong) SXNewsModel *newsModel;

@property(nonatomic,weak)NSString *docp;

@property(nonatomic,weak)NSString *skip;

@property (nonatomic,assign) NSInteger index;
@end
