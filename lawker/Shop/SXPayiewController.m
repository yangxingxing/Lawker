//
//  SXPayiewController.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//


#import "SXPayiewController.h"
#import "SXPayCell.h"
#import "SXNetworkTools.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WTPayManager.h"

@interface SXPayiewController ()<UITableViewDataSource,UITableViewDelegate,WXApiDelegate>
{
    int payint;
    int payaddres;
    float payjf;
    float payjg;
}

@property(nonatomic,strong) NSMutableArray *arrayList;

@property(nonatomic,assign)BOOL update;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *label_jg;
@property (weak, nonatomic) IBOutlet UILabel *label_jf;
@property (weak, nonatomic) IBOutlet UILabel *label_yf;
@property (weak, nonatomic) IBOutlet UIButton *zf_1;
@property (weak, nonatomic) IBOutlet UIButton *zf_2;
@property (weak, nonatomic) IBOutlet UIButton *zf_3;
@property (weak, nonatomic) IBOutlet UILabel *lbbel_jg2;
@property (weak, nonatomic) IBOutlet UILabel *lbbel_jf2;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UILabel *label_phone;
@property (weak, nonatomic) IBOutlet UILabel *label_addres;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *title4;
@property (weak, nonatomic) IBOutlet UILabel *title5;
@property (weak, nonatomic) IBOutlet UILabel *sp;
@property (weak, nonatomic) IBOutlet UILabel *sp2;
@property (weak, nonatomic) IBOutlet UILabel *zf;
@property (weak, nonatomic) IBOutlet UILabel *zf2;
@property (weak, nonatomic) IBOutlet UIView *payok;
@property (weak, nonatomic) IBOutlet UIView *addresv;
@property (weak, nonatomic) IBOutlet UITableView *tablev;
@property (weak, nonatomic) IBOutlet UIView *payv;
@property (weak, nonatomic) IBOutlet UIView *xianv;
@property (weak, nonatomic) IBOutlet UIView *yunfei;

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@end

@implementation SXPayiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadData2)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    
    payint = 1;
    
    _zf_1.layer.borderWidth = 1;
    _zf_1.layer.borderColor = [[UIColor colorWithRed:255.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1.0] CGColor];
    
    _zf_2.layer.borderWidth = 1;
    _zf_2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _zf_3.layer.borderWidth = 1;
    _zf_3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.navigationItem.title = @"确认支付";
    
    self.update = YES;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.buv == 2 || app.buv == 3){
        _addresv.hidden = YES;
        _zf_3.hidden = YES;
        //_tablev.frame = CGRectMake(0, 0, ScreenWidth, 200);
        //_payv.frame = CGRectMake(0, 210, ScreenWidth, 80);
        _yunfei.hidden = YES;
        //_xianv.frame = CGRectMake(0, 200, ScreenWidth, 10);
        NSLayoutConstraint *toptablev = [NSLayoutConstraint constraintWithItem:_tablev attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        
        //NSLayoutConstraint *topxianv = [NSLayoutConstraint constraintWithItem:_xianv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:200];
        //[self.view addConstraint:topxianv];
        
        NSLayoutConstraint *toppayv = [NSLayoutConstraint constraintWithItem:_payv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_xianv attribute:NSLayoutAttributeTop multiplier:1.0 constant:10];
        [self.view addConstraint:toppayv];
        
        [self.view addConstraint:toptablev];
    }
    
    [self pays];
}

