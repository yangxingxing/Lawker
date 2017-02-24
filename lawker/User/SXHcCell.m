//
//  SXHcCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXHcCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface SXHcCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imgico;
@property (weak, nonatomic) IBOutlet UIButton *lblboot;
@end

@implementation SXHcCell

- (void)setNewsModel:(SXHcModel *)NewsModel
{
    _NewsModel = NewsModel;
    
    _lblTitle.text = self.NewsModel.title;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"hc/%@.jpg", self.NewsModel.title]];
    [self.imgico setImage:[UIImage imageWithContentsOfFile:path]];
    
    [_lblboot addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)buttonClick1:(UIButton *)sender//这个sender就代表上面的button
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    app.tid = sender.tag;
    [self.btnDelegate buttonClick];
}

#pragma mark - /************************* 类方法返回可重用ID ***************************/
+ (NSString *)idForRow:(SXHcModel *)NewsModel
{
    return @"NewsCell";
}

#pragma mark - /************************* 类方法返回行高 ***************************/
+ (CGFloat)heightForRow:(SXHcModel *)NewsModel
{
    return 90;
}

@end
