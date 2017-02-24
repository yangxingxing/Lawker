//
//  AdvancedBarrageController.m
//  lawker
//
//  Created by UnAsh on 15/11/18.
//  Copyright (c) 2015年 ExBye Inc. All rights reserved.
//

#import "AdvancedBarrageController.h"
#import "BarrageRenderer.h"
#import "BarrageWalkImageTextSprite.h"
#import "SXNetworkTools.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "SXAdvCell.h"
#import "NSString+Base64.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "XCAVPlayerView.h"
#import "LXNetworking.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface AdvancedBarrageController()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,BarrageRendererDelegate,btnClickedDelegate,btnwidthDelegate>
{
    BarrageRenderer * _renderer;
    NSDate * _startTime;
    NSString *b;
    NSString *t;
    NSString *v2right;
    NSString *video;
    NSString *vitle;
    NSString *vizix;
    NSString *vizix2;
    NSString *viurl;
    NSString *viimg;
    NSString *sf;
    NSString *jiage;
}
@property (nonatomic,strong)LXURLSessionTask *task;
@property (weak, nonatomic) IBOutlet UITableView *tabelview;
@property (weak, nonatomic) IBOutlet UITableView *tabelview2;
@property (weak, nonatomic) IBOutlet UITableView *tabelview3;
@property (weak, nonatomic) IBOutlet UIView *textform;
@property (weak, nonatomic) IBOutlet UILabel *progressLab;

@property (weak, nonatomic) IBOutlet UIView *vright;

@property (nonatomic,strong)NSMutableArray *bodylist;
@property (nonatomic,strong)NSMutableArray *dmlist;
@property (nonatomic, strong) XCAVPlayerView *playerView;
@property (nonatomic, strong) MPVolumeView *volumeView;

@property(nonatomic,strong) NSMutableArray *arrayList;

@property(nonatomic,strong) NSMutableArray *arrayList2;
@property(nonatomic,strong) NSMutableArray *arrayList3;
@property(nonatomic,strong) NSMutableArray *arrayList4;

@property (weak, nonatomic) IBOutlet UIButton *b11;
@property (weak, nonatomic) IBOutlet UIButton *b22;
@property (weak, nonatomic) IBOutlet UIButton *b33;
@property (weak, nonatomic) IBOutlet UIButton *t3;
//@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@property (weak, nonatomic) IBOutlet UIView *sv;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (weak, nonatomic) IBOutlet UIButton *sc1;
@property (weak, nonatomic) IBOutlet UIButton *sc2;
@property (weak, nonatomic) IBOutlet UIView *down;
@property (weak, nonatomic) IBOutlet UIButton *b44;
@property (weak, nonatomic) IBOutlet UIButton *b55;
//@property (weak, nonatomic) IBOutlet UIScrollView *webview;
@property (weak, nonatomic) IBOutlet UIView *webview;
@property (weak, nonatomic) IBOutlet UIWebView *webview2;
@property (weak, nonatomic) IBOutlet UITableView *tabelview4;
@property (weak, nonatomic) IBOutlet UILabel *mjg;
@property (weak, nonatomic) IBOutlet UIView *goum;
@property (weak, nonatomic) IBOutlet UIView *gouz;
@property (weak, nonatomic) IBOutlet UILabel *mjg2;
@property (weak, nonatomic) IBOutlet UIView *dmop;
@property (weak, nonatomic) IBOutlet UIButton *dm111;
@property (weak, nonatomic) IBOutlet UIButton *dm222;
@property (weak, nonatomic) IBOutlet UIView *sudu;
@property (weak, nonatomic) IBOutlet UIButton *sd111;
@property (weak, nonatomic) IBOutlet UIButton *sd222;
@property (weak, nonatomic) IBOutlet UIButton *sd333;

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@property(nonatomic,assign)BOOL update;
@end

