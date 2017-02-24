//
//  SXDetailController.m
//  lawker
//
//  Created by 董 尚先 on 15-1-24.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import "SXDetailController.h"
#import "SXDetailModel.h"
#import "SXDetailImgModel.h"
#import "SXHTTPManager.h"
#import "AppDelegate.h"
#import "SXNewsDetailBottomCell.h"
#import "SXSameNewsEntity.h"

#define NewsDetailControllerClose (self.tableView.contentOffset.y - (self.tableView.contentSize.height - SXSCREEN_H + 55) > (100 - 54))

@interface SXDetailController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property(nonatomic,strong) SXDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)SXNewsDetailBottomCell *closeCell;

@property(nonatomic,strong) NSMutableArray *replyModels;
/** 相似新闻*/
@property(nonatomic,strong)NSArray *sameNews;
/** 搜索关键字*/
@property(nonatomic,strong)NSArray *keywordSearch;

@property(nonatomic,strong) NSArray *news;

@property(nonatomic,weak)NSString *skip;

@property(nonatomic,weak)NSString *docp;

@property(nonatomic,assign)NSInteger rep;

@end

@implementation SXDetailController


- (NSMutableArray *)replyModels
{
    if (_replyModels == nil) {
        _replyModels = [NSMutableArray array];
    }
    return _replyModels;
}


- (NSArray *)news
{
    if (_news == nil) {
        _news = [NSArray array];
        _news = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewsURLs.plist" ofType:nil]];
    }
    return _news;
}

- (UIWebView *)webView
{
    if (!_webView) {
        UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SXSCREEN_W, 700)];
        _webView = web;
    }
    return _webView;
}

#pragma mark - ******************** 返回按钮
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@synthesize strTtile;

#pragma mark - ******************** 首次加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SXSCREEN_W, 300)];
//    self.webView.delegate = self;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
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

    NSString *url = [NSString stringWithFormat:@"http://localhost/full/%@/%@/%ld.html",_skip,_docp,app.uid];
    
    NSLog(@"%@",url);
    [[SXHTTPManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.detailModel = [SXDetailModel detailWithDict:responseObject[_docp]];

        [self showInWebView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure %@",error);
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;

}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.hidesBottomBarWhenPushed=YES;
//    }
//    return self;
//}


/** 提前把评论的请求也发出去 得到评论的信息 */
- (void)sendRequestWithUrl2:(NSString *)url
{

}

#pragma mark - ******************** 拼接html语言
- (void)showInWebView
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"SXDetails.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body style=\"background:#f6f6f6\">"];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    [self.webView loadHTMLString:html baseURL:nil];
}

- (NSString *)touchBody
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.detailModel.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",self.detailModel.ptime];
    if (self.detailModel.body != nil) {
        [body appendString:self.detailModel.body];
    }
    // 遍历img
    for (SXDetailImgModel *detailImgModel in self.detailModel.img) {
        NSMutableString *imgHtml = [NSMutableString string];
    
    // 设置img的div
    [imgHtml appendString:@"<div class=\"img-parent\">"];
    
    // 数组存放被切割的像素
        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
    // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        
        NSString *onload = @"this.onclick = function() {"
                            "  window.location.href = 'sx:src=' +this.src;"
                                    "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImgModel.src];
    // 结束标记
    [imgHtml appendString:@"</div>"];
    // 替换标记
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}

#pragma mark - ******************** 将发出通知时调用
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"sx:src="];
    if (range.location != NSNotFound) {
        NSInteger begin = range.location + range.length;
        NSString *src = [url substringFromIndex:begin];
        [self savePictureToAlbum:src];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webView.height = self.webView.scrollView.contentSize.height;
    [self.tableView reloadData];
}

