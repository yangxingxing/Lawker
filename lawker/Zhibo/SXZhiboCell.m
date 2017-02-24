//
//  SXZhiboCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXZhiboCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface SXZhiboCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;

@property (weak, nonatomic) IBOutlet UIButton *lblboot3;

@property (weak, nonatomic) IBOutlet UIButton *lblboot;

@end

@implementation SXZhiboCell

- (void)setNewsModel:(SXZhiboModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    //NSLog(@"%@",self.NewsModel.title);
    
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgsrc] placeholderImage:[UIImage imageNamed:@"302"]];
    
    _lblTitle.text = self.NewsModel.title;
    _lblTitle1.text = [NSString stringWithFormat:@"价格 %@元",self.NewsModel.jiage];
    _lblTitle2.text = [NSString stringWithFormat:@"时间 %@",self.NewsModel.times];
    [_lblboot3 setTitle:self.NewsModel.skipID forState:UIControlStateNormal];
    [_lblboot3 addTarget:self action:@selector(buttonClick3:) forControlEvents:UIControlEventTouchUpInside];
    self.lblboot3.tag = [self.NewsModel.docid integerValue];
    
    [_lblboot setTitle:self.NewsModel.skipID forState:UIControlStateNormal];
    [_lblboot addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    self.lblboot.tag = [self.NewsModel.docid integerValue];
    
}


- (void)buttonClick3:(UIButton *)sender//这个sender就代表上面的button
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *dev;
    dev = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    app.docxtag = dev;
    
    app.docxid = sender.titleLabel.text;
    [self.btnDelegate buttonClick];
}

- (void)buttonClick1:(UIButton *)sender//这个sender就代表上面的button
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.navcid = sender.tag;
    app.ztitle = sender.titleLabel.text;
}

#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(SXZhiboModel *)NewsModel
{
    if (NewsModel.nexSian){
        return @"NewsXian";
    }else if (NewsModel.moreTitle){
        return @"NewsMore";
    }else if (NewsModel.titleType){
        return @"NewsTitle";
    }else{
        return @"NewsCell";
    }
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(SXZhiboModel *)NewsModel
{
    if (NewsModel.nexSian){
        return 20;
    }else if (NewsModel.titleType||NewsModel.moreTitle){
        return 40;
    }else{
        return 90;
    }
}

@end