@implementation AdvancedBarrageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.allowRotation = YES;
    //app.docxid = sender.titleLabel.text;
    //NSLog(@" %@ - %@ ",  app.docxtag , app.docxid);
    if(self.newsModel.docid){
        _docp = self.newsModel.docid;
    }else{
        _docp = app.docxtag;
    }
    
    if(self.newsModel.skipID){
        _skip = self.newsModel.skipID;
    }else{
        _skip = app.docxid;
    }

    self.update = YES;

    NSString *allUrlstring = [NSString stringWithFormat:@"/full/%@/%@/%ld.html",_skip,_docp,(long)app.uid];
    
    NSLog(@"%@",allUrlstring);
    
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        NSString *a = temArray[0][@"title"];
        if(a.length>8){
            b = [NSString stringWithFormat:@"%@...",[a substringToIndex:8]];
        }else{
            b = a;
        }
        if([temArray[0][@"sc"] isEqualToString:@"ok"]){
            _sc2.hidden = NO;
            _sc1.hidden = YES;
        }
        
        self.navigationItem.title = b;
        
        _renderer = [[BarrageRenderer alloc]init];
        _renderer.delegate = self;
        _renderer.redisplay = YES;
        _renderer.canvasMargin = UIEdgeInsetsMake(5, ScreenWidth, ScreenWidth, 375);
        
        _playerView = [[XCAVPlayerView alloc]init];
        UIView *playBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.6)];
        [self.view insertSubview:_renderer.view belowSubview:_vright];
        [self.view insertSubview:playBgView belowSubview:_renderer.view];
        self.playerView.frame = playBgView.bounds;
        self.playerView.videoTitle = temArray[0][@"title"];
        self.playerView.retas = @"1";
        [playBgView addSubview:self.playerView];
        self.playerView.playerUrl = [NSURL URLWithString:temArray[0][@"body"]];
        [self.playerView play];
        
        t = temArray[0][@"info"];
        
        video = temArray[0][@"body"];
        vitle = [NSString stringWithFormat:@"%@-%@",temArray[0][@"num"],temArray[0][@"title"]];
        vizix = temArray[0][@"vizix"];
        vizix2 = temArray[0][@"vizix2"];
        viurl = temArray[0][@"url"];
        viimg = temArray[0][@"img"];
        sf = temArray[0][@"sf"];
        jiage = temArray[0][@"jiage"];
        NSDictionary* rObject = temArray[0][@"gg"];
        
        self.tabelview4.delegate = self;
        self.tabelview4.dataSource = self;
        self.tabelview4.separatorStyle = NO;
        
        NSMutableArray *arrayM2 = [SXAdvModel objectArrayWithKeyValuesArray:rObject];
        //NSLog(@"%@",arrayM2);
        self.arrayList4 = arrayM2;
        [self.tabelview4 reloadData];
        
        if([sf isEqualToString:@"ok"] && jiage >0){
            app.but = [NSString stringWithFormat:@"%@/1.html",_docp];
            if([_skip isEqualToString:@"fruit_kc"]){
                _mjg2.text = [NSString stringWithFormat:@"价格 %@元",jiage];
                [self.playerView pause];
                [_renderer stop];
                [_task cancel];                
                _gouz.hidden = NO;
                if(app.uid > 0){
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"pay"];
                    [self.navigationController pushViewController:jview animated:YES];
                    app.buv = 2;
                }else{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"FLO"];
                    app.reh = @"1";
                    [self.navigationController pushViewController:jview animated:YES];
                }
            }else{
                app.buv = 3;
            }
        }
      
        _bodylist = temArray[0][@"bodylist"];
        
        [self showInWebView];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
    
    if([_skip isEqualToString:@"web_cp"]){
        
        UIImage *searchimage=[UIImage imageNamed:@"right_navigation"];
        UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(searchprogram)];
        barbtn.image=searchimage;
        self.navigationItem.rightBarButtonItem=barbtn;
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *createPath = [NSString stringWithFormat:@"%@/hc", pathDocuments];
        NSString *createDir = [NSString stringWithFormat:@"%@/xz", pathDocuments];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
            [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        self.tabelview.delegate = self;
        self.tabelview.dataSource = self;
        self.tabelview.separatorStyle = NO;
        [self.tabelview addHeaderWithTarget:self action:@selector(loadData)];
        
        [self.tabelview addFooterWithTarget:self action:@selector(loadMoreData)];
        
        self.tabelview2.delegate = self;
        self.tabelview2.dataSource = self;
        self.tabelview2.separatorStyle = NO;
        
        self.tabelview3.delegate = self;
        self.tabelview3.dataSource = self;
        self.tabelview3.separatorStyle = NO;
        [self.tabelview3 addHeaderWithTarget:self action:@selector(loadData3)];
        
        [self.tabelview3 addFooterWithTarget:self action:@selector(loadMoreData3)];
        
        //[self.tabelview2 addHeaderWithTarget:self action:@selector(loadData2)];
        
        //[self.tabelview2 addFooterWithTarget:self action:@selector(loadMoreData2)];
        
        [self.searchbar setImage:[UIImage imageNamed:@"addres-3"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        
        //[self loadData];
        [self loadData2];
        [self loadData3];
        
        allUrlstring = [NSString stringWithFormat:@"/dm/%@/%@.html",_skip,_docp];
        
        NSLog(@"%@",allUrlstring);
        
        [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
            NSString *key = [responseObject.keyEnumerator nextObject];
            
            _dmlist = responseObject[key];
            [self initBarrageRenderer];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //NSLog(@"%@",error);
        }] resume];
        _dmop.hidden = NO;
        _sudu.hidden = NO;
    }else{
        UIImage *searchimage=[UIImage imageNamed:@"fx"];
        UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleDone target:self action:@selector(fxd)];
        barbtn.image=searchimage;
        self.navigationItem.rightBarButtonItem=barbtn;
        
        _tabelview.hidden = YES;
        _t3.hidden = YES;
        _tabelview2.hidden = YES;
        _b11.hidden = YES;
        _b22.hidden = YES;
        _b33.hidden = YES;
        _b44.hidden = NO;
        _b55.hidden = NO;
        _webview.hidden = NO;
        
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://lawker.cn:14321/"]];
        [_webview2 loadRequest:request];
    }

    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    
    [self.webView loadHTMLString:html baseURL:nil];
}

