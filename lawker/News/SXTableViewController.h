//
//  SXTableViewController.h
//  lawker
//
//  Created by 董 尚先 on 15-1-22.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SXErtailModel.h"

@interface SXTableViewController : UITableViewController

//@property(nonatomic,strong) SXErtailModel *newsModel;
/**
 *  url端口
 */
@property(nonatomic,copy) NSString *urlString;

@property (nonatomic,assign) NSInteger index;

@end
