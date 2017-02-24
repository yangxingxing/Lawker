//
//  SXJfCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXJfCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface SXJfCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbltitle1;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle2;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle3;

@end

@implementation SXJfCell

- (void)setNewsModel:(SXJfModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    _lbltitle1.text = self.NewsModel.title;
    
    _lbltitle2.text = [NSString stringWithFormat:@"积分+%@",self.NewsModel.cout];
    
    _lbltitle3.text = self.NewsModel.imgsrc;
    
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
+ (NSString *)idForRow:(SXJfModel *)NewsModel
{
    return @"NewsCell";
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(SXJfModel *)NewsModel
{
    return 90;
}

@end
