//
//  SXZhiboiewController.h
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXZhiboModel.h"

@interface SXZhiboiewController : UITableViewController

@property(nonatomic,strong) SXZhiboModel *newsModel;

@property(nonatomic,copy) NSString *urlString;

@end
