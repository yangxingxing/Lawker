//
//  SXSsCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXSsCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface SXSsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIButton *lblboot3;

@end

@implementation SXSsCell

- (void)setNewsModel:(SXSsModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgsrc] placeholderImage:[UIImage imageNamed:@"302"]];
    
    _lblTitle.text = self.NewsModel.title;
    [_lblboot3 setTitle:self.NewsModel.skipID forState:UIControlStateNormal];
    [_lblboot3 addTarget:self action:@selector(buttonClick3:) forControlEvents:UIControlEventTouchUpInside];
    self.lblboot3.tag = [self.NewsModel.docid integerValue];
    
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
+ (NSString *)idForRow:(SXSsModel *)NewsModel
{
    return @"NewsCell";

}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(SXSsModel *)NewsModel
{
    return 90;
}

@end
