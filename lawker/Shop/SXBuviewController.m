//
//  SXBuyiewController.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//


#import "SXBuviewController.h"
#import "SXNetworkTools.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface SXBuviewController ()<UIWebViewDelegate>
{
    NSString *t;
    int kucun;
    NSString *b;
}

@property (weak, nonatomic) IBOutlet UIImageView *lblicon;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle2;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle3;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle4;
@property (weak, nonatomic) IBOutlet UITextField *lbltitle5;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewgao;

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@end

@implementation SXBuviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webview.delegate = self;
    
    NSString *allUrlstring = [NSString stringWithFormat:@"/vshow/%@.html",self.newsModel.listextra[_index][@"docid"]];
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        
        [self.lblicon sd_setImageWithURL:[NSURL URLWithString:responseObject[@"imgsrc"]]placeholderImage:[UIImage imageNamed:@"302"]];
        _lbltitle.text =responseObject[@"title"];
        
        NSString *a = responseObject[@"title"];
        if(a.length>8){
            b = [NSString stringWithFormat:@"%@...",[a substringToIndex:8]];
        }else{
            b = a;
        }
        
        self.navigationItem.title = b;
        
        _lbltitle2.text = [NSString stringWithFormat:@"价格 %@元",responseObject[@"jg"]];
        
        _lbltitle3.text = [NSString stringWithFormat:@"积分 %@",responseObject[@"jf"]];
        
        CGFloat count =  [responseObject[@"replyCount"] intValue];
        NSString *displayCount;
        if (count > 10000) {
            displayCount = [NSString stringWithFormat:@"库存 %.1f万",count/10000];
        }else{
            displayCount = [NSString stringWithFormat:@"库存 %.0f",count];
        }
        
        kucun = [responseObject[@"replyCount"] intValue];
        
        _lbltitle4.text = displayCount;
        
        t = responseObject[@"info"];
        [self showInWebView];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
    
}

- (void)showInWebView
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:[NSString stringWithFormat:@"<style>img{max-width: %f;}</style>",ScreenWidth]];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body>"];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    [self.webview loadHTMLString:html baseURL:nil];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)wb
{
    CGRect frame = wb.frame;
    frame.size.height = wb.scrollView.contentSize.height;
    _viewgao.constant = frame.size.height+211;
}

- (NSString *)touchBody
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div>%@</div>",t];
    return body;
}

-(void)alert:(NSString *)txt{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"lawker提示" message:txt preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Action;
    UIAlertAction *Action2;
    if([txt isEqualToString:@"添加成功"]){
        Action = [UIAlertAction actionWithTitle:@"购物车" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"SXBuyiewController"];
            [self.navigationController pushViewController:jview animated:YES];
        }];
        
        Action2 = [UIAlertAction actionWithTitle:@"继续购买" style: UIAlertActionStyleDefault handler:nil];
        [alertCtrl addAction:Action];
        
        [alertCtrl addAction:Action2];
    }else{
        Action = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:nil];
        [alertCtrl addAction:Action];
    }
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (IBAction)shop:(id)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.uid > 0){
        [[[SXNetworkTools sharedNetworkTools]GET:[NSString stringWithFormat:@"/buy/%ld/%@/%@/%@.html",(long)app.uid,app.pass,self.newsModel.listextra[_index][@"docid"],_lbltitle5.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * task,NSDictionary* responseObject) {
            
            if([responseObject[@"null"] isEqualToString:@"ok"]){
                [self alert:@"添加成功"];
            }else{
                [self alert:responseObject[@"null"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //NSLog(@"%@",error);
        }] resume];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"FLO"];
        app.reh = @"1";
        [self.navigationController pushViewController:jview animated:YES];
    }
}

- (IBAction)pay:(id)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //NSLog(@"/buy2/%ld/%@/%@/%@.html",app.uid,app.pass,self.newsModel.listextra[_index][@"docid"],_lbltitle5.text);
    if(app.uid > 0){
        [[[SXNetworkTools sharedNetworkTools]GET:[NSString stringWithFormat:@"/buy2/%ld/%@/%@/%@.html",(long)app.uid,app.pass,self.newsModel.listextra[_index][@"docid"],_lbltitle5.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * task,NSDictionary* responseObject) {
            
            if([responseObject[@"do"][0][@"null"] isEqualToString:@"ok"]){
                app.buv = 1;
                app.but = [NSString stringWithFormat:@"%@/%@.html",self.newsModel.listextra[_index][@"docid"],_lbltitle5.text];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"pay"];
                [self.navigationController pushViewController:jview animated:YES];
            }else{
                [self alert:responseObject[@"do"][0][@"null"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //NSLog(@"%@",error);
        }] resume];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"FLO"];
        app.reh = @"1";
        [self.navigationController pushViewController:jview animated:YES];
    }
}

- (IBAction)jian:(id)sender {
    int lblint = [_lbltitle5.text intValue];
    if(lblint>0){
        _lbltitle5.text = [NSString stringWithFormat:@"%d",lblint - 1];
    }
}

- (IBAction)jia:(id)sender {
    int lblint = [_lbltitle5.text intValue];
    if(lblint<kucun){
        _lbltitle5.text = [NSString stringWithFormat:@"%d",lblint + 1];
    }
}

@end
