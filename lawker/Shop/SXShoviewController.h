//
//  SXShoviewController.h
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights resShoved.
//

#import <UIKit/UIKit.h>
#import "SXShovModel.h"

@interface SXShoviewController : UITableViewController

@property(nonatomic,strong) SXShovModel *newsModel;

@property(nonatomic,copy) NSString *urlString;

@end
