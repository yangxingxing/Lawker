//
//  SXShovCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights resShoved.
//

#import "SXShovCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
//#import "SXNetworkTools.h"

@interface SXShovCell ()

/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet UIImageView *img1;

@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *img5;
@property (weak, nonatomic) IBOutlet UIImageView *img6;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle3;

@property (weak, nonatomic) IBOutlet UIButton *lblboot;
@property (weak, nonatomic) IBOutlet UIButton *lblboot1;
@property (weak, nonatomic) IBOutlet UIButton *lblboot2;
@property (weak, nonatomic) IBOutlet UIButton *lblboot3;
@property (weak, nonatomic) IBOutlet UILabel *lblboot4;

/**
 *  描述
 */

@property(nonatomic,assign)BOOL update;

@end

@implementation SXShovCell

- (void)setNewsModel:(SXShovModel *)NewsModel
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
        
    }else{
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.listextra[0][@"imgsrc"] ]placeholderImage:[UIImage imageNamed:@"302"]];
        
        [_lblboot3 setTitle:self.NewsModel.listextra[0][@"skipID"] forState:UIControlStateNormal];
        [_lblboot3 addTarget:self action:@selector(buttonClick3:) forControlEvents:UIControlEventTouchUpInside];
        self.lblboot3.tag = [self.NewsModel.listextra[0][@"docid"] integerValue];
        
        self.lblTitle.text = self.NewsModel.listextra[0][@"title"];
        
            CGFloat count =  [self.NewsModel.listextra[0][@"replyCount"] intValue];
            NSString *displayCount;
            if (count > 10000) {
                displayCount = [NSString stringWithFormat:@"库存 %.1f万",count/10000];
            }else{
                displayCount = [NSString stringWithFormat:@"库存 %.0f",count];
            }
            self.lblTitle2.text = displayCount;
        
        self.lblTitle3.text = [NSString stringWithFormat:@"价格 %@元",self.NewsModel.listextra[0][@"jiage"]];
        
        self.lblboot4.text = [NSString stringWithFormat:@"积分 %@",self.NewsModel.listextra[0][@"jf"]];
        
    }
    
}

- (void)buttonClick2:(UIButton *)sender//这个sender就代表上面的button
{
    
}

- (void)buttonClick3:(UIButton *)sender//这个sender就代表上面的button
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *dev;
    dev = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    app.docxtag = dev;
    
    app.docxid = sender.titleLabel.text;
}

#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(SXShovModel *)NewsModel
{
    
    if (NewsModel.orderextra){
        return @"NewsOrder";
    }else if (NewsModel.titlextra){
        return @"NewsSelect";
    }else{
        return @"NewsCell";
    }
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(SXShovModel *)NewsModel
{
    if (NewsModel.orderextra || NewsModel.titlextra){
        return 50;
    }else{
        return 200;
    }
}
- (void)buttonClick:(UIButton *)sender//这个sender就代表上面的button
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //SXShovCell2 *load2 =[[SXShovCell2 alloc]init];
    long sender2 = sender.tag;
    self.img1.hidden = NO;
    self.img2.hidden = NO;
    self.img3.hidden = NO;
    self.img4.hidden = NO;
    self.img5.hidden = NO;
    self.img6.hidden = NO;
    
    if(sender.tag==1){
        self.img1.hidden = YES;
    }else if(sender.tag==11){
        self.img2.hidden = YES;
    }else if(sender.tag==2){
        self.img3.hidden = YES;
    }else if(sender.tag==22){
        self.img4.hidden = YES;
    }else if(sender.tag==3){
        self.img5.hidden = YES;
    }else if(sender.tag==33){
        self.img6.hidden = YES;
    }
    
    app.docimg = sender.tag;

    [self.btnDelegate buttonClick:sender2];
        
}

@end
