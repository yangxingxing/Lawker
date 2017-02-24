//
//  SXMainTabBarController.m
//  lawker
//
//  Created by 董 尚先 on 15/4/9.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXMainTabBarController.h"
#import "SXBarButton.h"
#import "SXTabBar.h"

#import "SXMainViewController.h"
#import "SXNavController.h"

#import "UIView+Frame.h"

#import "SXNetworkTools.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"


@interface SXMainTabBarController ()<SXTabBarDelegate>

@property (weak,nonatomic) NSString *Npass;
@property (weak,nonatomic) NSString *Nuser;
@property (assign,nonatomic) int *Nuid;

@end

@implementation SXMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"update"];
    
    SXTabBar *tabBar = [[SXTabBar alloc]init];
    tabBar.frame = self.tabBar.bounds;
    tabBar.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    [self.tabBar addSubview:tabBar];
    
    tabBar.delegate = self;
    
    
    [tabBar addImageView];
    
    [tabBar addBarButtonWithNorName:@"tabbar_icon_news_normal" andDisName:@"tabbar_icon_news_highlight" andTitle:@"首页"];
    [tabBar addBarButtonWithNorName:@"tabbar_icon_reader_normal" andDisName:@"tabbar_icon_reader_highlight" andTitle:@"直播"];
    [tabBar addBarButtonWithNorName:@"tabbar_icon_media_normal" andDisName:@"tabbar_icon_media_highlight" andTitle:@"商场"];
    [tabBar addBarButtonWithNorName:@"tabbar_icon_me_normal" andDisName:@"tabbar_icon_me_highlight" andTitle:@"我的"];
    
    self.selectedIndex = 0;
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [arr lastObject];
    
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"tese.plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];

    if(dic[@"user"]&&dic[@"pass"]&&dic[@"uid"]){
        _Npass = dic[@"pass"];
        _Nuser = dic[@"user"];
        [self login:dic[@"uid"]];
    }
    
}


- (void)login:(id)sender {
    if(_Nuser.length == 0){
        return;
    }
    
    if(_Npass.length == 0){
        return;
    }
    
    NSString *allUrlstring = [NSString stringWithFormat:@"/login/%@/%@.html",[_Nuser stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],_Npass];
    NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        if([temArray[0][@"null"] isEqualToString:@"ok"]){
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            app.uid = [temArray[0][@"uid"] intValue];
            app.pass = _Npass;
            //NSLog(@"%@",temArray[0][@"uid"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
    
}

#pragma mark - ******************** SXTabBarDelegate代理方法
- (void)ChangSelIndexForm:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
}

@end
