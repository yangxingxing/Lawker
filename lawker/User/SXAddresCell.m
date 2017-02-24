//
//  SXOldCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXAddresCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "SXNetworkTools.h"

@interface SXAddresCell ()

@property (weak, nonatomic) IBOutlet UILabel *t1;
@property (weak, nonatomic) IBOutlet UILabel *t2;
@property (weak, nonatomic) IBOutlet UILabel *t3;
@property (weak, nonatomic) IBOutlet UIView *mo;
@property (weak, nonatomic) IBOutlet UIButton *del;
@property (weak, nonatomic) IBOutlet UIButton *bianji;


@end

@implementation SXAddresCell

- (void)setNewsModel:(SXAddresModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    _t1.text = self.NewsModel.name;
    _t2.text = self.NewsModel.phone;
    _t3.text = self.NewsModel.addres;
    
    if(self.NewsModel.tai==1){
        _mo.hidden = NO;
    }
    [_bianji addTarget:self action:@selector(buttonClick3:) forControlEvents:UIControlEventTouchUpInside];
    _bianji.tag = self.NewsModel.aaa;
    _del.tag = self.NewsModel.aaa;
    
}

- (void)buttonClick3:(UIButton *)sender//这个sender就代表上面的button
{
    [self.btnDelegate buttonClick:(int)sender.tag];
}

#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(SXAddresModel *)NewsModel
{
   return @"addres";
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(SXAddresModel *)NewsModel
{
    return 130;
}

@end
