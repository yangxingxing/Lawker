//
//  SXBuyCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXBuyCell.h"
#import "AppDelegate.h"
#import "SXNetworkTools.h"
#import "UIImageView+WebCache.h"

@interface SXBuyCell ()
{
int kucun;
}

@property (weak, nonatomic) IBOutlet UILabel *lbltitle1;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle2;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle3;
@property (weak, nonatomic) IBOutlet UITextField *lbltitle;
@property (weak, nonatomic) IBOutlet UIImageView *lblicon;
@property (weak, nonatomic) IBOutlet UIButton *jian;
@property (weak, nonatomic) IBOutlet UIButton *jia;

@end

@implementation SXBuyCell

- (void)setNewsModel:(SXBuyModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    [self.lblicon sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgsrc]placeholderImage:[UIImage imageNamed:@"302"]];
    
    _lbltitle3.text = self.NewsModel.title;
    
    _lbltitle1.text = [NSString stringWithFormat:@"单价 %@元",self.NewsModel.jiage];
    
    _lbltitle2.text = [NSString stringWithFormat:@"积分 %@",self.NewsModel.jf];
    
    _lbltitle.text = self.NewsModel.num;
    
    kucun = [self.NewsModel.replyCount intValue];
    
    [_jian addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
    _jian.tag = [self.NewsModel.docid integerValue];
    
    [_jia addTarget:self action:@selector(buttonClick3:) forControlEvents:UIControlEventTouchUpInside];
    _jia.tag = [self.NewsModel.docid integerValue];
}


//- (void)buttonClick1:(UIButton *)sender//这个sender就代表上面的button
//{
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    NSString *dev;
//    dev = [NSString stringWithFormat:@"%ld",sender.tag];
//    app.docxtag = dev;
//    
//    app.docxid = sender.titleLabel.text;
//    //[self.btnDelegate buttonClick];
//}

- (void)buttonClick2:(UIButton *)sender//这个sender就代表上面的button
{
    int lblint = [_lbltitle.text intValue];
    if(lblint>0){
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *allUrlstring = [NSString stringWithFormat:@"/e2buy/%ld/%@/%ld.html",(long)app.uid,app.pass,(long)sender.tag];
        NSLog(@"%@",allUrlstring);
        [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
            NSString *key = [responseObject.keyEnumerator nextObject];
            
            NSArray *temArray = responseObject[key];
            if([temArray[0][@"null"] isEqualToString:@"ok"]){
                
                _lbltitle.text = [NSString stringWithFormat:@"%d",lblint - 1];
                [self.btnDelegate buttonClick];
                
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //NSLog(@"%@",error);
        }] resume];
    }
}

- (void)buttonClick3:(UIButton *)sender//这个sender就代表上面的button
{    
    int lblint = [_lbltitle.text intValue];
    if(lblint<kucun){
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/ebuy/%ld/%@/%ld.html",(long)(long)app.uid,app.pass,(long)sender.tag];
    NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        if([temArray[0][@"null"] isEqualToString:@"ok"]){        
            int lblint = [_lbltitle.text intValue];
            _lbltitle.text = [NSString stringWithFormat:@"%d",lblint + 1];
            [self.btnDelegate buttonClick];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
    }
}

#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(SXBuyModel *)NewsModel
{
    return @"NewsCell";
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(SXBuyModel *)NewsModel
{
    return 200;
}

@end
