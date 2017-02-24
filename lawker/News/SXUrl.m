//
//  SXUrl.m
//  lawker
//
//  Created by ASW on 2016-12-6.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXUrl.h"
#import "AppDelegate.h"

@implementation SXUrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(self.sewsModel.url){
        _url = self.sewsModel.url;
    }else{
        _url = app.docurl;
    }
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_url]]];
    [_webview loadRequest:request];   
    
}

@end
