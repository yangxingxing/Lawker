//
//  SXVideoiewController.h
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXVideoModel.h"

@interface SXVideoiewController : UIViewController

@property(nonatomic,strong) SXVideoModel *newsModel;

@property(nonatomic,copy) NSString *urlString;

@end
