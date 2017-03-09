//
//  BhcancedBarrageController.m
//  lawker
//
//  Created by UnAsh on 15/11/18.
//  Copyright (c) 2015年 ExBye Inc. All rights reserved.
//

#import "BhcancedBarrageController.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "XCAVPlayerView.h"

@interface BhcancedBarrageController()<UIWebViewDelegate>
{
    NSInteger _index;
    NSDate * _startTime;
    NSString *b;
    NSString *t;
}

@property (nonatomic,strong)NSMutableArray *bodylist;
@property (nonatomic,strong)NSMutableArray *dmlist;
@property (nonatomic, strong) XCAVPlayerView *playerView;
@property (nonatomic, strong) MPVolumeView *volumeView;

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation BhcancedBarrageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString  *a = app.title;
    if(a.length>11){
        b = [NSString stringWithFormat:@"%@...",[a substringToIndex:11]];
    }else{
        b = a;
    }
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"hc/%@.mp4", a]];
    
    self.navigationItem.title = b;
    
    _playerView = [[XCAVPlayerView alloc]init];
    _playerView.owner = self;
    UIView *playBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.6)];
    [self.view addSubview:playBgView];
    self.playerView.frame = playBgView.bounds;
    self.playerView.videoTitle = app.title;
    [playBgView addSubview:self.playerView];
    self.playerView.playerUrl = [NSURL fileURLWithPath:path];
    [self.playerView play];
    
    t = app.title;
    
    [self showInWebView];
    
}

- (void)showInWebView
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body>"];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    [self.webview loadHTMLString:html baseURL:nil];
}

- (NSString *)touchBody
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div>%@</div>",t];
    return body;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.playerView play];

    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.playerView pause];
    }
}

@end