#pragma mark - ******************** 保存到相册方法
- (void)savePictureToAlbum:(NSString *)src
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要保存到相册吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        NSURLCache *cache =[NSURLCache sharedURLCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
        NSData *imgData = [cache cachedResponseForRequest:request].data;
        UIImage *image = [UIImage imageWithData:imgData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }]];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ******************** 即将跳转时
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.webView;
    }else if (section == 1){
        SXNewsDetailBottomCell *head = [SXNewsDetailBottomCell theSectionHeaderCell];
        head.sectionHeaderLbl.text = @"热门跟帖";
        return head;
    }
    return [UIView new];
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.webView.height;
    }else if (section == 1){
        return self.replyModels.count > 0 ? 40 : CGFLOAT_MIN;
    }else if (section == 2){
        return self.sameNews.count > 0 ? 40 : CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2){
        SXNewsDetailBottomCell *closeCell = [SXNewsDetailBottomCell theCloseCell];
        self.closeCell = closeCell;
        return closeCell;
    }
    return [[UIView alloc]init];
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2){
        return 64;
    }
    return 15;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1 + self.replyModels.count;
    }else if (section == 2){
        return self.sameNews.count;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == self.replyModels.count) {
            [self performSegueWithIdentifier:@"toReply" sender:nil];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row > 0) {
            SXNewsModel *model = [[SXNewsModel alloc]init];
            model.docid = [self.sameNews[indexPath.row] id];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"News" bundle:nil];
            SXDetailController *devc = (SXDetailController *)[sb instantiateViewControllerWithIdentifier:@"SXDetailController"];
            devc.newsModel = model;
            
            [self.navigationController pushViewController:devc animated:YES];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [SXNewsDetailBottomCell theShareCell];
    }else if (indexPath.section == 1){
        SXNewsDetailBottomCell *foot = [SXNewsDetailBottomCell theSectionBottomCell];
        return foot;        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            SXNewsDetailBottomCell *cell = [SXNewsDetailBottomCell theKeywordCell];
            [cell.contentView addSubview:[self addKeywordButton]];
            return cell;
        }else{
            SXNewsDetailBottomCell *other = [SXNewsDetailBottomCell theContactNewsCell];
            other.sameNewsEntity = self.sameNews[indexPath.row];
            return other;
        }
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 126;
    }else if (indexPath.section == 1){
        if (indexPath.row == self.replyModels.count) {
            return 50;
        }else{
            return 110.5;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 81;
        }
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 126;
    }else if (indexPath.section == 1){
        if (indexPath.row == self.replyModels.count) {
            return 50;
        }else{
            return 110.5;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 81;
        }
    }
    return CGFLOAT_MIN;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.closeCell) {
        self.closeCell.iSCloseing = NewsDetailControllerClose;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"松手了%f--%f",self.tableView.contentOffset.y,self.tableView.contentSize.height - SXSCREEN_H + 55);
    if (NewsDetailControllerClose) {
        UIImageView *imgV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SXSCREEN_W, SXSCREEN_H)];
        imgV.image = [self getImage];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:imgV];
        [self.navigationController popViewControllerAnimated:NO];
        imgV.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^{
            imgV.frame = CGRectMake(0, SXSCREEN_H/2, SXSCREEN_W, 0);
            imgV.alpha = 0.0;
        } completion:^(BOOL finished) {
            [imgV removeFromSuperview];
        }];
    }
}


- (void)dealloc
{
    //NSLog(@"%s",__func__);
}

- (UIView *)addKeywordButton
{
    CGFloat maxRight = 20;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SXSCREEN_W, 60)];
    for (int i = 0;i<self.keywordSearch.count ; ++i) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(maxRight, 10, 0, 0)];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:SXRGBColor(74, 133, 198) forState:UIControlStateNormal];
        [button setTitle:self.keywordSearch[i][@"word"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"choose_city_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"choose_city_highlight"] forState:UIControlStateHighlighted];
        [button sizeToFit];
        button.width += 20;
        button.height = 35;
        maxRight = button.x + button.width + 10;
        [view addSubview:button];
    }
    return view;
}

- (UIImage *)getImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SXSCREEN_W, SXSCREEN_H), NO, 1.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