- (void)pays{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *allUrlstring = [NSString stringWithFormat:@"/pay3/%ld/%@/%@",(long)app.uid,app.pass,app.but];
    if(app.buv == 2){
        allUrlstring = [NSString stringWithFormat:@"/pay4/%ld/%@/%@",(long)app.uid,app.pass,app.but];
    }
    if(app.buv == 3){
        allUrlstring = [NSString stringWithFormat:@"/pay5/%ld/%@/%@",(long)app.uid,app.pass,app.but];
        //_addresv.hidden = YES;
        //_zf_3.hidden = YES;
        //_tablev.frame = CGRectMake(0, 0, ScreenWidth, 200);
        //_payv.frame = CGRectMake(0, 210, ScreenWidth, 80);
        //_yunfei.hidden = YES;
        //_xianv.frame = CGRectMake(0, 200, ScreenWidth, 10);
    }
    if(app.buv == 0){
        allUrlstring = [NSString stringWithFormat:@"/pay2/%ld/%@.html",(long)app.uid,app.pass];
    }
    
    NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        if([temArray[1][@"null"] isEqualToString:@"ok"]){
            _label_jf.text = [NSString stringWithFormat:@"%.2f",[temArray[0][@"jf"] floatValue] + [temArray[1][@"yf"] floatValue] ];
            _label_jg.text = [NSString stringWithFormat:@"%.2f",[temArray[0][@"jg"] floatValue] + [temArray[1][@"yf"] floatValue] ];
            _label_yf.text = temArray[1][@"yf"];
            _label_title.text = temArray[1][@"name"];
            _label_phone.text = temArray[1][@"phone"];
            _label_addres.text = temArray[1][@"addres"];
            payaddres = [temArray[1][@"aaa"] intValue];
            payjf = [temArray[0][@"jf"] floatValue] + [temArray[1][@"yf"] floatValue];
            payjg = [temArray[0][@"jg"] floatValue] + [temArray[1][@"yf"] floatValue];
            //self.tabBarController.tabBar.hidden = YES;
        }else{
            _label_jf.text = [NSString stringWithFormat:@"%.2f",[temArray[0][@"jf"] floatValue]];
            _label_jg.text = [NSString stringWithFormat:@"%.2f",[temArray[0][@"jg"] floatValue]];
            _label_yf.text = @"0";
            _label_title.text = @"需要先设置地址,才能购买";
            _label_phone.text = @"";
            _label_addres.text = @"";
            payaddres = 0;
            payjf = [temArray[0][@"jf"] floatValue];
            payjg = [temArray[0][@"jg"] floatValue];
            [self alert:@"需要先设置地址,才能购买"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
}

- (IBAction)xaddres:(id)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.addres = 1;
}

- (IBAction)jg:(id)sender {
    _label_jg.hidden = NO;
    _label_jf.hidden = YES;
    _lbbel_jg2.hidden = NO;
    _lbbel_jf2.hidden = YES;
    payint = 1;
    _zf_1.layer.borderWidth = 1;
    [_zf_1 setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    _zf_1.layer.borderColor = [[UIColor colorWithRed:255.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1.0] CGColor];
    
    _zf_2.layer.borderWidth = 1;
    [_zf_2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _zf_2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _zf_3.layer.borderWidth = 1;
    [_zf_3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _zf_3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (IBAction)jg2:(id)sender {
    _label_jg.hidden = NO;
    _label_jf.hidden = YES;
    _lbbel_jg2.hidden = NO;
    _lbbel_jf2.hidden = YES;
    payint = 2;
    _zf_1.layer.borderWidth = 1;
    [_zf_1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _zf_1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _zf_2.layer.borderWidth = 1;
    [_zf_2 setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    _zf_2.layer.borderColor = [[UIColor colorWithRed:255.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1.0] CGColor];
    
    _zf_3.layer.borderWidth = 1;
    [_zf_3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _zf_3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (IBAction)jf:(id)sender {
    _label_jg.hidden = YES;
    _label_jf.hidden = NO;
    _lbbel_jg2.hidden = YES;
    _lbbel_jf2.hidden = NO;
    payint = 3;
    _zf_1.layer.borderWidth = 1;
    [_zf_1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _zf_1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _zf_2.layer.borderWidth = 1;
    [_zf_2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _zf_2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _zf_3.layer.borderWidth = 1;
    [_zf_3 setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    _zf_3.layer.borderColor = [[UIColor colorWithRed:255.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1.0] CGColor];
}

- (void)loadData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/buy3/%ld/%@/%@",(long)app.uid,app.pass,app.but];
    if(app.buv == 2){
        allUrlstring = [NSString stringWithFormat:@"/buy4/%ld/%@/%@",(long)app.uid,app.pass,app.but];
    }
    if(app.buv == 3){
        allUrlstring = [NSString stringWithFormat:@"/buy5/%ld/%@/%@",(long)app.uid,app.pass,app.but];
    }
    if(app.buv == 0){
        allUrlstring = [NSString stringWithFormat:@"/pay/%ld/%@.html",(long)app.uid,app.pass];
    }
    NSLog(@"%@",allUrlstring);
    [self loadDataForType:1 withURL:allUrlstring];
}

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        //[self.tableView headerBeginRefreshing];        
        NSMutableArray *arrayM = [SXPayModel objectArrayWithKeyValuesArray:temArray];
        
        self.arrayList = arrayM;
        [self.tableView headerEndRefreshing];
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}

- (IBAction)pay:(id)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
     NSString *allUrlstring = [NSString stringWithFormat:@"/payo/%ld/%@/%d/%.2f/%.2f/%d/%@",(long)app.uid,app.pass,payaddres,payjg,payjf,payint,app.but];
    if(app.buv!=0){
        allUrlstring = [NSString stringWithFormat:@"/payo/%ld/%@/%ld/%.2f/%.2f/%d/%@",(long)app.uid,app.pass,(long)app.buv,payjg,payjf,payint,app.but];
    }
    NSLog(@"%@",allUrlstring);
    
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        if([responseObject[@"null"] isEqualToString:@"ok"]){
            if(payint==1){
                WTPayOrderItem * item = [[WTPayOrderItem alloc]init];
                item.orderName = [NSString stringWithFormat:@"%@",responseObject[@"onum"]];
                item.orderPrice = [NSString stringWithFormat:@"%f",payjg*100];//一分钱
                item.orderOutTradeNO = responseObject[@"onum"];
                item.orderBody = responseObject[@"onum"];
                [WTPayManager wtPayOrderItem:item payType:WTPayTypeWeixin result:^(NSDictionary *payResult, NSString *error) {
                    
                    if (payResult) {
                        NSLog(@"%@", payResult[@"result"]);
                    }else{
                        NSLog(@"%@", error);
                    }
                }];
            }
            if(payint==2){
                NSString *appID = @"2016122704656072";
                NSString *privateKey = @"MIICXQIBAAKBgQDKg44WCK89QZm01kl6MFT8LoQcxYWHkA3Q5WJWy5bkpAkWMjOk1x9+Avt4eJp94h/2vR2SLNQ3KvAdf5OHghjsfM8+K916mQ9ePrXW+1SdkfqdBjHmpHk+TGmOd3cAo1VlIDlS7OUnGToffaP+5vUB/vQRzgCvBrglRqRxEqpYBQIDAQABAoGBAJFwt6uVYx1QLq6UM0MA0Rgn5BOxu7tnNrTu+JgzMNRWBnydYz+gi+p5A9c6bmG385LFsSYY8fQI71eQFwj74x80A4SDRtc/rSUcBSMQjSPtrjJP9r60zNTE/IgG1ffmz5CMRtQs7qGrmduxMm2kTaMLu6U8hxOKCoz+YZkylrmFAkEA+UUj+Kdl0947NcyQYuiNzMkPoBx1ZTjNOuRsTOvK6W9BKeklYlXJDMHj9QqCTxJ28YYByh5kapzYutYqKNySLwJBAM/7QOqWSisJPhfcootYc4HYtJYWqv75ubVAEt6b8oAqlAHvNT0i2XnV1kvRRUCbvFQKmqqnkMtym0V4WmUc8AsCQHvOypILWvlDjPcotqJZzWxkhP1KhUiUUOMqZ1xBVVRibORLJ8VSxHwwpW+lG5n4mtlVbPgd5lRJuR/7lY8cFwMCQQCnEmjViaFO7P/KX1zbn1Q6jICUyOTYKnd6GFyQIqotNwbqfuQ/lk0pSBP7l8KP4grpYBNa33y7UfdVWRcUfqh9AkBTnFvjfGsO4T9WOC89Ee9xS+xNU55OHRCW0a0TvGOirZ0z+BMdVW5yvzgxtRKHJXjywJWyG+RI5nucdGzUS2fH";
                
                /*
                 *生成订单信息及签名
                 */
                //将商品信息赋予AlixPayOrder的成员变量
                Order* order = [Order new];
                
                // NOTE: app_id设置
                order.app_id = appID;
                
                // NOTE: 支付接口名称
                order.method = @"alipay.trade.app.pay";
                
                // NOTE: 参数编码格式
                order.charset = @"utf-8";
                
                // NOTE: 当前时间点
                NSDateFormatter* formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                order.timestamp = [formatter stringFromDate:[NSDate date]];
                
                // NOTE: 支付版本
                order.version = @"1.0";
                
                // NOTE: sign_type设置
                order.sign_type = @"RSA";
                order.notify_url = @"http://lawker.cn/alipay.html";
                
                // NOTE: 商品数据
                order.biz_content = [BizContent new];
                order.biz_content.body = responseObject[@"onum"];
                order.biz_content.subject = @"1";
                order.biz_content.out_trade_no = responseObject[@"onum"]; //订单ID（由商家自行制定）
                order.biz_content.timeout_express = @"30m"; //超时时间设置
                order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", payjg]; //商品价格
                
                //将商品信息拼接成字符串
                NSString *orderInfo = [order orderInfoEncoded:NO];
                NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
                NSLog(@"%@",orderInfo);
                
                // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
                //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
                id<DataSigner> signer = CreateRSADataSigner(privateKey);
                NSString *signedString = [signer signString:orderInfo];
                
                NSLog(@"%@",signedString);
                
                // NOTE: 如果加签成功，则继续执行支付
                if (signedString != nil) {
                    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
                    NSString *appScheme = @"alisdkdemo";
                    
                    // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
                    NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                             orderInfoEncoded, signedString];
                    
                    // NOTE: 调用支付结果开始支付
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        if([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
                            
                            NSString *allUrlstring2 = [NSString stringWithFormat:@"/payov/%ld/%@/%@",(long)app.uid,app.pass,resultDic[@"result"][@"alipay_trade_app_pay_response"][@"out_trade_no"]];
                            [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring2 parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject2) {
                                if([responseObject2[@"null"] isEqualToString:@"ok"]){
                                    _payok.hidden = NO;
                                    _title1.text = responseObject[@"title"];
                                    _title2.text = responseObject[@"info"];
                                    _title3.text = responseObject[@"dtime"];
                                    _title4.text = responseObject[@"zongjia"];
                                    _title5.text = responseObject[@"zhifu"];
                                    
                                    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:nil];
                                    
                                    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                                        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                                    }
                                }else{
                                    [self alert:responseObject[@"null"]];
                                }
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                //NSLog(@"%@",error);
                            }] resume];
                            
                        }else if([resultDic[@"resultStatus"] isEqualToString:@"6001"]){
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                    }];
                }
            }
            if(payint==3){
                if([responseObject[@"info"] isEqualToString:@"积分"]){
                    _sp2.hidden = NO;
                    _sp.hidden = YES;
                    _zf2.hidden = NO;
                    _zf.hidden = YES;
                }else{
                    _sp2.hidden = YES;
                    _sp.hidden = NO;
                    _zf2.hidden = YES;
                    _zf.hidden = NO;
                }
                _payok.hidden = NO;
                _title1.text = responseObject[@"title"];
                _title2.text = responseObject[@"info"];
                _title3.text = responseObject[@"dtime"];
                _title4.text = responseObject[@"zongjia"];
                _title5.text = responseObject[@"zhifu"];
                
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:nil];
                
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                }
            }
        }else{
            [self alert:responseObject[@"null"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}

- (IBAction)wan:(id)sender {
    _payok.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alert:(NSString *)txt{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"lawker提示" message:txt preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([txt isEqualToString:@"需要先设置地址,才能购买"]){
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            app.addres = 1;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"addres"];
            [self.navigationController pushViewController:jview animated:YES];
        }
    }];
    UIAlertAction *Action2 = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];

    [alertCtrl addAction:Action];
    
    if([txt isEqualToString:@"需要先设置地址,才能购买"]){
        [alertCtrl addAction:Action2];
    }
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)welcome
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"update"];
    [self.tableView headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self pays];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"update"]) {
        return;
    }
        //NSLog(@"bbbb");
    if (self.update == YES) {
        [self.tableView headerBeginRefreshing];
        self.update = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXPayModel *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SXPayCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"NewsCell";
    }
    SXPayCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    return cell;
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXPayModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [SXPayCell heightForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        rowHeight = 200;
    }
    
    return rowHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor yellowColor];
}

@end
