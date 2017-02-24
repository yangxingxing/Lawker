//
//  SXBuyiewController.h
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXShovModel.h"

@interface SXBuviewController : UIViewController

@property(nonatomic,strong) SXShovModel *newsModel;

@property(nonatomic,copy) NSString *urlString;

@property (nonatomic,assign) NSInteger index;

@end
