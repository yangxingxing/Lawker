//
//  BarrageView.h
//  BarrageTest
//
//  Created by victor on 9/8/15.
//  Copyright © 2015 vcitor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarrageView : UIView

@property (nonatomic, strong) NSMutableArray *commentArray;

//开启弹幕
-(void)openBarrage;


//自己评论内容，颜色彩色
-(void)addMyComment:(NSString *)comment;
@end
