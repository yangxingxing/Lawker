//
//  SXNewsCell.m
//  lawker
//
//  Created by 董 尚先 on 15-1-22.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import "SXNewsCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface SXNewsCell ()


@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon2;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon3;

@property (weak, nonatomic) IBOutlet UILabel *lblBTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle3;

@property (weak, nonatomic) IBOutlet UIButton *lblboot;
@property (weak, nonatomic) IBOutlet UIButton *lblboot1;
@property (weak, nonatomic) IBOutlet UIButton *lblboot2;

@property (weak, nonatomic) IBOutlet UILabel *lblReply;
@property (weak, nonatomic) IBOutlet UILabel *lblReply2;
@property (weak, nonatomic) IBOutlet UILabel *lblReply3;

@end

@implementation SXNewsCell

//- (void)awakeFromNib {
    //Initialization code
//}

- (void)setNewsModel:(SXNewsModel *)NewsModel
{
    _NewsModel = NewsModel;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgsrc] placeholderImage:[UIImage imageNamed:@"302"]];
    
    [self.imgIcon2 sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgextra[0][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"302"]];
    
    [self.imgIcon3 sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgextra[1][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"302"]];
    
    self.lblTitle.text = self.NewsModel.title;
    self.lblTitle2.text = self.NewsModel.txtextra[0][@"title"];
    self.lblTitle3.text = self.NewsModel.txtextra[1][@"title"];
    //self.lblSubtitle.text = self.NewsModel.digest;    
    [_lblboot setTitle:self.NewsModel.skipID forState:UIControlStateNormal];
    [_lblboot addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_lblboot1 setTitle:self.NewsModel.skipID  forState:UIControlStateNormal];
    [_lblboot2 setTitle:self.NewsModel.skipID forState:UIControlStateNormal];
    [_lblboot2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_lblboot1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.lblboot.tag = [self.NewsModel.docid integerValue];
    self.lblboot1.tag = [self.NewsModel.docidextra[0][@"docid"] integerValue];
    self.lblboot2.tag = [self.NewsModel.docidextra[1][@"docid"] integerValue];
    self.lblBTitle.text = self.NewsModel.moreTitle;
    
    // 如果回复太多就改成几点几万
    if(NewsModel.replyCount){
    CGFloat count =  [self.NewsModel.replyCount intValue];
    NSString *displayCount;
    if (count > 10000) {
        displayCount = [NSString stringWithFormat:@"%.1f万次播放",count/10000];
    }else{
        displayCount = [NSString stringWithFormat:@"%.0f次播放",count];
    }
    self.lblReply.text = displayCount;
    
    CGFloat count2 =  [self.NewsModel.replyCountextra[0][@"Count"] intValue];
    NSString *displayCount2;
    if (count2 > 10000) {
        displayCount2 = [NSString stringWithFormat:@"%.1f万次播放",count2/10000];
    }else{
        displayCount2 = [NSString stringWithFormat:@"%.0f次播放",count2];
    }
    self.lblReply2.text = displayCount2;
    
    CGFloat count3 =  [self.NewsModel.replyCountextra[1][@"Count"] intValue];
    NSString *displayCount3;
    if (count3 > 10000) {
        displayCount3 = [NSString stringWithFormat:@"%.1f万次播放",count3/10000];
    }else{
        displayCount3 = [NSString stringWithFormat:@"%.0f次播放",count3];
    }
    self.lblReply3.text = displayCount3;
}
    
}

- (void)buttonClick:(UIButton *)sender//这个sender就代表上面的button
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *dev;
    dev = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    app.docxtag = dev;
    
    app.docxid = sender.titleLabel.text;
}

#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(SXNewsModel *)NewsModel
{
    if (NewsModel.hasHead){
        return @"BigImageCell";//TopImageCell
    }else if (NewsModel.moreTitle){
        return @"TableCell";
    }else if (NewsModel.titleType){
        return @"TitleCell";
    }else if (NewsModel.nexSian){
        return @"NewsXian";
    }else if (NewsModel.imgType){
        return @"BigImageCell";
    }else if (NewsModel.imgCount){
        return @"NewsCell3";
    }else if (NewsModel.replyCount){        
        return @"NewsCell";
    }else{
        return @"NewsCell2";
    }
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(SXNewsModel *)NewsModel
{
    if (NewsModel.hasHead){
        return 215;//245;
    }else if(NewsModel.imgType) {
        return 215;
    }else if (NewsModel.moreTitle ){
        return 30;
    }else if (NewsModel.titleType){
        return 60;
    }else if (NewsModel.nexSian){
        return 20;
    }else if (NewsModel.imgCount) {
        return 163;
    }else if (NewsModel.replyCount) {
        return 115;
    }else{
        return 100;
    }
}

@end
