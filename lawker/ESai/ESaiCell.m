//
//  SXErvCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "ESaiCell.h"
#import "ESaiController.h"
#import "UIImageView+WebCache.h"
#import "SXDetailController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "SXNetworkTools.h"

@interface ESaiCell ()

/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon2;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon3;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lblBTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle3;

@property (weak, nonatomic) IBOutlet UIButton *lblboot;
@property (weak, nonatomic) IBOutlet UIButton *lblboot1;
@property (weak, nonatomic) IBOutlet UIButton *lblboot2;
@property (weak, nonatomic) IBOutlet UIButton *lblboot3;
/**
 *  回复数
 */
@property (weak, nonatomic) IBOutlet UILabel *lblReply;
@property (weak, nonatomic) IBOutlet UILabel *lblReply2;
@property (weak, nonatomic) IBOutlet UILabel *lblReply3;
/**
 *  描述
 */

@property(nonatomic,assign)BOOL update;

@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
/**
 *  第二张图片（如果有的话）
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgOther1;
/**
 *  第三张图片（如果有的话）
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgOther2;

@end

@implementation ESaiCell

- (void)setNewsModel:(ESaiModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    if (NewsModel.orderextra){
        [_lblboot setTitle:self.NewsModel.orderextra[0][@"title"] forState:UIControlStateNormal];
        [_lblboot addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lblboot1 setTitle:self.NewsModel.orderextra[1][@"title"]  forState:UIControlStateNormal];
        [_lblboot2 setTitle:self.NewsModel.orderextra[2][@"title"] forState:UIControlStateNormal];
        [_lblboot2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lblboot1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.lblboot.tag = [self.NewsModel.orderextra[0][@"docid"] integerValue];
        self.lblboot1.tag = [self.NewsModel.orderextra[1][@"docid"] integerValue];
        self.lblboot2.tag = [self.NewsModel.orderextra[2][@"docid"] integerValue];
    }else if (NewsModel.titlextra){
        [_lblboot setTitle:self.NewsModel.titlextra[0][@"title"] forState:UIControlStateNormal];
        [_lblboot addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
        [_lblboot1 setTitle:self.NewsModel.titlextra[1][@"title"]  forState:UIControlStateNormal];
        [_lblboot2 setTitle:self.NewsModel.titlextra[2][@"title"] forState:UIControlStateNormal];
        [_lblboot3 setTitle:self.NewsModel.titlextra[3][@"title"] forState:UIControlStateNormal];
        [_lblboot2 addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
        [_lblboot1 addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
        [_lblboot3 addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
        self.lblboot.tag = [self.NewsModel.titlextra[0][@"docid"] integerValue];
        self.lblboot1.tag = [self.NewsModel.titlextra[1][@"docid"] integerValue];
        self.lblboot2.tag = [self.NewsModel.titlextra[2][@"docid"] integerValue];
        self.lblboot3.tag = [self.NewsModel.titlextra[3][@"docid"] integerValue];
    }else{
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.listextra[0][@"imgsrc"] ]placeholderImage:[UIImage imageNamed:@"302"]];
        
        [_lblboot3 setTitle:self.NewsModel.listextra[0][@"skipID"] forState:UIControlStateNormal];
        [_lblboot3 addTarget:self action:@selector(buttonClick3:) forControlEvents:UIControlEventTouchUpInside];
        self.lblboot3.tag = [self.NewsModel.listextra[0][@"docid"] integerValue];
        
        self.lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblTitle.numberOfLines = 0;
        
        self.lblTitle.text = self.NewsModel.listextra[0][@"title"];
        
            CGFloat count =  [self.NewsModel.listextra[0][@"replyCount"] intValue];
            NSString *displayCount;
            if (count > 10000) {
                displayCount = [NSString stringWithFormat:@"%.1f万次播放",count/10000];
            }else{
                displayCount = [NSString stringWithFormat:@"%.0f次播放",count];
            }
            self.lblTitle2.text = displayCount;
        
        self.lblTitle3.text = [NSString stringWithFormat:@"价格 %@元",self.NewsModel.listextra[0][@"jiage"]];

    }
    
}

- (void)buttonClick:(UIButton *)sender//这个sender就代表上面的button
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    app.allurl = [NSString stringWithFormat:@"/erv/%@/o%ld.html",app.docxid,sender.tag];
    
}

- (void)buttonClick2:(UIButton *)sender//这个sender就代表上面的button
{
    NSLog(@"%ld",sender.tag);
}

- (void)buttonClick3:(UIButton *)sender//这个sender就代表上面的button
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *dev;
    dev = [NSString stringWithFormat:@"%ld",sender.tag];
    app.docxtag = dev;
    
    app.docxid = sender.titleLabel.text;
}

#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(ESaiModel *)NewsModel
{
    return @"NewsCell";
    
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(ESaiModel *)NewsModel
{
    return 50;
    
}

@end
