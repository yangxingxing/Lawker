//
//  AppDelegate.h
//  lawker
//
//  Created by 董 尚先 on 15-1-22.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) NSString *docxid;
@property (strong,nonatomic) NSString *docxtag;
@property (strong,nonatomic) NSString *allurl;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *ztitle;
@property (nonatomic,assign) NSInteger navid;
@property (nonatomic,assign) NSInteger navid2;
@property (nonatomic,assign) NSInteger navid3;
@property (strong,nonatomic) NSString *docxtitle;
@property (nonatomic,assign) NSInteger docimg;
@property (nonatomic,assign) NSInteger docre;
@property (strong,nonatomic) NSString *pass;
@property (nonatomic,assign) NSInteger uid;
@property (nonatomic,assign) NSInteger d3;
@property (nonatomic,assign) NSInteger tid;
@property (nonatomic,assign) NSInteger addid;
@property (nonatomic,assign) NSInteger addres;
@property (nonatomic,assign) NSInteger buv;
@property (nonatomic,assign) NSInteger wan;
@property (strong,nonatomic) NSString *but;

@property (nonatomic,assign) NSString *reh;

@property (nonatomic,assign) NSString *docurl;

@property (nonatomic,assign) NSInteger navcid;

@property (nonatomic,assign) NSInteger newsx;

/***  是否允许横屏的标记 */
@property (nonatomic,assign)BOOL allowRotation;

@end

