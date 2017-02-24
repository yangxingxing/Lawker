//
//  SXShop.m
//  lawker
//
//  Created by ASW on 2016-12-6.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXShop.h"

@implementation SXShop

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"商城";
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://znzlaw.m.tmall.com/"]];
    [_webview loadRequest:request];   
    
}

@end
