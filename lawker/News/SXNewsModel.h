//
//  SXNewsModel.h
//  lawker
//
//  Created by 董 尚先 on 15-1-22.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXNewsModel : NSObject

@property (nonatomic,copy) NSString *title; // 标题
@property (nonatomic,strong)NSArray *titlextra;
@property (nonatomic,strong)NSArray *imgextra;
@property (nonatomic,strong)NSArray *txtextra;
@property (nonatomic,strong)NSArray *replyCountextra;
@property (nonatomic,strong)NSNumber *imgCount;
@property (nonatomic,copy)NSNumber *hasHead;
@property (nonatomic,copy) NSString *moreTitle;
@property (nonatomic,copy) NSString *titleType;
@property (nonatomic,copy) NSString *nexSian;
@property (nonatomic,strong)NSArray *docidextra;
@property (nonatomic,copy)NSNumber *replyCount;
@property (nonatomic,copy) NSString *docid;
@property (nonatomic,copy) NSString *imgsrc; 
@property (nonatomic,copy) NSString *skipID;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy)NSNumber *imgType;

@end
