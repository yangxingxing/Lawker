//
//  SXBhcModel.h
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXBhcModel : NSObject


@property (nonatomic, copy) NSString *title;
@property (nonatomic,copy) NSString *tai;
@property (nonatomic,copy) NSString *data;
@property (nonatomic,copy) NSString *info;
@property (nonatomic,copy) NSString *docid;
@property (nonatomic,strong)NSMutableArray *bodylist;

@end
