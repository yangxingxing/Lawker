//
//  SXShovModel.h
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights resShoved.
//

#import <Foundation/Foundation.h>

@interface SXShovModel : NSObject


@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *titlextra;
@property (nonatomic,copy) NSString *docid;
@property (nonatomic,copy) NSString *imgsrc;
@property (nonatomic,copy) NSString *skipID;
@property (nonatomic,strong)NSArray *orderextra;
@property (nonatomic,strong)NSArray *listextra;

@end
