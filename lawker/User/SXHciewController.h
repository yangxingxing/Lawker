//
//  SXHciewController.h
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXHcModel.h"

@interface SXHciewController : UITableViewController

@property(nonatomic,strong) SXHcModel *newsModel;

@property(nonatomic,copy) NSString *urlString;

@end
