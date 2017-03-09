//
//  SXHcModel.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXHcModel.h"

@implementation SXHcModel

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.docid forKey:@"docid"];
    [aCoder encodeObject:self.imgsrc forKey:@"imgsrc"];
    [aCoder encodeObject:self.skipID forKey:@"skipID"];
    [aCoder encodeObject:self.cout forKey:@"cout"];
    [aCoder encodeObject:self.videoId forKey:@"videoId"];
}
//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.docid = [aDecoder decodeObjectForKey:@"docid"];
    self.imgsrc = [aDecoder decodeObjectForKey:@"imgsrc"];
    self.skipID = [aDecoder decodeObjectForKey:@"skipID"];
    self.cout = [aDecoder decodeObjectForKey:@"cout"];
    self.videoId = [aDecoder decodeObjectForKey:@"videoId"];
    return self;
}

@end
