//
//  SXPayCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXPayCell.h"
#import "UIImageView+WebCache.h"

@interface SXPayCell ()

@property (weak, nonatomic) IBOutlet UILabel *lbltitle1;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle2;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle3;
@property (weak, nonatomic) IBOutlet UIImageView *lblicon;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle4;

@end

@implementation SXPayCell

- (void)setNewsModel:(SXPayModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    [self.lblicon sd_setImageWithURL:[NSURL URLWithString:self.NewsModel.imgsrc]placeholderImage:[UIImage imageNamed:@"302"]];
    
    _lbltitle3.text = self.NewsModel.title;
    
    _lbltitle1.text = [NSString stringWithFormat:@"价格 %@元",self.NewsModel.jg];
    if(self.NewsModel.jf2.length > 0){
        _lbltitle2.text = [NSString stringWithFormat:@"积分 %@",self.NewsModel.jf2];
        _lbltitle2.hidden = NO;
    }else{
        _lbltitle2.hidden = YES;
    }
    _lbltitle4.text = [NSString stringWithFormat:@"数量 %@",self.NewsModel.num];
}


#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(SXPayModel *)NewsModel
{
    return @"NewsCell";
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(SXPayModel *)NewsModel
{
    return 200;
}

@end