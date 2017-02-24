//
//  SXOreCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXOreCell.h"
#import "AppDelegate.h"
#import "SXNetworkTools.h"

@interface SXOreCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle3;

@property (weak, nonatomic) IBOutlet UIButton *lblboot;

//#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
//#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@end

@implementation SXOreCell

- (void)setNewsModel:(SXOreModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    //NSLog(@"%@",self.NewsModel.title);
    
    _lblTitle.text = [NSString stringWithFormat:@"订单号 %@",self.NewsModel.onum];
    _lblTitle1.text = self.NewsModel.tai;
    _lblTitle2.text = self.NewsModel.title;
    _lblTitle3.text = [NSString stringWithFormat:@"¥ %@",self.NewsModel.jiage];
    
    if(![self.NewsModel.tai isEqualToString:@"未支付"]){
        _lblboot.hidden = YES;
        
        //self.lblTitle3.frame = CGRectMake1(252, 83, 100, 21);
        
    }else{
        _lblboot.hidden = NO;
        //self.lblTitle3.frame = CGRectMake1(182, 83, 100, 21);
        [_lblboot setImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
    }
    
    if([self.NewsModel.tai isEqualToString:@"等待收货"]){
        _lblboot.hidden = NO;
        //self.lblTitle3.frame = CGRectMake1(182, 83, 100, 21);
        [_lblboot setImage:[UIImage imageNamed:@"pay2"] forState:UIControlStateNormal];
    }
    
    [_lblboot setTitle:self.NewsModel.skipID forState:UIControlStateNormal];
    [_lblboot addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    self.lblboot.tag = [self.NewsModel.docid integerValue];
    
}

//CG_INLINE CGRect
//CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height){
//    CGRect rect;
//    if(ScreenWidth>375){
//        rect.origin.x = x/375*414;
//        rect.origin.y = y ;
//        rect.size.width = width ;
//        rect.size.height = height;
//        NSLog(@"%f",rect.origin.x);
//    }
//    else{
//        rect.origin.x = x;
//        rect.origin.y = y ;
//        rect.size.width = width ;
//        rect.size.height = height;
//    }
//    return rect;
//}

- (void)buttonClick1:(UIButton *)sender//这个sender就代表上面的button
{
    if([sender.titleLabel.text isEqualToString:@"order"]){AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *dev;
    dev = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    app.docxtag = dev;
    
    app.docxid = sender.titleLabel.text;
    //[self.btnDelegate buttonClick];
    }else{
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *allUrlstring = [NSString stringWithFormat:@"/shore/%ld/%@/%ld.html",(long)app.uid,app.pass,(long)sender.tag];
        //NSLog(@"%@",allUrlstring);
        [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
            NSString *key = [responseObject.keyEnumerator nextObject];
            
            NSArray *temArray = responseObject[key];
            
            if([temArray[0][@"null"] isEqualToString:@"ok"]){
                _lblboot.hidden = YES;
                //self.lblTitle3.frame = CGRectMake1(252, 83, 100, 21);
                _lblTitle1.text = @"完成";
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //NSLog(@"%@",error);
        }] resume];
    }
}

#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(SXOreModel *)NewsModel
{
    if (NewsModel.nexSian){
        return @"NewsXian";
    }else{
        return @"NewsCell";
    }
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(SXOreModel *)NewsModel
{
    if (NewsModel.nexSian){
        return 20;
    }else{
        return 115;
    }
}

@end