- (NSString *)touchBody
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div>%@</div>",t];
    return body;
}

-(void)searchprogram{
    if(v2right.length == 0){
        _vright.hidden = NO;
        _dmop.hidden = YES;
        v2right = @"取消";
    }else{
        _vright.hidden = YES;
        _dmop.hidden = NO;
        v2right = @"";
    }
}
- (IBAction)qx:(id)sender {
    [self alert:@"确定取消嘛?"];
}

- (IBAction)sc:(id)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.uid){
        NSString *allUrlstring = [NSString stringWithFormat:@"/sc/%ld/%@/%@.html",(long)app.uid,_docp,app.pass];
        NSLog(@"%@",allUrlstring);
        [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
            NSString *key = [responseObject.keyEnumerator nextObject];
            
            NSArray *temArray = responseObject[key];
            
            if([temArray[0][@"null"] isEqualToString:@"ok"]){
                _sc2.hidden = NO;
                _sc1.hidden = YES;
            }else{
                [self alert:@"已收藏"];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //NSLog(@"%@",error);
        }] resume];

    }else{
        [self.playerView pause];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"FLO"];
        app.reh = @"1";
        [self.navigationController pushViewController:jview animated:YES];
    }
}

- (IBAction)hc:(id)sender {
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/hc/%@.mp4", vitle]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [self alert:@"缓存完成"];
    }else{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.uid){
        _down.hidden = NO;
        NSString *path=[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/hc/%@.fruit", vitle]];
        _task = [LXNetworking downloadWithUrl:video saveToPath:path progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            //封装方法里已经回到主线程，所有这里不用再调主线程了
            _progressLab.text = [NSString stringWithFormat:@"缓存进度 %.2f",1.0 * bytesProgress/totalBytesProgress];
            [self.playerView pause];
        } success:^(id response) {
            NSFileManager *fm = [NSFileManager defaultManager];
            NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/hc"];
            NSString *toPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"/%@.mp4",vitle]];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"/%@.fruit",vitle]];
            [fm createDirectoryAtPath:[toPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
            NSError *error;
            [fm moveItemAtPath:filePath toPath:toPath error:&error];
            NSString *path=[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/hc/%@.jpg", vitle]];
            _task = [LXNetworking downloadWithUrl:viimg saveToPath:path progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            } success:^(id response) {
                [self alert:@"缓存完成"];
                _down.hidden = YES;
            } failure:^(NSError *error) {
            } showHUD:NO];
            _down.hidden = YES;
        } failure:^(NSError *error) {
            
            //[self alert:@"缓存中断"];
        } showHUD:NO];
    }else{
        [self.playerView pause];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"FLO"];
        app.reh = @"1";
        [self.navigationController pushViewController:jview animated:YES];
    }
    }
}

-(void)fxd{
    //1、创建分享参数
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    NSArray* imageArray = @[[UIImage imageNamed:@"night_comment_profile_mars"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:t images:viimg url:[NSURL URLWithString:viurl] title:vitle type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        }];
    }
}

- (IBAction)fx:(id)sender {
    [self fxd];
}

