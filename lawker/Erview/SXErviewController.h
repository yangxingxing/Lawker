//
//  SXErviewController.h
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXErtailModel.h"

@interface SXErviewController : UITableViewController

@property(nonatomic,strong) SXErtailModel *newsModel;

@property(nonatomic,copy) NSString *urlString;

//- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring;

@end
