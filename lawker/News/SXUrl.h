//
//  SXUrl.h
//  lawker
//
//  Created by ASW on 2016-12-6.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXNewsModel.h"

@interface SXUrl : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@property(nonatomic,strong) SXNewsModel *sewsModel;

@property (nonatomic,copy) NSString *url;

@end
