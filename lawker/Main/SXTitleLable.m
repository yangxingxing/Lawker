//
//  SXTitleLable.m
//  85 - 网易滑动分页
//
//  Created by 董 尚先 on 15-1-31.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXTitleLable.h"

@implementation SXTitleLable

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:18];
        
        self.scale = 0.0;
        
    }
    return self;
}

/** 通过scale的改变改变多种参数 */
- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    if(scale==0){
        self.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0 alpha:1];
    }else{
        self.textColor = [UIColor colorWithRed:28/255.0 green:77/255.0 blue:153/255.0 alpha:1.0];
    }
    //CGFloat minScale = 0.8;
    //CGFloat trueScale = minScale + (1-minScale)*scale;
    //self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

@end
