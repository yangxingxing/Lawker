//
//  ESaiController.h
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESaiModel.h"

@interface ESaiController : UITableViewController

@property(nonatomic,strong) ESaiModel *newsModel;

@property (nonatomic,assign) NSInteger index;

@property(nonatomic,copy) NSString *urlString;

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring;

@end
