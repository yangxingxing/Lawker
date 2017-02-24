//
//  SXMsmCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXMsmCell.h"
#import "AppDelegate.h"

@interface SXMsmCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;

@end

@implementation SXMsmCell

- (void)setNewsModel:(SXMsmModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    //NSLog(@"%@",self.NewsModel.title);
    
    _lblTitle.text = self.NewsModel.title;
    if([self.NewsModel.tai isEqualToString:@"new"]){
        _lblTitle1.text = self.NewsModel.tai;
    }else{
        _lblTitle1.text = @"";
    }
    _lblTitle2.text = self.NewsModel.info;
    
}

- (void)buttonClick1:(UIButton *)sender//这个sender就代表上面的button
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *dev;
    dev = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    app.docxtag = dev;
    
    app.docxid = sender.titleLabel.text;
    //[self.btnDelegate buttonClick];
}

#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(SXMsmModel *)NewsModel
{
    return @"NewsCell";
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(SXMsmModel *)NewsModel
{
    return 100;
}

@end
