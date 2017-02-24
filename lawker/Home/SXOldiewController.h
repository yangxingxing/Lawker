//
//  SXOldiewController.h
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXOldModel.h"

@interface SXOldiewController : UITableViewController

@property(nonatomic,strong) SXOldModel *newsModel;

@property(nonatomic,copy) NSString *urlString;

@end
