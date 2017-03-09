//
//  AdvancedBarrageController.h
//  lawker
//
//  Created by UnAsh on 15/11/18.
//  Copyright (c) 2015年 ExBye Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXNewsModel.h"

typedef NS_ENUM(NSUInteger, FromType) {
    FromOther,
    FromCash
};


@interface AdvancedBarrageController : UIViewController

@property(nonatomic,strong) SXNewsModel *newsModel;

@property(nonatomic,weak)NSString *docp;

@property(nonatomic,weak)NSString *skip;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) FromType from;
@property (nonatomic,copy) NSString *video;

@end
