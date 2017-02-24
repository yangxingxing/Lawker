//
//  SXSsiewController.h
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXSsModel.h"

@interface SXSsiewController : UIViewController

@property(nonatomic,strong) SXSsModel *newsModel;

@property(nonatomic,copy) NSString *urlString;

@property(nonatomic,copy)NSString *keyword;

@end
