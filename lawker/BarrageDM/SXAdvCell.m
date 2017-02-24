//
//  SXAdvCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXAdvCell.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface SXAdvCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbltitle;
@property (weak, nonatomic) IBOutlet UIButton *lblniu;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle2;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle3;
//@property (weak, nonatomic) IBOutlet UIWebView *webv;
@property (weak, nonatomic) IBOutlet UIButton *lblbb;
@property (weak, nonatomic) IBOutlet UIButton *lblbb2;
@property (weak, nonatomic) IBOutlet UIImageView *lblico;
@property (weak, nonatomic) IBOutlet UIView *lblniu2;

@end

@implementation SXAdvCell

- (void)setNewsModel:(SXAdvModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    if([self.NewsModel.tai isEqualToString:@"0"]){
        _lblniu.hidden = YES;
        _lblniu2.hidden = YES;
        //_lbltitle.width = 345.0;
        //[self.btnwidth butwidth:1];
    }else{
        _lblniu.hidden = NO;
        _lblniu2.hidden = NO;
        //_lbltitle.width = 270.0;
        //[self.btnwidth butwidth:0.7];
    }
    
    [self.lblico sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.img] placeholderImage:[UIImage imageNamed:@"302"]];
    
    _lbltitle.text = self.NewsModel.title;
    
    _lbltitle2.text = self.NewsModel.data;
    
    _lbltitle3.text = self.NewsModel.info;
    
    [_lblbb addTarget:self action:@selector(buttonClick3:) forControlEvents:UIControlEventTouchUpInside];
    self.lblbb.tag = [self.NewsModel.info integerValue];
    
    [_lblbb2 addTarget:self action:@selector(buttonClick2:) forControlEvents:UIControlEventTouchUpInside];
    self.lblbb2.tag = [self.NewsModel.info integerValue];
}


- (void)buttonClick3:(UIButton*)sender {
    [self.btnDelegate buttonClick:sender.tag];
}

- (void)buttonClick2:(UIButton*)sender {
    [self.btnDelegate buttonClick:sender.tag];
}

@end