- (IBAction)xz:(id)sender {
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.uid){
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:vizix]];
//        _down.hidden = NO;
//        NSString *path=[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/xz/%@", vizix2]];
//        _task = [LXNetworking downloadWithUrl:vizix saveToPath:path progress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//            //封装方法里已经回到主线程，所有这里不用再调主线程了
//            _progressLab.text = [NSString stringWithFormat:@"下载进度 %.2f",1.0 * bytesProgress/totalBytesProgress];
//            [self.playerView pause];
//        } success:^(id response) {
//            [self alert:@"下载完成"];
//            _down.hidden = YES;
//        } failure:^(NSError *error) {
//            _down.hidden = YES;
//            [self alert:@"下载失败"];
//        } showHUD:NO];
    }else{
        [self.playerView pause];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"FLO"];
        app.reh = @"1";
        [self.navigationController pushViewController:jview animated:YES];
    }
}

-(void)butwidth:(NSInteger)txt{
    NSLog(@"%ld",(long)txt);
}

- (IBAction)dm11:(id)sender {
    _renderer.view.hidden = YES;
    _dm111.hidden = YES;
    _dm222.hidden = NO;
}

- (IBAction)dm22:(id)sender {
    _renderer.view.hidden = NO;
    _dm111.hidden = NO;
    _dm222.hidden = YES;
}

- (IBAction)sd11:(id)sender {
    _sd111.hidden = YES;
    _sd222.hidden = YES;
    _sd333.hidden = NO;
    [self.playerView pause];
    self.playerView.retas = @"2";
    [self.playerView play];
}

- (IBAction)sd22:(id)sender {
    _sd111.hidden = NO;
    _sd222.hidden = YES;
    _sd333.hidden = YES;
    [self.playerView pause];
    self.playerView.retas = @"1";
    [self.playerView play];
}
- (IBAction)sd33:(id)sender {
    _sd111.hidden = YES;
    _sd222.hidden = NO;
    _sd333.hidden = YES;
    [self.playerView pause];
    self.playerView.retas = @"1.5";
    [self.playerView play];
}

-(void)buttonClick:(NSInteger)txt{
    self.playerView.playerUrl = [NSURL URLWithString:_bodylist[txt-1][@"info"]];
    [self initBarrageRenderer];
    _goum.hidden = YES;
    [self.playerView play];
    _docp = _bodylist[txt-1][@"docid"];
    [self loadData];
}

- (void)initBarrageRenderer
{
    _startTime = [NSDate date];
    [_renderer start];
    NSInteger const number = _dmlist.count;
    NSMutableArray * descriptors = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < number; i++) {
        [descriptors addObject:[self walkTextSpriteDescriptorWithDelay:[_dmlist[i][@"time"] intValue] txt:_dmlist[i][@"text"]]];
    }
    [_renderer load:descriptors];
}

- (void)dealloc
{
    [_renderer stop];
}

