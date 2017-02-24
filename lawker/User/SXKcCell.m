//
//  SXKcCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXKcCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface SXKcCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIButton *lblboot3;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle3;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;

@end

@implementation SXKcCell

- (void)setNewsModel:(SXKcModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgsrc] placeholderImage:[UIImage imageNamed:@"302"]];
    
    if(self.NewsModel.date){
        _lblTitle2.text = [NSString stringWithFormat:@"时间 %@",self.NewsModel.date];
    }else{
        CGFloat count =  self.NewsModel.cout;
        NSString *displayCount;
        if (count > 10000) {
            displayCount = [NSString stringWithFormat:@"%.1f万次播放",count/10000];
        }else{
            displayCount = [NSString stringWithFormat:@"%.0f次播放",count];
        }
        _lblTitle2.text = displayCount;
    }
    
    _lblTitle3.text = [NSString stringWithFormat:@"价格 %@元",self.NewsModel.jiage];
    
    _lblTitle.text = self.NewsModel.title;
    [_lblboot3 setTitle:self.NewsModel.skipID forState:UIControlStateNormal];
    [_lblboot3 addTarget:self action:@selector(buttonClick3:) forControlEvents:UIControlEventTouchUpInside];
    _lblboot3.tag = [self.NewsModel.docid integerValue];
    
}

- (void)buttonClick3:(UIButton *)sender//这个sender就代表上面的button
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //NSLog(@"%ld",sender.tag);
    NSString *dev;
    dev = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    app.docxtag = dev;
    
    app.docxid = sender.titleLabel.text;
    
    [self.btnDelegate buttonClick];
}

#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(SXKcModel *)NewsModel
{
    if(NewsModel.date){
        return @"Zb";
    }else{
        return @"Kc";
    }
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(SXKcModel *)NewsModel
{
    if(NewsModel.date){
        return 90;
    }else{
        return 200;
    }
}

@end