- (BarrageDescriptor *)walkTextSpriteDescriptorWithDelay:(NSTimeInterval)delay txt:(NSString*)txt
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@"%@",txt];
    descriptor.params[@"textColor"] = [UIColor whiteColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(1);
    descriptor.params[@"delay"] = @(delay);
    return descriptor;
}
- (IBAction)b4:(id)sender {
    [_b44 setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:77.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [_b55 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _webview.hidden = NO;
    _tabelview4.hidden = YES;
}
- (IBAction)b5:(id)sender {
    [_b44 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b55 setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:77.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    _webview.hidden = YES;
    _tabelview4.hidden = NO;
}

- (IBAction)b1:(id)sender {
    _tabelview.hidden = NO;
    _tabelview2.hidden = NO;
    _t3.hidden = NO;
     _sv.hidden = YES;
    _tabelview3.hidden = YES;
    _textform.hidden = YES;
    [_b11 setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:77.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [_b22 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b33 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)b2:(id)sender {
    _tabelview.hidden = YES;
    _tabelview2.hidden = YES;
    _t3.hidden = YES;
    _sv.hidden = NO;
    _tabelview3.hidden = YES;
    _textform.hidden = YES;
    [_b11 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b22 setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:77.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [_b33 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (IBAction)b3:(id)sender {
    _tabelview.hidden = YES;
    _tabelview2.hidden = YES;
    _t3.hidden = YES;
    _sv.hidden = YES;
    _tabelview3.hidden = NO;
    _textform.hidden = NO;
    [_b11 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b22 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b33 setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:77.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
}

- (NSTimeInterval)timeForBarrageRenderer:(BarrageRenderer *)renderer
{
    NSTimeInterval interval = [[NSDate date]timeIntervalSinceDate:_startTime];
    int intime = interval;
    if(intime >= 6 && [sf isEqualToString:@"ok"]){
        _goum.hidden = NO;
        _mjg.text = [NSString stringWithFormat:@"价格 %@元",jiage];
        [self.playerView pause];
        [_renderer stop];
        [_task cancel];
    }
    return interval;
}

- (IBAction)mgou:(id)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if([sf isEqualToString:@"ok"] && jiage >0){
        
        app.but = [NSString stringWithFormat:@"%@/1.html",_docp];
        
        if([_skip isEqualToString:@"fruit_kc"]){
            app.buv = 2;
            _gouz.hidden = NO;
            _mjg2.text = [NSString stringWithFormat:@"价格 %@元",jiage];
            [self.playerView pause];
            [_renderer stop];
            [_task cancel];
        }else{
            app.buv = 3;
        }
        if(app.uid > 0){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"pay"];
            [self.navigationController pushViewController:jview animated:YES];
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"FLO"];
            app.reh = @"1";
            [self.navigationController pushViewController:jview animated:YES];
        }
    }
}

- (void)loadData
{
    NSString *allUrlstring = [NSString stringWithFormat:@"/adv/%@/%@.html",_skip,_docp];
    [self loadDataForType:1 withURL:allUrlstring];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    allUrlstring = [NSString stringWithFormat:@"/full/%@/%@/%ld.html",_skip,_docp,(long)app.uid];
    
    //NSLog(@"%@",allUrlstring);
    
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
      
        vitle = [NSString stringWithFormat:@"%@-%@",temArray[0][@"num"],temArray[0][@"title"]];
  
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}

- (void)loadMoreData
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/adv/%@/%@/%ld-20.html",_skip,_docp,(long)(20 * app.navid)];
    
    [self loadDataForType:2 withURL:allUrlstring];
}

- (void)loadData2
{
    NSString *allUrlstring = [NSString stringWithFormat:@"/adv2/%@/%@.html",_skip,_docp];
    [self loadDataForType2:1 withURL:allUrlstring];
}

- (void)loadMoreData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/adv2/%@/%@/%ld-20.html",_skip,_docp,(long)(20 * app.navid2)];
    
    [self loadDataForType2:2 withURL:allUrlstring];
}

- (void)loadData3
{
    NSString *allUrlstring = [NSString stringWithFormat:@"/pl/%@/%@.html",_skip,_docp];
    [self loadDataForType3:1 withURL:allUrlstring];
}

- (void)loadMoreData3
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/pl/%@/%@/%ld-20.html",_skip,_docp,(long)(20 * app.navid3)];
    
    [self loadDataForType3:2 withURL:allUrlstring];
}

- (void)loadDataForType3:(int)type withURL:(NSString *)allUrlstring
{
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        //[self.tableView headerBeginRefreshing];
        NSMutableArray *arrayM = [SXAdvModel objectArrayWithKeyValuesArray:temArray];
        _searchbar.text = @"";
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (type == 1) {
            self.arrayList3 = arrayM;
            [self.tabelview3 headerEndRefreshing];
            [self.tabelview3 reloadData];
        }else if(type == 2){
            [self.arrayList3 addObjectsFromArray:arrayM];
            
            [self.tabelview3 footerEndRefreshing];
            [self.tabelview3 reloadData];
            app.navid = app.navid3 +1;
        }else{
            self.arrayList3 = arrayM;
            [self.tabelview3 headerEndRefreshing];
            [self.tabelview3 reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}


- (void)loadDataForType2:(int)type withURL:(NSString *)allUrlstring
{
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        //[self.tableView headerBeginRefreshing];
        NSMutableArray *arrayM = [SXAdvModel objectArrayWithKeyValuesArray:temArray];
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (type == 1) {
            self.arrayList2 = arrayM;
            [self.tabelview2 headerEndRefreshing];
            [self.tabelview2 reloadData];
        }else if(type == 2){
            [self.arrayList2 addObjectsFromArray:arrayM];
            
            [self.tabelview2 footerEndRefreshing];
            [self.tabelview2 reloadData];
            app.navid = app.navid2 +1;
        }else{
            self.arrayList2 = arrayM;
            [self.tabelview2 headerEndRefreshing];
            [self.tabelview2 reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}


- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        //[self.tableView headerBeginRefreshing];
        NSMutableArray *arrayM = [SXAdvModel objectArrayWithKeyValuesArray:temArray];
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (type == 1) {
            self.arrayList = arrayM;
            [self.tabelview headerEndRefreshing];
            [self.tabelview reloadData];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            
            [self.tabelview footerEndRefreshing];
            [self.tabelview reloadData];
            app.navid = app.navid +1;
        }else{
            self.arrayList = arrayM;
            [self.tabelview headerEndRefreshing];
            [self.tabelview reloadData];
            //[self viewDidLoad];
            
            //SXOldiewController *load2 =[[SXOldiewController alloc]init];
            //load2.self.arrayList = arrayM;
            //[load2.self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}

- (void)welcome
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"update"];
    [self.tabelview headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.playerView play];
    //_goum.hidden = YES;
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"update"]) {
        return;
    }
    
    if (self.update == YES) {
        [self.tabelview headerBeginRefreshing];
        self.update = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.playerView pause];
        [_renderer stop];
        [_task cancel];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%@",tableView);
    if ([tableView isEqual:_tabelview]) {
        return self.arrayList.count;
    }else if ([tableView isEqual:_tabelview2]) {
        return self.arrayList2.count;
    }else if ([tableView isEqual:_tabelview3]) {
        return self.arrayList3.count;
    }else{
        return self.arrayList4.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tabelview]) {
        SXAdvModel *newsModel = self.arrayList[indexPath.row];
        NSString *ID = @"newslist";
        
        SXAdvCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        cell.NewsModel = newsModel;
        
        cell.btnDelegate =self;
        
        return cell;
    }
    else  if ([tableView isEqual:_tabelview2]) {
        SXAdvModel *newsModel = self.arrayList2[indexPath.row];
        NSString *ID = @"newslist2";
        
        SXAdvCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        cell.NewsModel = newsModel;
        
        cell.btnDelegate =self;
        
        return cell;
    }
    else  if ([tableView isEqual:_tabelview4]) {
        SXAdvModel *newsModel = self.arrayList4[indexPath.row];
        NSString *ID = @"newslist4";
        
        SXAdvCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        cell.NewsModel = newsModel;
        
        cell.btnDelegate =self;
        
        return cell;
    }
    else
    {
        SXAdvModel *newsModel = self.arrayList3[indexPath.row];
        NSString *ID = @"newslist3";
        SXAdvCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        cell.NewsModel = newsModel;
        
        cell.btnDelegate =self;
        
        return cell;
    }
    return nil;
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tabelview3]) {
        return 100;
    }else if ([tableView isEqual:_tabelview4]) {
        return 248;
    }else{
        return 50;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor yellowColor];
}

-(void)alert:(NSString *)txt{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"lawker提示" message:txt preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _down.hidden = YES;
        [_task cancel];
        [self.playerView play];
    }];
    
    UIAlertAction *Action2 = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil];
    
    [alertCtrl addAction:Action];
    
    if([txt isEqualToString:@"确定取消嘛?"]){
    [alertCtrl addAction:Action2];
    }
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self.view endEditing:YES];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.uid){
        [searchBar resignFirstResponder];
    
        NSString *searchKeyWord = [searchBar.text base64encode];
        if(searchKeyWord.length>0){
            NSString *url = [NSString stringWithFormat:@"/addpl/%@/%@/%ld/%@.html",_skip,_docp,(long)app.uid,searchKeyWord];
    
            [self loadDataForType3:1 withURL:url];
        }else{
            [self alert:@"没有输入评论内容"];
        }
    }else{
        [self.playerView pause];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"FLO"];
        app.reh = @"1";
        [self.navigationController pushViewController:jview animated:YES];
    }
}

- (IBAction)fssb:(id)sender {
    [self.view endEditing:YES];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.uid){
        
        NSString *searchKeyWord = [_searchbar.text base64encode];
        if(searchKeyWord.length>0){
            NSString *url = [NSString stringWithFormat:@"/addpl/%@/%@/%ld/%@.html",_skip,_docp,(long)app.uid,searchKeyWord];
            
            [self loadDataForType3:1 withURL:url];
        }else{
            [self alert:@"没有输入评论内容"];
        }
    }else{
        [self.playerView pause];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"FLO"];
        app.reh = @"1";
        [self.navigationController pushViewController:jview animated:YES];
    }
}


@end
